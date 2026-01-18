// =====================
// Timers & durations
// =====================
const FIRE_DURATION = 600;     // 10 seconds @ 60 FPS
const FREEZE_DURATION = 300;   // 5 seconds @ 60 FPS
let textTimer = 60;
let currentHint = "";

const ROLE_ACTION_COUNT = 2;
const BLOCK_IN_ONE_LEVEL = 4;

// =====================
// Operating settings
// =====================
const MAX_JUMP_COUNT = 2;
const JUMP_V0 = -12;
const ACCELERATE = 0.6;

const LAYER_HEIGHT = 100;
const BLOCK_HEIGHT = 20;
const ROLE_HEIGHT = 61;
const ROLE_WIDTH = 33;

// const MAX_LEVEL = 21;
const MAX_LEVEL = 6;

const CANVA_SPEED = 10;
const CANVA_UP_SPEED = 5;
const SHOW_LEVEL_COUNT = 5;
const MOVE_CANVA_THRESHOLD = 300;

const BLOCK_IMG_WIDTH = 50;
const ICONSIZE = 60;

// =====================
// Game properties
// =====================
const COLORS = [
  "#D9D9D9",
  "#DCBC40",
  "#D0BAE5",
  "#D6AAAA",
  "#A1D1C9",
  "#FF3829",
  "#000000",
];

const subjects = ["文科", "理科", "音樂", "藝術", "體育"];
const academics = ["文學院", "理學院", "音樂學院", "藝術學院", "體育學院"];
const filenames = [
  "literature",
  "science",
  "music",
  "art",
  "sports",
  "certificate",
  "clock",
  "quiz",
];

// =====================
// Restart button
// =====================
let restartX = 400;
let restartY = 500;
const restartWidth = 100;
const restartHeight = 40;

// =====================
// Quiz-related (positions dependent on canvas size)
// These must be initialized in setup()
// =====================
let quizJSON;
let questionX;
const questionY = 120;

let answerX = 480;
let answerY = 680;

let submitX;
const submitY = 600;
const submitWidth = 100;
const submitHeight = 40;

// =====================
// Multiple choice text
// =====================
const choicesX = 230;
const choicesY = 220;
const choicesOffsetY = 60;

// =====================
// Multiple choice buttons
// =====================
const buttonX = 230;
const buttonY = 500;
const buttonWidth = 70;
const buttonHeight = 40;
const buttonOffsetX = 90;

// =====================
// Input question
// =====================
const inputX = 260;
const inputY = 400;
const inputWidth = 300;
const inputHeight = 40;
const INPUT_MAX_LENGTH = 20;

// =====================
// Menu buttons
// =====================
const startBtnWidth = 140;
const startBtnHeight = 100;
const aboutBtnWidth = 140;
const aboutBtnHeight = 100;
const restartBtnWidth = 140;
const restartBtnHeight = 100;

// =====================
// Job / role information
// =====================
const jobTitles = ["律師", "科學家", "音樂家", "畫家", "運動員"];

const textColors = [
  "#D9D9D9",
  "#AF9224",
  "#D0BAE5",
  "#932E2E",
  "#668C86",
];

const textBgColors = [
  "#FFFFFF",
  "#000000",
  "#FFFFFF",
  "#000000",
  "#000000",
];

const textXs = [380, 400, 400, 400, 612];
const textY = 100;
const titleY = 180;

const workerXs = [626, 653, 159, 516, 583];
const workerYs = [499, 416, 458, 504, 549];
const workerWidths = [515, 520, 373, 504, 381];
const workerHeights = [515, 520, 373, 504, 381];

const monsterNames = [
  ["文", "英", "國"],
  ["微", "積", "分"],
  ["Do", "Re", "Me"],
  ["術", "美", "藝"],
  ["體", "球", "動"],
];

const skillDescriptions = [
  "丟出書本造成傷害",
  "用計算機丟出數字造成傷害",
  "畫面隨機一個位置出現音符\n在指定的拍數內點擊音符即對範圍造成傷害",
  "滑鼠拖曳範圍噴灑顏料造成範圍傷害",
  "丟出啞鈴造成範圍傷害",
];

const congratsText = "恭喜你成功畢業\n成為";

// =====================
// Global game state
// =====================
const v = 10;              // Speed limit
let space_CD;
let weaponXY;              // Weapon attack position for effect drawing

const WEAPON_COST = 20;
const WIN_CREDIT = 128;

let weapon_4_mode0_time = 0;
