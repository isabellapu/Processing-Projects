class Eye {
  
  PVector outerEye, iris, pupil, flash, pos, mouse, irisgoal, pupilgoal, flashgoal;
  boolean bouncing;
  color irisColor;
  
  Eye(int myx, int myy, int whiteSize, int irisSize, color irisColor){ 
    outerEye = new PVector(whiteSize, whiteSize);
    iris = new PVector(irisSize, irisSize);
    pupil = new PVector(irisSize/2.5, irisSize/2.5);
    flash = new PVector(irisSize/8, irisSize/8);
    pos = new PVector(myx, myy);
    mouse = new PVector();
    irisgoal = new PVector();
    pupilgoal = new PVector();
    flashgoal = new PVector();
    bouncing = false;
    this.irisColor = irisColor;
  }

void update() {
  mouse.set(mouseX, mouseY);
  irisgoal = PVector.sub(mouse, pos);
  irisgoal.limit(outerEye.x/2-iris.x/2);
  irisgoal.add(pos);
  pupilgoal = PVector.sub(mouse, pos);
  pupilgoal.limit(outerEye.x/2 - pupil.x/2);
  pupilgoal.add(pos);
  flashgoal = PVector.sub(mouse, pos);
  flashgoal.limit(outerEye.x/2 - flash.x/2);
  flashgoal.add(pos);
  stroke(255, 255, 255);
  fill(255, 255, 255);
  ellipse(pos.x, pos.y, outerEye.x, outerEye.y);
  stroke(this.irisColor);
  fill(this.irisColor);
  //fill(160, 35, 245);
  ellipse(irisgoal.x, irisgoal.y, iris.x, iris.y);
  stroke(0);
  fill(0);
  ellipse(pupilgoal.x, pupilgoal.y, pupil.x, pupil.y);
  stroke(255);
  fill(255);
  ellipse(flashgoal.x, flashgoal.y, flash.x, flash.y);
  
  if(dist(pos.x,pos.y, mouseX, mouseY) < outerEye.x / 2) {
    if(mousePressed) {
      pos.x = mouseX;
      pos.y = mouseY;
    }
  }
  
  if (bouncing) {
    bounce();
  } else {
    stagnant();
  }
  
}

void bounce() {
}

void stagnant() {
}

}