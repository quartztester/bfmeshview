#version 120

uniform sampler2D texture0; // base
uniform sampler2D texture1; // detail
uniform sampler2D texture2; // dirt
uniform sampler2D texture3; // crack
uniform sampler2D texture4; // detailN
uniform sampler2D texture5; // crackN

uniform int gamma;
uniform int matcap;
//uniform int hasBump;
uniform int hasAlpha;
uniform int hasDetail;
uniform int hasDirt;
uniform int hasCrack;
uniform int hasCrackN;
uniform int hasDetailN;
uniform int showDiffuse;
uniform int showSpecular;
uniform int showLighting;

uniform vec3 suncolor;
uniform vec3 skycolor;
uniform vec3 ambient;

varying vec2 uv0;
varying vec2 uv1;
varying vec2 uv2;
varying vec2 uv3;
varying vec2 uv4;
varying vec3 norm;
varying vec3 upvec;
varying vec3 sunvec;
varying vec3 eyesurfvec;         // eye to surface vector

varying vec3 eyepos;
varying vec3 fragpos;

void main()
{
 // base
 vec4 frag = vec4(1.0, 1.0, 1.0, 1.0);
 vec3 spec = vec3(1.0, 1.0, 1.0);
 
 // textures
 vec4 basemap    = texture2D(texture0, uv0);
 vec4 detailmap  = texture2D(texture1, uv1);
 vec4 dirtmap    = texture2D(texture2, uv2);
 vec4 crackmap   = texture2D(texture3, uv3);
 vec4 detailmapN;
 vec4 crackmapN;
 
 if (hasDirt > 0) {
  if (hasCrack > 0) {
   detailmapN = texture2D(texture4, uv1);
   crackmapN = texture2D(texture5, uv3);
  } else {
   detailmapN = texture2D(texture3, uv1);
  }
 } else {
  if (hasCrack > 0) {
   detailmapN = texture2D(texture3, uv1);
   crackmap = texture2D(texture2, uv2);
   crackmapN = texture2D(texture4, uv2);
  } else {
   detailmapN = texture2D(texture2, uv1);
  }
 }
 
 // diffuse
 if (showDiffuse > 0) {
  frag *= basemap;
  if (hasDetail > 0) {
   frag *= detailmap;
  }
 } else {
  frag.rgb *= 0.666;
 }
 
 // alpha
 if (hasAlpha > 0) {
  frag.a = detailmap.a;
 }
 
 // crack
 if (hasCrack > 0) {
  if (showDiffuse > 0) frag.rgb = mix(frag.rgb, crackmap.rgb, crackmap.a);
 }
 
 // dirt
 if (hasDirt > 0) {
  if (showDiffuse > 0) frag.rgb *= dirtmap.rgb;
  spec *= dirtmap.r*dirtmap.g*dirtmap.b;
 }
 
 // specular
 if (hasAlpha > 0) {
  if (hasDetailN > 0) {
   spec *= detailmapN.a;
  }
 } else {
  spec *= detailmap.a;
 }
 
 // normal
 vec3 n;
 if (hasDetailN > 0) {
  n = detailmapN.rgb * 2.0 - 1.0; // detail normal
  if (hasCrack > 0) {
   n = mix(n, crackmapN.rgb * 2.0 - 1.0, crackmap.a); // crack normal
  }
 } else {
  n = vec3(0.0, 0.0, 1.0); // vertex normal
 }
 n = normalize(n);
 
 // lighting
 if (showLighting > 0) {
	 float updot = dot(n,normalize(upvec));
  float NdotL = dot(n,normalize(-sunvec));
		if (gamma > 0) NdotL = 1.0 - pow(1.0 - NdotL, 2.2);
  frag.rgb *= mix(ambient, skycolor, updot*0.5+0.5) + suncolor * max(NdotL,0.0);
  
  // specular
  //if (NdotL > 0.0) {
   
			if (showSpecular == 0) spec = vec3(1.0);
			
   // half vector
   vec3 hv = normalize( normalize(-sunvec) + normalize(eyesurfvec) );
   
   // compute specular amount
   float NdotHV = max(dot(n,hv),0.0);
   spec *= pow(NdotHV,100.0);
   
   // apply specular
   frag.rgb += suncolor * spec;
  //}
 }
	
	// matcap
	if (matcap > 0) {
		vec3 btm = vec3( 92.0,  19.0,   2.0)/255.0;
		vec3 top = vec3(131.0,  62.0,  47.0)/255.0;
		vec3 ctr = vec3(138.0,  42.0,  20.0)/255.0;
		vec3 hlt = vec3(209.0, 156.0, 162.0)/255.0;
		
		//vec3 reflected = reflect(normalize( eyepos - fragpos ), vertNorm);
  //float m = 2.8284271247461903 * sqrt( reflected.z+1.0 ); //sqrt(8.0)
  //vec2 q = reflected.xy / m + 0.5;
		
		vec2 q = reflect( normalize(eyesurfvec), normalize(n) ).xy + 0.5;
		
		float d = (1.0 - length(q - vec2(0.5)));// 2.0;
		
		float hilite = clamp(pow(d, 10.0)*1.0, 0.0, 1.0);
		float circle = clamp(pow(d,  5.0)*3.0, 0.0, 1.0);
		
		vec3 matcap = mix(btm, top, 1.0-q.y);
		matcap = mix(matcap, ctr, circle);
		matcap = mix(matcap, hlt, hilite);
		
		frag.rgb = matcap;
	}
	
	//frag = detailmapN;
	
 // output
 gl_FragColor = frag;
 //gl_FragColor.rgb = n * 0.5 + 0.5;
}
