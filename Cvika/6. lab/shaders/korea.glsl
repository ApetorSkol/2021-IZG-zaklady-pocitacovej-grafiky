#ifdef VERTEX_SHADER

uniform mat4 view = mat4(1.f);
uniform mat4 proj = mat4(1.f);
#line 5

out vec2 vCoord;
void main(){
  vec2 verts[]= vec2[](
    vec2(-1.f,-1.f),
    vec2(+1.f,-1.f),
    vec2(-1.f,+1.f),
    vec2(-1.f,+1.f),
    vec2(+1.f,-1.f),
    vec2(+1.f,+1.f)
  );

  if(gl_VertexID>verts.length())return;

  vec2 size=vec2(3.f,2.f);
  gl_Position = proj*view*vec4(verts[gl_VertexID]*size/2.f,0.f,1.f);
  vCoord = verts[gl_VertexID]*.5f+.5f;
}
#endif



#ifdef FRAGMENT_SHADER

vec4 southKorea(in vec2 uv )
{    
  vec2 size = vec2(3.f,2.f);
  vec3 red  = vec3(0xCD,0x2E,0x3A)/vec3(255);
  vec3 blu  = vec3(0x00,0x47,0xA0)/vec3(255);

  uv *= size;
  
  vec2 center = size/2.f;
  
  vec3 diag[4];
  diag[0] = vec3(-center.y,-center.x,+center.x*center.y+center.y*center.x)/length(center);
  diag[1] = vec3(-center.y,+center.x,+center.x*center.y-center.y*center.x)/length(center);
  diag[2] = vec3(+center.x,-center.y,-center.x*center.x+center.y*center.y)/length(center);
  diag[3] = vec3(+center.x,+center.y,-center.x*center.x-center.y*center.y)/length(center);
  
  float distDiag[4];
  
  for(int i=0;i<4;++i)
    distDiag[i] = dot(diag[i],vec3(uv,1))*48.f;
  
  
  float topRight = float(distDiag[0] <0.f);
  
  float centerCircle = float(length((uv-center)*48.f                ) < 24.f);
  float smallCircle  = float(length((uv-center)*48.f-12.f*diag[2].xy) < 12.f);
  float smallCircle2 = float(length((uv-center)*48.f+12.f*diag[2].xy) < 12.f);
  float redRegion = clamp(topRight-smallCircle+smallCircle2,0.f,1.f);
  float bluRegion = (1.f-redRegion);
  
  vec3 col;
  
  col=(bluRegion*blu+redRegion*red)*centerCircle;
  col+=vec3(1.f-centerCircle);
  
  vec2 strip;
  vec2 str;
  
  for(int i=0;i<2;++i){
    strip[i] = float(
      abs(abs(distDiag[2+i])-44.f) <  8.f &&
          abs(distDiag[i  ])       < 12.f  
    );
    str[i]=float((uint(floor(abs(distDiag[2+i])/2.f))+1u)%3u>0u);
  }
  
  col*=vec3(1.f-clamp(dot(strip,str),0.f,1.f));
  
  float pieceRightBotton = float(
    abs(distDiag[0] ) >  1.f ||
        distDiag[2]   < 36.f
  );
  
  col+=vec3(1.f-pieceRightBotton);
  
  float pieceLeftBotton = float(
    abs(distDiag[1]     ) > 1.f || 
    abs(distDiag[3]+44.f) > 2.f
  );
  
  col+=vec3(1.f-pieceLeftBotton);
  
  float pieceRightTop = float(
        abs(distDiag[1]     )      >  1.f || 
    abs(abs(distDiag[3]-44.f)-6.f) >  2.f
  );
  
  col+=vec3(1.f-pieceRightTop);

  return vec4(col,1.0f);
}

in vec2 vCoord;
out vec4 fColor;
void main(){
  fColor = southKorea(vCoord);
}
#endif
