#ifdef VERTEX_SHADER

uniform mat4 view = mat4(1.f);
uniform mat4 proj = mat4(1.f);
#line 5

out vec2 vCoord;
void main(){
  if(gl_VertexID>=6)return;

  mat4 mvp = proj*view;

  if(gl_VertexID==0){
    vCoord = vec2(0.f,0.f);
    gl_Position = mvp*vec4(-1.f,0.f,-1.f,1.f);
  }
  if(gl_VertexID==1){
    vCoord = vec2(1.f,0.f);
    gl_Position = mvp*vec4(+1.f,0.f,-1.f,1.f);
  }
  if(gl_VertexID==2){
    vCoord = vec2(0.f,1.f);
    gl_Position = mvp*vec4(-1.f,0.f,+1.f,1.f);
  }
  if(gl_VertexID==3){
    vCoord = vec2(0.f,1.f);
    gl_Position = mvp*vec4(-1.f,0.f,+1.f,1.f);
  }
  if(gl_VertexID==4){
    vCoord = vec2(1.f,0.f);
    gl_Position = mvp*vec4(+1.f,0.f,-1.f,1.f);
  }
  if(gl_VertexID==5){
    vCoord = vec2(1.f,1.f);
    gl_Position = mvp*vec4(+1.f,0.f,+1.f,1.f);
  }
}
#endif



#ifdef FRAGMENT_SHADER
in vec2 vCoord;
out vec4 fColor;
void main(){
  float dist = distance(vCoord,vec2(0.5f,0.5f));
  if(dist > 0.3f)fColor = vec4(1.f,1.f,1.f,1.f);
  else fColor = vec4(1.f,0.f,0.f,1.f);
}
#endif
