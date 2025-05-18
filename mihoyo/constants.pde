
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
String []filenames = {"literature", "science", "music", "art", "sports"};

String congratsText = "恭喜你成功畢業\n成為";
import ddf.minim.*;

// ─── 全域資源 ───
PFont  TCFont, TCFontBold;
Minim  minim;
AudioPlayer bgm, touch;
// ─── 全域狀態 ───
int v = 10;                  // 速度上限
int space_CD;
int WEAPON_COST = 1;        // 武器購買價格
int WIN_CREDIT = 55;        // 贏得遊戲所需學分

float weapon_4_mode0_time = 0;   // 啞鈴攻擊冷卻
Mihoyo game2;