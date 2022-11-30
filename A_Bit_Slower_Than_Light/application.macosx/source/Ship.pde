class Ship {

  PVector pos, mouse, gunner, gunnergoal, ship;
  color shipColor;
  float health = 100, max_health, fuel = 100, max_fuel;
  boolean dead = false;

  Ship(int xloc, int yloc, int size, int gunnersize) { 
    pos = new PVector(xloc, yloc);
    mouse = new PVector();
    gunner = new PVector(gunnersize, gunnersize);
    gunnergoal = new PVector();
    ship = new PVector(size, size);
    shipColor = #FFFFFF;
    max_health = 100;
    this.health = 100;
    this.fuel = 0;
    max_fuel = 100;
    this.dead = dead;
  }

  boolean gameOver() {
    return this.dead;
  }

  void updateShip() {
    stroke(shipColor);
    fill(shipColor);
    ellipse(pos.x, pos.y, ship.x, ship.y);
  }

  void updateGunner() {
    mouse.set(mouseX, mouseY);

    gunnergoal = PVector.sub(mouse, pos);
    gunnergoal.limit(ship.x-gunner.x/2-7);
    gunnergoal.add(pos);
    stroke(shipColor);
    fill(shipColor);
    ellipse(gunnergoal.x, gunnergoal.y, gunner.x, gunner.y);
  }

  void shield() {
    noStroke();
    fill(#76DCFF, 80);
    ellipse(pos.x, pos.y, ship.x + gunner.x + 50, ship.y + gunner.x + 50);
  }

  void updateHealth() {
    color myColor = #FFFFFF;
    if (this.health < 25) {
      myColor = #FF0000;
    } else if (this.health < 50) {
      myColor = #FFC80F;
    } else {
      myColor = #00FA2B;
      //println("GREEN");
    }
    fill(myColor);
    noStroke();
    float drawWidth = (this.health / max_health) * 200;
    rect(15, 15, drawWidth, 35);

    if (this.health <= 0) {
      this.health = 0;
      this.dead = true;
    }
  }

  void healthIncrease() {
    this.health += 10;
  }

  void healthDecrease() {
    this.health -= 10;
  }

  void updateFuel() {
    color myColor = #00E7FA;
    fill(myColor);
    noStroke();
    if (this.fuel >= max_fuel) {
      this.fuel = max_fuel;
      textSize(40);
      textAlign(CENTER, TOP);
      text("PRESS J TO JUMP TO NEXT SECTOR", 750, 20);
    }
    float drawWidth = (this.fuel / max_fuel) * 200;
    rect(15, 55, drawWidth, 35);
  }

  void fuelIncrease() {
    this.fuel += 10;
  }

  void fuelDecrease() {
    this.fuel -= 10;
  }
}
