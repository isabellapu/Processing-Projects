float theta;

void setup() {
  size(640, 480);
  reset();
}

void draw() {
  background(255, 255, 255);
  frameRate(30);
  stroke(255, 175, 227);
  float a = (mouseX / (float) width) * 90f;
  theta = radians(a);
  translate(width/2,height);
  line(0,0,0,-150);
  translate(0,-150);
  branch(150);
}

void reset() {
  background(0, 0, 0);
}

void branch(float h) {
  h *= 0.67;
  if (h > 2) {
    pushMatrix();
    rotate(theta);  
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);     
    popMatrix();    
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}
