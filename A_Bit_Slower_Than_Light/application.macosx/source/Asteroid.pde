class Asteroid {

  PVector loc, goal, speed;
  boolean isFuel, trapped, deleteMe;
  int size;
  color fuelColor;

  Asteroid() {
    this.size = 60;
    this.loc = new PVector(0, 0);
    this.goal = new PVector(width, height);
    this.isFuel = false;
    this.trapped = false;
    this.speed = new PVector((int)random(-5, 5), (int)random(-5, 5));
    this.deleteMe = false;
    this.fuelColor = #00E7FA;
  }

  void create() {
    float creationFloat = random(0, 1);
    float randWidth = random(100, 1100);
    float randHeight = random(100, 700);
    if (creationFloat < 0.25) {
      this.loc.x = width+2*size;
      this.loc.y = randHeight;
      this.speed.x = (int)random(-5, -1);
      this.speed.y = (int)random(-5, 5);
    } else if (creationFloat < 0.5) {
      this.loc.x = -2*size;
      this.loc.y = randHeight;
      this.speed.x = (int)random(1, 5);
      this.speed.y = (int)random(-5, 5);
    } else if (creationFloat < 0.75) {
      this.loc.x = randWidth;
      this.loc.y = -2*size;
      this.speed.x = (int)random(-5, 5);
      this.speed.y = (int)random(1, 5);
    } else {
      this.loc.x = randWidth;
      this.loc.y = height + 2*size;
      this.speed.x = (int)random(-5, 5);
      this.speed.y = (int)random(-5, -1);
    }
  }

  void update() {
    if (!this.isFuel) {
      noStroke();
      fill(#A0A0A0);
      ellipse(this.loc.x, this.loc.y, this.size, this.size);
      this.loc.x = this.loc.x+this.speed.x;
      this.loc.y = this.loc.y+this.speed.y;

      if (this.loc.x < width - this.size/2 && this.loc.x > this.size/2 && this.loc.y < height - this.size/2 && this.loc.y > this.size/2) {
        this.trapped = true;
      }

      if (this.trapped) {
        if (this.loc.x > width) {
          this.loc.x = width;
          this.speed.x = -this.speed.x;
        }
        if (this.loc.y > height) {
          this.loc.y = height;
          this.speed.y = -this.speed.y;
        }
        if (this.loc.x < 0) {
          this.loc.x = 0;
          this.speed.x = -this.speed.x;
        }
        if (this.loc.y < 0) {
          this.loc.y = 0;
          this.speed.y = -this.speed.y;
        }
      }
    }
    if (this.isFuel && !this.deleteMe) {
      noStroke();
      fill(this.fuelColor);
      ellipse(this.loc.x, this.loc.y, this.size/2, this.size/2);
    }
    if (this.deleteMe) {
      noStroke();
      //fill(#000000);
      //ellipse(this.loc.x, this.loc.y, this.size/2, this.size/2);
    }
  }

  void killMe() {
    this.deleteMe = true; 
  }

  void mined() {
    this.isFuel = true;
  }
  
  void changeColor(color co) {
    this.fuelColor = co;
  }

  boolean offScreen() {
    //return this.pos.x < 0 || this.pos.x > width || this.pos.y < 0 || this.pos.x > height;
    return this.loc.x > width + 2*size || this.loc.x < -2*size || this.loc.y < -2*size;
  }

  boolean belowScreen() {
    return this.loc.y > height + 2*size;
  }
}
