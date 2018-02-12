#version 120

uniform sampler2D texture0; // diffuse
uniform sampler2D texture1; // normal

uniform int gamma;
uniform int matcap;
uniform int hasBump;
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

void main()
{
 // base
 vec4 frag = vec4(1.0, 1.0, 1.0, 1.0);
 vec3 spec = vec3(1.0, 1.0, 1.0);
 
 // textures
 vec4 colormap = texture2D(texture0, uv);
 vec4 normalmap = texture2D(texture1, uv);
 
 // diffuse map
 if (showDiffuse > 0) {
  frag *= colormap;
 } else {
  frag.rgb *= 0.75;
  frag.a = colormap.a;
 }
 
 // normal
 vec3 n;
 if (hasBump > 0) {
  // normal map
  n = normalize(normalmap.rgb * 2.0 - 1.0);
  spec *= normalmap.a;
 } else {
  // vertex normal
  n = normalize(norm);
 }
 
 // lighting
 if (showLighting > 0) {
  float NdotL = dot(n,normalize(-sunvec));
		float updot = dot(n,upvec);
		if (gamma > 0) NdotL = 1.0 - pow(1.0 - NdotL, 2.2);
  frag.rgb *= mix(ambient, skycolor, updot*0.5+0.5) + suncolor * max(NdotL,0.0);
  
  // normalize eye to surface vector
  vec3 eyevec = normalize(eyesurfvec);
  
  // specular
  //if (NdotL > 0.0) {
   
			if (showSpecular == 0) spec = vec3(1.0);
			
   // get half vector
   vec3 hv = normalize( -sunvec + eyevec );
   
   // compute specular amount
   float NdotHV = max(dot(n,hv),0.0);
   spec *= pow(NdotHV,100.0);
   
   // apply specular
   frag.rgb += suncolor * spec;
  //}
 }
	
	if (matcap > 0) {
	 vec3 ctr = vec3(138.0, 42.0, 20.0)/255.0;
		vec3 btm = vec3(92.0, 19.0, 2.0)/255.0;
		vec3 top = vec3(131.0, 62.0, 47.0)/255.0;
		vec3 hlt = vec3(209.0, 156.0, 162.0)/255.0;
		
	 //vec2 matcap(vec3 eye, vec3 normal) {
  vec3 reflected = reflect(normalize(eyesurfvec), normalize(n) );
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 ); //sqrt(8.0)
  vec2 q = reflected.xy / m + 0.5;
		//q = uv;
		
		q = reflected.xy + 0.5;
		//q = (reflected.xy / sqrt(reflected.z+1.0)) + 0.5;
		
		float d = (1.0 - length(q - vec2(0.5))) ;// 2.0;
		
		float hilite = clamp(pow(d, 10.0)*1.0, 0.0, 1.0);
		float circle = clamp(pow(d,  5.0)*3.0, 0.0, 1.0);
		
		vec3 matcap = mix(btm, top, 1.0-q.y);
		matcap = mix(matcap, ctr, circle);
		matcap = mix(matcap, hlt, hilite);
		
		frag.rgb = matcap;
	}
 
 // output
 gl_FragColor = frag;
 
 //gl_FragColor = boneinfo*10.0;
}
