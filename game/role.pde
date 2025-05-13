class Role {
  float curV;
  int curX, curY;
  int curJumpCount, actionIndex;
  boolean jump, faceRight;
  PImage rockImg;
  PImage[] roleImgs = new PImage[3];
  PImage[] roleImgsLeft = new PImage[3];
  PImage[] roleFireImgs = new PImage[3];
  PImage[] roleFireImgsLeft = new PImage[3];

  Role() {
    loadRoleImages();
    reset();
  }

  void loadRoleImages() {
    roleFireImgs[0] = loadImage("roles/fire1.png");
    roleFireImgs[1] = loadImage("roles/fire2.png");
    roleFireImgs[2] = loadImage("roles/fire3.png");

    roleFireImgsLeft[0] = loadImage("roles/fire1L.png");
    roleFireImgsLeft[1] = loadImage("roles/fire2L.png");
    roleFireImgsLeft[2] = loadImage("roles/fire3L.png");

    roleImgs[0] = loadImage("roles/normal1.png");
    roleImgs[1] = loadImage("roles/normal2.png");
    roleImgs[2] = loadImage("roles/normal3.png");

    roleImgsLeft[0] = loadImage("roles/normal1L.png");
    roleImgsLeft[1] = loadImage("roles/normal2L.png");
    roleImgsLeft[2] = loadImage("roles/normal3L.png");
    
    rockImg = loadImage("roles/rock.png");
  }

  void reset() {
    curX = 300;
    curY = 539;
    curV = 0;
    curJumpCount = 0;
    jump = false;
    faceRight = true;
    actionIndex = 0;
  }

  void updateByKeyPress() {
    // move when not frozen
    if(game.doodleJump.freezeTimer == 0) {
      if(key == ' ' && curJumpCount < MAX_JUMP_COUNT) {
        jump = true;
        curV = JUMP_V0;
        curJumpCount += 1;
        game.doodleJump.jumpSound.rewind();
        game.doodleJump.jumpSound.play();
      }
      if(key == CODED) {
        if(keyCode == LEFT){
          faceRight = false;
          actionIndex = (actionIndex + 1) % ROLE_ACTION_COUNT;
          if(curX >= 20)
            curX -= 20;
        } else if(keyCode == RIGHT){
          faceRight = true;
          actionIndex = (actionIndex + 1) % ROLE_ACTION_COUNT;
          if(curX <= width - 20 - ROLE_WIDTH)
            curX += 20;
        }
      }
    }
  }

  void draw() {
    // if frozen use rock.png
    if(game.doodleJump.freezeTimer > 0){
      image(rockImg, curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
      return;
    }
    
    int indexToShow = actionIndex;
    if (jump){
      indexToShow = 2;
    }

    if(faceRight){
      if (game.doodleJump.fireTimer > 0)
        image(roleFireImgs[indexToShow], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
      else
        image(roleImgs[indexToShow], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
    } else {
      if (game.doodleJump.fireTimer > 0)
        image(roleFireImgsLeft[indexToShow], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
      else
        image(roleImgsLeft[indexToShow], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
    }
  }
}
