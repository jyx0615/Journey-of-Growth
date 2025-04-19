// role properties
int curX = 300;
int curY = 539;
float curV = 0;
int cur_jump_count = 0;
boolean jump = false;
int BLOCK_IMG_WIDTH = 50;
boolean faceRight = true;
int actionIndex = 0;
boolean onFire = true;

int iconSize = 80;

// opperating settings
int MAX_JUMP_COUNT = 2;
float JUMP_V0 = -8;
float ACCELERATE = 0.3;
int LAYER_HEIGHT = 100;
int BLOCK_HEIGHT = 20;
int ROLE_HEIGHT = 61;
int ROLE_WIDTH = 33;
int MAX_LEVEL = 20;
int CANVA_SPEED = 10;
int CANVA_UP_SPEED = 5;
int SHOW_LEVEL_COUNT = 5;
int MOVE_CANVA_THRESHOLD = 300;

// game properties
int base = MAX_LEVEL - SHOW_LEVEL_COUNT;  // since we render 5 levels at a time
boolean canva_moving_down = false;
boolean canva_moving_up = true;
int canva_offset = 200;
int []COLORS = {#EAD90E, #FF5733, #33FF57, #3357FF, #FFFF33, #FF3829};
int []scores = {0, 0, 0, 0, 0};
String []subjects = {"literacture", "Math", "Music", "Art", "Sports"};

Block[] blocks;

PImage[] icons = new PImage[5];
PImage[] blockImgs = new PImage[5];
PImage[] roleImgs = new PImage[4];
PImage[] roleImgsLeft = new PImage[4];
PImage[] roleFireImgs = new PImage[4];
PImage[] roleFireImgsLeft = new PImage[4];
int ROLE_ACTION_COUNT = 4;
