class Player {
  PVector XY, speed;
  PImage weaponImg, playerL, playerR;
  int     HP, ATK, MAX_HP;
  boolean faceRight = true; // 預設面向右側

  Player(PVector XY, PVector speed, int HP, int ATK, int career) {
    this.XY = XY;
    this.speed = speed;
    this.HP = HP;
    this.ATK = ATK;
    this.MAX_HP = HP;      // 初始血量即為最大血量上限
    weaponImg = loadImage("weapons/" + filenames[career] + ".png");
    playerL = loadImage("pic/playerL.png");
    playerR = loadImage("pic/playerR.png");
  }

  void draw() {
    if (faceRight) {
      image(playerR, width/2, height/2, 100, 100);
    } else {
      image(playerL, width/2, height/2, 100, 100);
    }

    image(weaponImg, width/2 + 40, height/2 + 25, 50, 50);

    textSize(20);
    textAlign(CENTER);
    if (space_CD > 0)
      space_CD -= 1;
    text("CD: " + space_CD/60, width/2, height/2 - 50);
    text("HP: " + HP, width/2, height/2 + 70);

    textSize(10);
    textAlign(RIGHT);
    text("XY: " + int(XY.x) + ", " + int(XY.y), width - 10, height - 30);
  }

  void keyPressed() {
    if (key == 'w' && speed.y > -v) speed.y -= v;
    if (key == 'a' && speed.x > -v) {
      speed.x -= v;
      faceRight = false;
    }
    if (key == 's' && speed.y <  v) speed.y += v;
    if (key == 'd' && speed.x <  v) {
      speed.x += v;
      faceRight = true;
    }
  }

  void keyReleased() {
    if (key == 'w' && speed.y <  v) speed.y += v;
    if (key == 'a' && speed.x <  v) speed.x += v;
    if (key == 's' && speed.y > -v) speed.y -= v;
    if (key == 'd' && speed.x > -v) speed.x -= v;
  }
}
