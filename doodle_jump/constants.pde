// role properties
int curX = 300;
int curY = 720;
float curV = 0;
int cur_jump_count = 0;
boolean jump = false;

// opperating settings
int MAX_JUMP_COUNT = 2;
float JUMP_V0 = -10;
float ACCELERATE = 0.3;
int LAYER_HEIGHT = 150;
int BLOCK_HEIGHT = 30;
int ROLE_HEIGHT = 80;
int ROLE_WIDTH = 20;
int MAX_LEVEL = 20;
int CANVA_SPEED = 10;
int CANVA_UP_SPEED = 5;

int iconSize = 60;

// game properties
int base = MAX_LEVEL - 5;  // since we render 5 levels at a time
boolean canva_moving_down = false;
boolean canva_moving_up = true;
int canva_offset = 200;
int []COLORS = {#EAD90E, #FF5733, #33FF57, #3357FF, #FFFF33, #FF3829};

class Block {
  int left, level, blockWidth, type;
  Block(int blockLeft, int blockLevel, int blockWidthIn, int blockType) {
    left = blockLeft;
    level = blockLevel;
    blockWidth = blockWidthIn;
    type = blockType;
  }
}

Block[] blocks;

// for image
PImage img1, img2, img3, img4, img5;

//for icon
ArrayList<Icon> icons = new ArrayList<Icon>();
class Icon {
  int imgX, worldY, type;
  boolean active;
  Icon(int x, int y, int t) {
    imgX = x;
    worldY = y;
    type = t;
    active = true;
  }
}
