// role properties
int curX = 300;
int curY = 539;
float curV = 0;
int cur_jump_count = 0;
boolean jump = false;
int BLOCK_IMG_WIDTH = 50;
boolean faceRight = true;
int actionIndex = 0;
boolean onFire = false;

int fireTimer = 0;
int FIRE_DURATION = 1200; // 20秒 × 60幀 = 1200
boolean frozen = false;
int freezeTimer = 0;
int FREEZE_DURATION = 300; // 5秒 × 60幀 = 300

int iconSize = 70;

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
int []COLORS = {#EAD90E, #FF5733, #33FF57, #3357FF, #FFFF33, #FF3829, #000000};
int []scores = {0, 0, 0, 0, 0};
String []subjects = {"literacture", "Math", "Music", "Art", "Sports"};
boolean gameOver = false;

int restartX = 400;
int restartY = 500;
int restartWidth = 100;
int restartHeight = 40;

Block[] blocks;

PImage[] icons = new PImage[8];
PImage[] blockImgs = new PImage[8];
PImage[] roleImgs = new PImage[3];
PImage[] roleImgsLeft = new PImage[3];
PImage[] roleFireImgs = new PImage[3];
PImage[] roleFireImgsLeft = new PImage[3];
int ROLE_ACTION_COUNT = 2;
PImage rockImg;


PImage quizBackground;
PImage quizStartBackground;

// quiz related constants
String question = "";
int questionX = width/2;
int questionY = 100;
int correct = 0;   // 0 => not answer, 1 => wrong, 2 => right

int answerChoice = 2;
String answer = "";
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
String []choices;
int activateBtn = -1;    // -1 => no choice is selected

// multiple choice buttons
int buttonX = 50;
int buttonY = 500;
int buttonWidth = 70;
int buttonHeight = 40;
int buttonOffsetX = 90;

// input question
String inputText = "";
int inputX = 80;
int inputY = 400;
int inputWidth = 300;
int inputHeight = 40;
int inputMaxLength = 20;

int type = 2; // 1 => multiple choice, 2 => input question
int questionIndex = 0;  // the index of the current question

JSONArray quizList;
PFont TCFont;

Minim minim;
AudioPlayer correctSound;
AudioPlayer wrongSound;
AudioPlayer jumpSound;
AudioPlayer pickSound;
AudioPlayer gameOverSound;

void loadSounds() {
  minim = new Minim(this);
  correctSound = minim.loadFile("sounds/correct.mp3");
  wrongSound = minim.loadFile("sounds/wrong.mp3");
  jumpSound = minim.loadFile("sounds/jump.mp3");
  pickSound = minim.loadFile("sounds/pick.mp3");
  gameOverSound = minim.loadFile("sounds/gameover.mp3");
}
