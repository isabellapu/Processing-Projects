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

void setup() {
  size(1200, 800, P2D);
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

void draw() {
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
      Pirate pir = new Pirate(sectorNumber * 1.5);
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

    stroke(#FFFFFF);
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

void hitAsteroid(Bullet b, Asteroid a) {
  if (!a.isFuel && b.pos.x < a.loc.x + a.size/2 && b.pos.x > a.loc.x - a.size/2 && b.pos.y > a.loc.y - a.size/2 && b.pos.y < a.loc.y + a.size/2) {
    b.hitEnemy();
    a.mined();
  }
}

void mineAsteroid(Asteroid a) {
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
      a.changeColor(#FF1C37);
    } else {
      color blu = #00E7FA;
      a.changeColor(blu);
    }
  }
}

void killPirate(Bullet b, Pirate p) {
  
  if (!p.boarded && !p.dead && b.pos.x < p.loc.x + p.size/2 && b.pos.x > p.loc.x - p.size/2 && b.pos.y > p.loc.y - p.size/2 && b.pos.y < p.loc.y + p.size/2) {
    b.hitEnemy();
    p.dead = true;
  }
  
}

void invadedPirate(Pirate p) {
  if (p.boarded && p.hurt) {
    if (shield) {
      shield = false;
    } else {
      felicity.healthDecrease();
    }
    p.hurt = false;
  }
}

void changeSector() {
  sectorNumber += 1;
  felicity.fuel = 0;
  asteroids.clear();
  shots.clear();
  pirates.clear();
}

void keyPressed() {
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

void keyReleased() {
  if (key == ' ') { 
    restart = false;
  }

}
