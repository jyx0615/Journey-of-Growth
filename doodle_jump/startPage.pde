int buttonW = 112, buttonH = 80;
PImage startBackground, startButtonImg, aboutUsButtonImg, helpButtonImg, playerImg, game1background, gameoverbackground, restartButtonImg;
PImage[] symbols = new PImage[8];
PImage[] resultBackgrounds = new PImage[8];

String aboutUsContent = "組員分工：";
String helpContent = "遊戲規則：";
boolean showAboutUs = false;
boolean showHelp = false;


void drawStartPage() {
  background(#88379B);
  imageMode(CENTER); 
  image(startBackground, width/2, height/2, 800, 800);
  image(playerImg, width/3, height/6*5-200, 288, 288);
  image(startButtonImg, width/3, height/6*5, buttonW, buttonH);
  image(helpButtonImg, width/11*7, height/2, buttonW, buttonH);
  image(aboutUsButtonImg, width/11*9, height/6*4, buttonW+10, buttonH);
  
  // 顯示關於我們或遊戲規則
  if (showAboutUs) {
    drawInfoBox("關於我們", aboutUsContent);
  } else if (showHelp) {
    drawInfoBox("遊戲規則", helpContent);
  }
}

void drawInfoBox(String title, String content) {
  textFont(TCFont);
  rectMode(CENTER);
  fill(255, 240);
  stroke(0);
  rect(width/2, height/2, 400, 500, 20);
  
  fill(0);
  textAlign(CENTER, TOP);
  textSize(30);
  text(title, width/2, height/2 - 200);
  
  textAlign(LEFT, TOP);
  textSize(20);
  text(content, width/2 - 180, height/2 - 150);
  
  textAlign(CENTER, BOTTOM);
  textSize(15);
  text("點擊任意位置關閉", width/2, height/2 + 240);
}
