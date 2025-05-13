ArrayList<Weapon> weapons = new ArrayList<Weapon>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

int curX = 300;
int curY = 400;
int maxCounter = 80;
int counter = maxCounter;
int heart = 0;
int weaponCounter = 0;
int WEAPENDURATION = 20;
PImage[] weaponImgs = new PImage[5];
int weaponR = 40;


void setup() {
  size(600, 800);
  weaponImgs[0] = loadImage("weapons/literature.png");
  weaponImgs[1] = loadImage("weapons/art.png");
  weaponImgs[2] = loadImage("weapons/music.png");
  weaponImgs[3] = loadImage("weapons/sports.png");
  weaponImgs[4] = loadImage("weapons/math.png");
}

void draw(){
  background(50);
  fill(230);
  circle(curX, curY, 100);
  
  for (int i = 0; i < weapons.size(); i++) {
    Weapon w = weapons.get(i);
    w.move();
    w.draw();
    if (w.out())
      weapons.remove(i);
  }
  
  for(int i = 0; i < enemies.size(); i ++){
    Enemy e = enemies.get(i);
    e.move();
    e.draw();
    if(e.getHit()){
      enemies.remove(i);
      continue;
    }
    if(e.hitRole()){
      enemies.remove(i);
      heart --;
    }
  }
  
  counter ++;
  if(counter >= maxCounter){
    counter = 0;
    enemies.add(getRandomEnemy());
    enemies.add(getRandomEnemy());
  }

  weaponCounter ++;
  if(weaponCounter == WEAPENDURATION){
    weaponCounter = 0;
    float theta = atan2(mouseY - curY, mouseX - curX);
    weapons.add(new Weapon(theta, 10));
  }
  
  textSize(50);
  fill(255);
  text("heart = " + heart, 20, 60);
}

Enemy getRandomEnemy() {
  int r = 400;
  float theta = random(0, 2 * PI);
  int x = int(r * cos(theta) + curX);
  int y = int(r * sin(theta) + curY);
  theta = atan2(curY - y, curX - x);
  Enemy enemy = new Enemy(x, y, theta, 3);
  return enemy;
}

// void mousePressed() {
//   float theta = atan2(mouseY - curY, mouseX - curX);
//   weapons.add(new Weapon(theta, 10));
// }
