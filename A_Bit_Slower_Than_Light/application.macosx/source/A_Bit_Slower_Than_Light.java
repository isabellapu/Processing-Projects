import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class A_Bit_Slower_Than_Light extends PApplet {

Ship felicity;
PImage gameOverScreen, instructions, title, won;
boolean shield;
ArrayList<Bullet> shots = new ArrayList<Bullet>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
ArrayList<Pirate> pirates = new ArrayList<Pirate>();
boolean shooting = true, titlePage, instPage, moveInst, startgame;
float shootCount;
boolean restart = false;
int sectorNumber = 1, time, pTime, actualAst;

public void setup() {
  
  background(255, 255, 255);
  gameOverScreen = loadImage("gameOver.jpg");
  title = loadImage("title.jpg");
  instructions = loadImage("instructions.jpg");
  won = loadImage("won.jpg");
  imageMode(CENTER);
  gameOverScreen.loadPixels();
  title.loadPixels();
  instructions.loadPixels();
  won.loadPixels();
  felicity = new Ship(width/2, height/2, 80, 45);
  shield = false;
  background(title);
  titlePage = true;
  instPage = false;
  moveInst = false;
  startgame = false;
  time = millis();
  pTime = millis();
  actualAst = 0;
}

public void draw() {
  actualAst = 0;
  if (moveInst) {
    background(instructions);
    instPage = true;
  }
  if (startgame) {
    background(0);
    felicity.updateShip();
    felicity.updateGunner();
    if (shield) {
      felicity.shield();
    }
    if (mousePressed) {
      if (mouseButton == LEFT) {
        if (shooting) {
          shots.add(new Bullet(10, 10));
          shooting = false;
          shootCount = 0;
        }
      }
      if (!shooting) {
        shootCount += 1;
        if (shootCount == 10)
          shooting = true;
      }
    }

    for (int i = 0; i < asteroids.size(); i++) {
      if (!asteroids.get(i).isFuel || !asteroids.get(i).deleteMe) {
        actualAst += 1;
      } else {
        continue;
      }
      //if (asteroids.get(i).deleteMe) asteroids.remove(i);
    }

    if (millis() > time + 3000 && actualAst < 18) {
      Asteroid ast = new Asteroid();
      ast.create();
      asteroids.add(ast);
      time = millis();
    }

    for (int i = 0; i < asteroids.size(); i++) {
      asteroids.get(i).update();
      mineAsteroid(asteroids.get(i));
      //if (asteroids.get(i).deleteMe) asteroids.remove(i);
    }

    for (int a = 0; a < asteroids.size(); a++) {
      for (int b = 0; b < shots.size(); b++) {
        hitAsteroid(shots.get(b), asteroids.get(a));
      }
    }

    for (int i = 0; i < shots.size(); i++) {
      shots.get(i).update();
      if (shots.get(i).offScreen() || shots.get(i).deleteMe) shots.remove(i);
    }

    if (millis() > pTime + 6000 - (sectorNumber * 1000)) {
      Pirate pir = new Pirate(sectorNumber * 1.5f);
      pir.create();
      pirates.add(pir);
      pTime = millis();
    }

    for (int i = 0; i < pirates.size(); i++) {
      pirates.get(i).update();
      invadedPirate(pirates.get(i));
    }

    for (int a = 0; a < pirates.size(); a++) {
      for (int b = 0; b < shots.size(); b++) {
        killPirate(shots.get(b), pirates.get(a));
      }
    }

    felicity.updateHealth();
    felicity.updateFuel();

    stroke(0xffFFFFFF);
    noFill();
    rect(15, 15, 200, 35);
    rect(15, 55, 200, 35);

    if (felicity.gameOver()) {
      background(gameOverScreen);
      if (restart) {
        felicity.dead = false;
        felicity.health = 100;
        felicity.fuel = 0;
        shots.clear();
        asteroids.clear();
        pirates.clear();
        sectorNumber = 1;
      }
    }
    textSize(60);
    textAlign(CENTER, TOP);
    text("SECTOR " + sectorNumber, 160, 720);
  }

  if (sectorNumber > 5) {
    background(won);
  }
  //println(pirates.size());
  
}

public void hitAsteroid(Bullet b, Asteroid a) {
  if (!a.isFuel && b.pos.x < a.loc.x + a.size/2 && b.pos.x > a.loc.x - a.size/2 && b.pos.y > a.loc.y - a.size/2 && b.pos.y < a.loc.y + a.size/2) {
    b.hitEnemy();
    a.mined();
  }
}

public void mineAsteroid(Asteroid a) {
  if (a.isFuel && !a.deleteMe) {
    if (mousePressed) {
      if (mouseButton == RIGHT) {
        if (mouseX < a.loc.x + a.size/2 && mouseX > a.loc.x - a.size/2 && mouseY > a.loc.y - a.size/2 && mouseY < a.loc.y + a.size/2) {
          a.killMe();
          felicity.fuelIncrease();
        }
      }
    }
    if (mouseX < a.loc.x + a.size/2 && mouseX > a.loc.x - a.size/2 && mouseY > a.loc.y - a.size/2 && mouseY < a.loc.y + a.size/2) {
      a.changeColor(0xffFF1C37);
    } else {
      int blu = 0xff00E7FA;
      a.changeColor(blu);
    }
  }
}

public void killPirate(Bullet b, Pirate p) {
  
  if (!p.boarded && !p.dead && b.pos.x < p.loc.x + p.size/2 && b.pos.x > p.loc.x - p.size/2 && b.pos.y > p.loc.y - p.size/2 && b.pos.y < p.loc.y + p.size/2) {
    b.hitEnemy();
    p.dead = true;
  }
  
}

public void invadedPirate(Pirate p) {
  if (p.boarded && p.hurt) {
    if (shield) {
      shield = false;
    } else {
      felicity.healthDecrease();
    }
    p.hurt = false;
  }
}

public void changeSector() {
  sectorNumber += 1;
  felicity.fuel = 0;
  asteroids.clear();
  shots.clear();
  pirates.clear();
}

public void keyPressed() {
  if (key == ' ') {
    if (titlePage) {
      moveInst = true;
    }
    if (instPage) {
      moveInst = false;
      startgame = true;
    }
    if (felicity.dead) {
      restart = true;
    }
  }

  if (key == 'j') {
    if (felicity.fuel >= 100) {
      changeSector();
    }
  }

  if (key == 's') {
    if (felicity.fuel >= 20) {
      shield = true;
      felicity.fuelDecrease();
      felicity.fuelDecrease();
    }
  }

}

public void keyReleased() {
  if (key == ' ') { 
    restart = false;
  }

}
class Asteroid {

  PVector loc, goal, speed;
  boolean isFuel, trapped, deleteMe;
  int size;
  int fuelColor;

  Asteroid() {
    this.size = 60;
    this.loc = new PVector(0, 0);
    this.goal = new PVector(width, height);
    this.isFuel = false;
    this.trapped = false;
    this.speed = new PVector((int)random(-5, 5), (int)random(-5, 5));
    this.deleteMe = false;
    this.fuelColor = 0xff00E7FA;
  }

  public void create() {
    float creationFloat = random(0, 1);
    float randWidth = random(100, 1100);
    float randHeight = random(100, 700);
    if (creationFloat < 0.25f) {
      this.loc.x = width+2*size;
      this.loc.y = randHeight;
      this.speed.x = (int)random(-5, -1);
      this.speed.y = (int)random(-5, 5);
    } else if (creationFloat < 0.5f) {
      this.loc.x = -2*size;
      this.loc.y = randHeight;
      this.speed.x = (int)random(1, 5);
      this.speed.y = (int)random(-5, 5);
    } else if (creationFloat < 0.75f) {
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

  public void update() {
    if (!this.isFuel) {
      noStroke();
      fill(0xffA0A0A0);
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

  public void killMe() {
    this.deleteMe = true; 
  }

  public void mined() {
    this.isFuel = true;
  }
  
  public void changeColor(int co) {
    this.fuelColor = co;
  }

  public boolean offScreen() {
    //return this.pos.x < 0 || this.pos.x > width || this.pos.y < 0 || this.pos.x > height;
    return this.loc.x > width + 2*size || this.loc.x < -2*size || this.loc.y < -2*size;
  }

  public boolean belowScreen() {
    return this.loc.y > height + 2*size;
  }
}
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

  public void update() {
    stroke(0xffFFFFFF);
    fill(0xffFFFFFF);
    this.pos.x = this.pos.x + cos(this.rotation/180*PI)*this.speed;
    this.pos.y = this.pos.y + sin(this.rotation/180*PI)*this.speed;
    ellipse(this.pos.x, this.pos.y, this.bulletSize, this.bulletSize);
  }

  public boolean offScreen() {
    return this.pos.x > width || this.pos.x < 0 || this.pos.y < 0 || this.pos.y > height;
  }

  
  public void hitEnemy() {
   this.deleteMe = true; 
  }
}
class Pirate {

  float speed, size;
  PVector loc, vel, goal, target;
  boolean boarded, hurt, dead;
  int[] colors = {0xffFE4BFF, 0xff79FF4D, 0xffBC7EFF, 0xffFFAA0A, 0xffDAFF0A, 0xffFF246A};
  int myColor;

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

  public void create() {
    float creationFloat = random(0, 1);
    float randWidth = random(100, 1100);
    float randHeight = random(100, 700);
    if (creationFloat < 0.25f) {
      this.loc.x = width+2*size;
      this.loc.y = randHeight;
    } else if (creationFloat < 0.5f) {
      this.loc.x = -2*size;
      this.loc.y = randHeight;
    } else if (creationFloat < 0.75f) {
      this.loc.x = randWidth;
      this.loc.y = -2*size;
    } else {
      this.loc.x = randWidth;
      this.loc.y = height + 2*size;
    }
  }

  public void update() {
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
class Ship {

  PVector pos, mouse, gunner, gunnergoal, ship;
  int shipColor;
  float health = 100, max_health, fuel = 100, max_fuel;
  boolean dead = false;

  Ship(int xloc, int yloc, int size, int gunnersize) { 
    pos = new PVector(xloc, yloc);
    mouse = new PVector();
    gunner = new PVector(gunnersize, gunnersize);
    gunnergoal = new PVector();
    ship = new PVector(size, size);
    shipColor = 0xffFFFFFF;
    max_health = 100;
    this.health = 100;
    this.fuel = 0;
    max_fuel = 100;
    this.dead = dead;
  }

  public boolean gameOver() {
    return this.dead;
  }

  public void updateShip() {
    stroke(shipColor);
    fill(shipColor);
    ellipse(pos.x, pos.y, ship.x, ship.y);
  }

  public void updateGunner() {
    mouse.set(mouseX, mouseY);

    gunnergoal = PVector.sub(mouse, pos);
    gunnergoal.limit(ship.x-gunner.x/2-7);
    gunnergoal.add(pos);
    stroke(shipColor);
    fill(shipColor);
    ellipse(gunnergoal.x, gunnergoal.y, gunner.x, gunner.y);
  }

  public void shield() {
    noStroke();
    fill(0xff76DCFF, 80);
    ellipse(pos.x, pos.y, ship.x + gunner.x + 50, ship.y + gunner.x + 50);
  }

  public void updateHealth() {
    int myColor = 0xffFFFFFF;
    if (this.health < 25) {
      myColor = 0xffFF0000;
    } else if (this.health < 50) {
      myColor = 0xffFFC80F;
    } else {
      myColor = 0xff00FA2B;
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

  public void healthIncrease() {
    this.health += 10;
  }

  public void healthDecrease() {
    this.health -= 10;
  }

  public void updateFuel() {
    int myColor = 0xff00E7FA;
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

  public void fuelIncrease() {
    this.fuel += 10;
  }

  public void fuelDecrease() {
    this.fuel -= 10;
  }
}
  public void settings() {  size(1200, 800, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "A_Bit_Slower_Than_Light" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
