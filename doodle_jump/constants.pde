int FIRE_DURATION = 1200; // 20秒 × 60幀 = 1200
int FREEZE_DURATION = 300; // 5秒 × 60幀 = 300
int ROLE_ACTION_COUNT = 2;

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
int BLOCK_IMG_WIDTH = 50;
int ICONSIZE = 60;

// game properties
int []COLORS = {#EAD90E, #FF5733, #33FF57, #3357FF, #FFFF33, #FF3829, #000000};
String []subjects = {"文科", "理科", "音樂", "藝術", "體育"};
String []academics = {"文學院", "理學院", "音樂學院", "藝術學院", "體育學院"};

int restartX = 400;
int restartY = 500;
int restartWidth = 100;
int restartHeight = 40;


// quiz related constants
int questionX = width/2;
int questionY = 100;

int answerX = 300;
int answerY = 700;

int submitX = width/2;
int submitY = 600;
int submitWidth = 100;
int submitHeight = 40;

// multiple choice question text
int choicesX = 50;
int choicesY = 200;
int choicesOffsetY = 60;

// multiple choice buttons
int buttonX = 50;
int buttonY = 500;
int buttonWidth = 70;
int buttonHeight = 40;
int buttonOffsetX = 90;

// input question
int inputX = 80;
int inputY = 400;
int inputWidth = 300;
int inputHeight = 40;
int INPUT_MAX_LENGTH = 20;


Minim minim = new Minim(this);
PFont TCFont;
DoodleJump doodleJump;