#ifdef VERTEX_SHADER

uniform mat4 view = mat4(1.f);
uniform mat4 proj = mat4(1.f);
#line 5

out vec2 vCoord;
flat out int matrialId;

void drawQuad(int vId,vec2 size,vec2 offset,mat4 mvp,int material){
  if(vId==0){
    matrialId = material;
    vCoord = vec2(0.f,0.f);
    gl_Position = mvp*vec4(vec2(-1.f,-1.f)*size+offset,0.f,1.f);
  }
  if(vId==1){
    matrialId = material;
    vCoord = vec2(1.f,0.f);
    gl_Position = mvp*vec4(vec2(+1.f,-1.f)*size+offset,0.f,1.f);
  }
  if(vId==2){
    matrialId = material;
    vCoord = vec2(0.f,1.f);
    gl_Position = mvp*vec4(vec2(-1.f,+1.f)*size+offset,0.f,1.f);
  }
  if(vId==3){
    matrialId = material;
    vCoord = vec2(0.f,1.f);
    gl_Position = mvp*vec4(vec2(-1.f,+1.f)*size+offset,0.f,1.f);
  }
  if(vId==4){
    matrialId = material;
    vCoord = vec2(1.f,0.f);
    gl_Position = mvp*vec4(vec2(+1.f,-1.f)*size+offset,0.f,1.f);
  }
  if(vId==5){
    matrialId = material;
    vCoord = vec2(1.f,1.f);
    gl_Position = mvp*vec4(vec2(+1.f,+1.f)*size+offset,0.f,1.f);
  }
}

void main(){
  if(gl_VertexID>=12)return;

  mat4 mvp = proj*view;

  drawQuad(gl_VertexID  ,vec2(1.f,2.f/3.f),vec2(-2.f,0.f),mvp,0);

  drawQuad(gl_VertexID-6,vec2(1.f,2.f/3.f),vec2( 2.f,0.f),mvp,1);


}
#endif



#ifdef FRAGMENT_SHADER
flat in int matrialId;
in vec2 vCoord;
out vec4 fColor;

vec4 japan(vec2 uv){
  uv *= vec2(3,2);
  float dist = distance(uv,vec2(1.5,1));
  vec3 white = vec3(224,224,224)/vec3(255);
  vec3 red   = vec3(176,0  ,15 )/vec3(255); 
  return mix(vec4(white,1),vec4(red,1),float(dist<3./5.));
}

vec4 thailand(vec2 uv){
  uv *= vec2(9,6);
  vec3 white = vec3(0xf4,0xf5,0xf8)/vec3(255);
  vec3 red   = vec3(0xa5,0x19,0x31)/vec3(255); 
  vec3 blue  = vec3(0x2d,0x2a,0x4a)/vec3(255);
  float dist = abs(uv.y-3);
  if(dist<1)return vec4(blue,1);
  if(dist<2)return vec4(white,1);
  return vec4(red,1);
}

void main(){

  if(matrialId==0)fColor = japan   (vCoord);
  if(matrialId==1)fColor = thailand(vCoord);
}
#endif
