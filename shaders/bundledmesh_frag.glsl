#version 120

uniform sampler2D texture0; // diffuse
uniform sampler2D texture1; // normal
//uniform sampler2D texture2; // SpecularLUT
uniform sampler2D texture3; // wreck
uniform samplerCube envmap; // envmap

uniform int gamma;
uniform int matcap;
uniform int hasBump;
uniform int hasWreck;
uniform int hasAlpha;
uniform int hasEnvMap;
uniform int hasBumpAlpha;
uniform int showDiffuse;
uniform int showSpecular;
uniform int showLighting;

uniform vec3 suncolor;
uniform vec3 skycolor;
uniform vec3 ambient;

varying vec2 uv;
varying vec3 norm;
varying vec3 upvec;
varying vec3 sunvec;
varying vec3 eyesurfvec;         // eye to surface vector
varying vec4 boneinfo;

varying vec3 eyepos;
varying vec3 fragpos;
varying float debug;

void main()
{
 // base
 vec4 frag = vec4(1.0, 1.0, 1.0, 1.0);
 vec3 spec = vec3(1.0, 1.0, 1.0);
 
 // textures
 vec4 colormap = texture2D(texture0, uv);
 vec4 normalmap = texture2D(texture1, uv);
 vec4 wreckmap = texture2D(texture3, uv);
 
 //normalmap.r = 1.0 - normalmap.r;
 //normalmap.g = 1.0 - normalmap.g;
	
 // vertex normal
 vec3 vertNorm = normalize(norm);
 
 // diffuse
 if (showDiffuse > 0) {
  frag *= colormap;
 } else {
  frag.rgb *= 0.666;
  frag.a = colormap.a;
 }
 
 // alpha
 //if (hasBumpAlpha > 0) {
 // frag.a = normalmap.a;
 //} else {
 // frag.a = colormap.a;
 //}
 
 // wreck map
 if (hasWreck > 0) {
  if (showDiffuse > 0) {
   frag.rgb *= wreckmap.rgb;
  }
 }
 
 // normal
 vec3 n;
 if (hasBump > 0) {
  // normal map
  n = normalize(normalmap.rgb * 2.0 - 1.0);
 } else {
  // vertex normal
  //n = vertNorm;
		n = vec3(0.0, 0.0, 1.0);
 }
 
 // specular
 if (hasAlpha > 0) {
  if (hasBump > 0) {
   //if (hasBumpAlpha > 0) {
    spec *= normalmap.a;
   //} else {
   // spec *= colormap.a;
   //}
  }
 } else {
  spec *= colormap.a;
 }
 if (hasWreck > 0) {
  spec *= wreckmap.rgb;
 }
 
 // glass
 if (hasAlpha > 0) {
  if (hasEnvMap > 0) {
   vec3 v = normalize( eyepos - fragpos );
   frag.a += max(0.0, 1.0-dot(vertNorm,v));
  }
 }
 
 // lighting
	float updot = dot(n,normalize(upvec));
 float NdotL = dot(n,normalize(-sunvec));
	if (gamma > 0) NdotL = 1.0 - pow(1.0 - NdotL, 2.2);
 if (showLighting > 0) {
  frag.rgb *= mix(ambient, skycolor, updot*0.5+0.5) + suncolor * max(NdotL,0.0);
 }
 
 // envmap
 if (hasEnvMap > 0) {
  vec3 v = normalize( eyepos - fragpos );
  vec3 ref = reflect(v, vertNorm);
  vec4 env = textureCube(envmap, ref);
  frag.rgb = mix(frag.rgb, env.rgb, colormap.a);
 }
 
 // specular
 if (showLighting > 0) {
  //if (NdotL > 0.0) {
   
			if (showSpecular == 0) spec = vec3(1.0);
   
   // half vector
   vec3 hv = normalize( normalize(-sunvec) + normalize(eyesurfvec) );
   
   // compute specular amount
   float NdotHV = max(dot(n,hv),0.0);
   float specPow = pow(NdotHV,100.0);
   spec *= specPow;
   
   // apply specular
   frag.rgb += suncolor * spec;
   
   // glass specular
   if (hasEnvMap > 0) {
    if (hasAlpha > 0) {
     frag.a += specPow;
    }
   }
   
  //}
 }
	
	if (matcap > 0) {
		vec3 btm = vec3( 92.0,  19.0,   2.0)/255.0;
		vec3 top = vec3(131.0,  62.0,  47.0)/255.0;
		vec3 ctr = vec3(138.0,  42.0,  20.0)/255.0;
		vec3 hlt = vec3(209.0, 156.0, 162.0)/255.0;
		
  //vec3 reflected = reflect(normalize(eyesurfvec), normalize(n) );
		vec3 reflected = reflect(normalize( eyepos - fragpos ), vertNorm);
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 ); //sqrt(8.0)
  vec2 q = reflected.xy / m + 0.5;
		//q = uv;
		
		q = reflected.xy + 0.5;
		
		float d = (1.0 - length(q - vec2(0.5)));// 2.0;
		
		float hilite = clamp(pow(d, 10.0)*1.0, 0.0, 1.0);
		float circle = clamp(pow(d,  5.0)*3.0, 0.0, 1.0);
		
		vec3 matcap = mix(btm, top, 1.0-q.y);
		matcap = mix(matcap, ctr, circle);
		matcap = mix(matcap, hlt, hilite);
		
		frag.rgb = matcap;
	}
	
 // output
 gl_FragColor = frag;
}
