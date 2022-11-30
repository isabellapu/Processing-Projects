class Pirate {

  float speed, size;
  PVector loc, vel, goal, target;
  boolean boarded, hurt, dead;
  color[] colors = {#FE4BFF, #79FF4D, #BC7EFF, #FFAA0A, #DAFF0A, #FF246A};
  color myColor;

  Pirate(float speed) {
    this.speed = speed; 
    this.size = 80;
    this.loc = new PVector(0, 0);
    //this.vel = new PVector();
    this.goal = new PVector();
    this.target = new PVector(width/2, height/2);
    this.boarded = false;
    this.hurt = false;
    this.dead = false;
    this.myColor = colors[(int)random(0, 6)];
  }

  void create() {
    float creationFloat = random(0, 1);
    float randWidth = random(100, 1100);
    float randHeight = random(100, 700);
    if (creationFloat < 0.25) {
      this.loc.x = width+2*size;
      this.loc.y = randHeight;
    } else if (creationFloat < 0.5) {
      this.loc.x = -2*size;
      this.loc.y = randHeight;
    } else if (creationFloat < 0.75) {
      this.loc.x = randWidth;
      this.loc.y = -2*size;
    } else {
      this.loc.x = randWidth;
      this.loc.y = height + 2*size;
    }
  }

  void update() {
    if (!this.boarded && !this.dead) {
      noStroke();
      fill(this.myColor);
      this.goal = PVector.sub(this.target, this.loc);
      this.goal.normalize();
      this.goal.mult(this.speed);
      this.loc.add(this.goal);
      ellipse(this.loc.x, this.loc.y, this.size, this.size);
      if (Math.abs(this.loc.x - width/2) < 5 && Math.abs(this.loc.y - height/2) < 5) {
        this.boarded = true;
        this.hurt = true;
      }
    }
  }

}
