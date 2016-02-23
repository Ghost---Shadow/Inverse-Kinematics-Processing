class JointManager{
  private int sizeX,sizeY;
  private float resting;
  public PVector[] joints;
  private float[] theta;
  private float[] lastTheta;
  private float avgError;
  private float resetError;
  private float pi;
  private int count;  
  private int iterations;
  private boolean displayText;
  
  public JointManager(int count){
    this.count = count;
    joints = new PVector[count];
    theta = new float[count];
    lastTheta = new float[count];
    sizeX = sizeY = 10;
    avgError = .001;
    resetError = 1;
    iterations = 0;
    resting = width/((count+1));  
    displayText = true;
    for(int i = 0; i < count; i++){
      joints[i] = new PVector(0,0);
      joints[i].x = int((i+1) * width/(count+1));
      joints[i].y = int(height/2);
    }
    pi = (atan(1)*4);
  }
  
  public void drawAll(){
    text("Iterations: "+iterations,20,20);
    for(int i = 0; i < count; i++){
      ellipse(joints[i].x,joints[i].y,sizeX,sizeY);
      if(displayText && i != 0)
        text(theta[i], joints[i].x + 5, joints[i].y - 5);
    }
    for(int i = 1; i < count; i++){
      line(joints[i-1].x,joints[i-1].y,joints[i].x,joints[i].y);
      //line(joints[i+1].x,joints[i+1].y,joints[i].x,joints[i].y);      
    }
  }
  
  public void updateAll(){
    float totalError = 0;
    for(int i = 1; i < count; i++){
      PVector parent; 
      if(i != count - 1)
        parent = joints[i+1];
      else
        parent = new PVector(0,joints[i].y);
      PVector arm1 = PVector.sub(parent,joints[i]); arm1.normalize();
      PVector arm2 = PVector.sub(joints[i-1],joints[i]);arm2.normalize();      
      theta[i] = acos(arm1.dot(arm2)) * 180/pi;
      totalError += abs(theta[i] - lastTheta[i]);
      lastTheta[i] = theta[i];      
    }
    if(totalError/count > resetError){
      iterations = 0;
    }else if(totalError/count > avgError){
      iterations ++;
    }
    correctNeighbours();
  }
  private void correctNeighbours(){
    PVector mouse = new PVector(mouseX,mouseY);
    joints[0].x = mouse.x;
    joints[0].y = mouse.y;
    for(int i = 1; i < count; i++){
      float d = PVector.sub(joints[i],joints[i-1]).mag();
      float difference = (resting - d)/d;
      float dx = (joints[i].x-joints[i-1].x)*.5*difference;
      float dy = (joints[i].y-joints[i-1].y)*.5*difference;
      if(i != count - 1){
        joints[i].x += dx;
        joints[i].y += dy;
      }
      joints[i-1].x -= dx;
      joints[i-1].y -= dy;
    }
  }
  
  public void toggleDisplayText(){   
    displayText = !displayText;
  }  
}
