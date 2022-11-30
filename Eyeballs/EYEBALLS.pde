boolean maker = false, kill = false;
ArrayList<Eye> e = new ArrayList<Eye>();
double backInt, themeInt;
int themeNos;
//color[] colorList = new color[]{color(#69D2E7), color(#A7DBD8), color(#E0E4CC), color(#F38630), color(#FA6900)};
//Eye z = new Eye(480, 100, 50, 22);
//Eye w = new Eye(350, 400, 70, 30);

void setup() {
  size(640, 480);
  background(255, 139, 139);
  themeInt = Math.random() * themeNos;
  backInt = Math.random() * 5;
  themeNos = 4;
    //outerEye = new PVector(50, 50);
    //pupil = new PVector(22, 22);
    //pos = new PVector(width/2, height/2);
    //mouse = new PVector();
    //irisgoal = new PVector();
    //pupilgoal = new PVector();
    //flashgoal = new PVector();
}

void draw() {
  color[] giantGoldfish = new color[]{color(#69D2E7), color(#A7DBD8), color(#E0E4CC), color(#F38630), color(#FA6900)};
  color[] melonBall = new color[]{color(#D1F2A5), color(#EFFAB4), color(#FFC48C), color(#FF9F80), color(#F56991)};
  color[] eatCake = new color[]{color(#774F38), color(#E08E79), color(#F1D4AF), color(#ECE5CE), color(#C5E0DC)};
  color[] thousandStories = new color[]{color(#F8B195), color(#F67280), color(#C06C84), color(#6C5B7B), color(#355C7D)};
  
  color[][] themes = new color[][]{giantGoldfish, melonBall, eatCake, thousandStories};
  double randInt = Math.random() * 5;
  background(themes[(int)(themeInt)][(int)backInt]);
  //background(139, 229, 255); sky blue
  //background(255, 178, 139); tan
  //background(255, 139, 139); pink
  if (maker) {
    e.add(new Eye(mouseX, mouseY, 100, 42, themes[(int)themeInt][(int)randInt]));
    maker = false;
  }
  for(int i = 0; i < e.size(); i++) {
    e.get(i).update();
  }
  if (kill) {
    backInt = Math.random() * 5;
    e.removeAll(e);
    kill = false;
  }

}

void newTheme() {
  themeInt = Math.random() * themeNos;
  backInt = Math.random() * 5;
  e.removeAll(e);
}

void keyReleased() {
  if (key == 'n') {
    maker = true;
  }
  if (key == 'c') {
    kill = true;
  }
  if (key == 'r') {
    newTheme();
  }
  if (key == ' ') {
    
  }
}


void update() {
  
}