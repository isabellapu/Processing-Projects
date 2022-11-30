class Bullet {

  int bulletSize;
  PVector pos;
  float prevX, prevY, rotation, speed;
  boolean deleteMe;

  Bullet(int bulletSize, float speed) { 
    this.bulletSize = bulletSize;
    this.speed = speed;
    prevX = mouseX;
    prevY = mouseY;
    this.pos = new PVector(width/2, height/2);
    this.rotation = atan2(prevY - this.pos.y, prevX - this.pos.x) / PI * 180;
    this.deleteMe = false;
  }

  void update() {
    stroke(#FFFFFF);
    fill(#FFFFFF);
    this.pos.x = this.pos.x + cos(this.rotation/180*PI)*this.speed;
    this.pos.y = this.pos.y + sin(this.rotation/180*PI)*this.speed;
    ellipse(this.pos.x, this.pos.y, this.bulletSize, this.bulletSize);
  }

  boolean offScreen() {
    return this.pos.x > width || this.pos.x < 0 || this.pos.y < 0 || this.pos.y > height;
  }

  
  void hitEnemy() {
   this.deleteMe = true; 
  }
}
