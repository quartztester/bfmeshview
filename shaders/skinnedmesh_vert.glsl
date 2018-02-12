#version 120

uniform int hasBump;

uniform mat4 nodetransform[40];
uniform vec3 eyeposworld;
uniform vec3 eyevecworld;
uniform vec3 sundirworld;

varying vec2 uv;
varying vec3 norm;
varying vec3 upvec;
varying vec3 sunvec;
varying vec3 eyesurfvec;         // eye to surface vector
varying vec4 boneinfo;

void main()
{
 // bone id
 int bone1 = int(gl_Color.r*255.0);
 int bone2 = int(gl_Color.g*255.0);
 
 // blend weight
 float blend = gl_MultiTexCoord1.s;
 
 // build bone matrix
 mat4 bonemat = mat4(0.0);
 bonemat += nodetransform[ bone1 ] * blend;
 bonemat += nodetransform[ bone2 ] * (1.0 - blend);
 //bonemat = normalize(bonemat);
 
 // transform vertex
 vec4 vert = bonemat * gl_Vertex;
 //vert = gl_Vertex; //// temp!!!
 
 // UV0
 uv = gl_MultiTexCoord0.st;
 
 // normal
 norm = gl_Normal;
 
 // eye to surface vector in world space
 eyesurfvec = eyeposworld - vert.xyz;
 
 // transform sunvec
 sunvec = (vec4(sundirworld,0.0) * bonemat).xyz;
 //sunvec = sunvecworld; //// temp!!!
 
	// up vector
	upvec = (vec4(0.0, 1.0, 0.0, 0.0) * bonemat).xyz;
	
 /*
 // tangent
 if (hasBump > 0) {
  
  // compute tangents
  vec3 tan1 = gl_MultiTexCoord5.xyz;
  vec3 tan2 = cross(norm,-tan1);
  
  // create tangent space rotation matrix
  mat3 rotmat = mat3(tan1,tan2,norm);
  
  // rotate local space sun vector to tangent space
  sunvec = sunvec * rotmat;
  
  // rotate local eye-to-surface to tangent space
  eyesurfvec = eyesurfvec * rotmat;
 }
 */
 
 boneinfo = gl_Color;
 
 // vertex position
 gl_Position = gl_ModelViewProjectionMatrix * vert;
}
