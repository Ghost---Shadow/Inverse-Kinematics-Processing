JointManager manager;
int count;
boolean paused;

void setup(){
  size(640,480);
  count = 3;
  paused = false;
  manager = new JointManager(count);
  
  fill(0);
  textSize(16);
}
void draw(){
  background(255);
  if(!paused)
    manager.updateAll();
  manager.drawAll();
}
void keyPressed(){
  if(key == ' ')
    paused = !paused;
  if(key == 't')
    manager.toggleDisplayText();
}

int offsetX,offsetY,index;
void mousePressed(){
    for(int i = 0; i < count; i++){
      if(mouseX > manager.joints[i].x - manager.sizeX
        && mouseX < manager.joints[i].x + manager.sizeX &&
        mouseY > manager.joints[i].y - manager.sizeY 
        && mouseY < manager.joints[i].y + manager.sizeY){
          index = i;
          break;
        }
    }
    offsetX = mouseX - int(manager.joints[index].x);
    offsetY = mouseY - int(manager.joints[index].y);
  }
  void mouseDragged(){
    manager.joints[index].x = mouseX - offsetX;
    manager.joints[index].y = mouseY - offsetY;
  }
