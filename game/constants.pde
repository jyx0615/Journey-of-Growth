int FIRE_DURATION = 600; // 10秒 × 60幀 = 600
int FREEZE_DURATION = 300; // 5秒 × 60幀 = 300
int ROLE_ACTION_COUNT = 2;
int BLOCK_IN_ONE_LEVEL = 4;

// opperating settings
int MAX_JUMP_COUNT = 2;
float JUMP_V0 = -12;
float ACCELERATE = 0.6;
int LAYER_HEIGHT = 100;
int BLOCK_HEIGHT = 20;
int ROLE_HEIGHT = 61;
int ROLE_WIDTH = 33;
int MAX_LEVEL = 10;
int CANVA_SPEED = 10;
int CANVA_UP_SPEED = 5;
int SHOW_LEVEL_COUNT = 5;
int MOVE_CANVA_THRESHOLD = 300;
int BLOCK_IMG_WIDTH = 50;
int ICONSIZE = 60;

// game properties
int []COLORS = {#D9D9D9, #DCBC40, #D0BAE5, #D6AAAA, #A1D1C9, #FF3829, #000000};
String []subjects = {"文科", "理科", "音樂", "藝術", "體育"};
String []academics = {"文學院", "理學院", "音樂學院", "藝術學院", "體育學院"};
String []filenames = {"literature", "science", "music", "art", "sports", "certificate", "clock", "quiz"};

int restartX = 400;
int restartY = 500;
int restartWidth = 100;
int restartHeight = 40;

// quiz related constants
int questionX = width/2;
int questionY = 100;

int answerX = 480;
int answerY = 680;

int submitX = width/2;
int submitY = 600;
int submitWidth = 100;
int submitHeight = 40;

// multiple choice question text
int choicesX = 230;
int choicesY = 200;
int choicesOffsetY = 60;

// multiple choice buttons
int buttonX = 230;
int buttonY = 500;
int buttonWidth = 70;
int buttonHeight = 40;
int buttonOffsetX = 90;

// input question
int inputX = 260;
int inputY = 400;
int inputWidth = 300;
int inputHeight = 40;
int INPUT_MAX_LENGTH = 20;

int startBtnWidth = 140;
int startBtnHeight = 100;
int aboutBtnWidth = 140;
int aboutBtnHeight = 100;
int restartBtnWidth = 140;
int restartBtnHeight = 100;

Minim minim = new Minim(this);

// 職業資訊
String[] jobTitles = {"律師", "科學家", "音樂家", "畫家", "運動員"};
color[] textColors = {#D9D9D9, #AF9224, #D0BAE5, #932E2E, #668C86};
color[] textBgColors = {color(255), color(0), color(255), color(0), color(0)};
int[] textXs = {380, 400, 400, 400, 612};
int textY = 100;
int titleY = 180;
int[] workerXs = {626, 653, 159, 516, 583};
int[] workerYs = {499, 416, 458, 504, 549};
int[] workerWidths = {515, 520, 373, 504, 381};
int[] workerHeights = {515, 520, 373, 504, 381};
String[][] m_names = {{"文", "英", "國"}, {"微", "積", "分"}, {"Do", "Re", "Me"}, {"術", "美", "藝"}, {"體", "球", "動"}};

String congratsText = "恭喜你成功畢業\n成為";

AudioPlayer bgm, touch;
// ─── 全域狀態 ───
int v = 10;                  // 速度上限
int space_CD;
int WEAPON_COST = 50;        // 武器購買價格
int WIN_CREDIT = 55;        // 贏得遊戲所需學分
float weapon_4_mode0_time = 0;   // 啞鈴攻擊冷卻
