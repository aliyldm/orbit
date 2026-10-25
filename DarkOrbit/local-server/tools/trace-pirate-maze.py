"""Trace red obstacle bars from the retained official minimap images.
Relative image geometry is evidence; scaling/clearance is a local approximation.
No source image is modified. Reproducible JSON output only.
"""
from PIL import Image
from pathlib import Path
import hashlib,json
out={"source":"Official Pirate Map FAQ images; 2px red-mask rectangle decomposition", "maps":{}}
for mid in [91,93]:
 p=Path('docs/evidence/pirate-5-'+str(mid-90)+'.jpg');im=Image.open(p).convert('RGB');w,h=im.size;cols,rows=w//2,h//2
 mask=[]
 for y in range(rows):
  row=[]
  for x in range(cols):
   count=0
   for oy in range(2):
    for ox in range(2):
     r,g,b=im.getpixel((x*2+ox,y*2+oy));count+=r>70 and r>g*2 and r>b*1.5
   row.append(count>=3 and (mid!=93 or x*2>=190))
  mask.append(row)
 rect=[]
 while True:
  heights=[0]*cols;best=(0,0,0,0,0)
  for y in range(rows):
   for x in range(cols):heights[x]=heights[x]+1 if mask[y][x] else 0
   stack=[]
   for x in range(cols+1):
    val=heights[x] if x<cols else 0;start=x
    while stack and stack[-1][1]>val:
     sx,hh=stack.pop();start=sx;area=(x-sx)*hh
     if area>best[0]:best=(area,sx,y-hh+1,x,y+1)
    if val and (not stack or stack[-1][1]<val):stack.append((start,val))
  area,x,y,x2,y2=best
  if area<6:break
  for yy in range(y,y2):
   for xx in range(x,x2):mask[yy][xx]=False
  if max(x2-x,y2-y)<4:continue
  rect.append([round(x*2/w*42000),round(y*2/h*26200),round(x2*2/w*42000),round(y2*2/h*26200)])
 out['maps'][str(mid)]={"image":str(p),"sha256":hashlib.sha256(p.read_bytes()).hexdigest(),"imageSize":[w,h],"worldSize":[42000,26200],"rectangles":rect}
 print(mid,len(rect),'walls')
Path('game/data/pirate-maze.json').write_text(json.dumps(out,indent=2)+'\n')
