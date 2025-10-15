#ifdef VERTEX_SHADER

uniform mat4 view = mat4(1.f);
uniform mat4 proj = mat4(1.f);
#line 5

void main(){
  if(gl_VertexID>2)return;
  gl_Position=vec4(gl_VertexID,gl_VertexID/2,gl_VertexID/2,1.f);
}
#endif



#ifdef FRAGMENT_SHADER
out vec4 fColor;
void main(){
  fColor = vec4(1.f);
}
#endif
