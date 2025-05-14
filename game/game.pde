import ddf.minim.*;

enum Status {
  START,
  ABOUTUS,
  LEVEL1,
  LEVEL2,
}

PFont TCFont, TCFontBold;

class Game {
  AudioPlayer openningMusic, level1Music, level2Music, click, resultMusic;
  Status gameStatus;
  DoodleJump doodleJump;
  PImage startBackground, startButtonImg, aboutUsButtonImg, playerImg;
  String[] lines;

  Game() {
    loadMusics();
    loadFonts();
    loadBackgroundImages();
    doodleJump = new DoodleJump();
    gameStatus = Status.START;
    openningMusic.loop();

    // Load the about us content from the text file
    lines = loadStrings("aboutUs.txt");
  }

  void loadMusics() {
    openningMusic = minim.loadFile("musics/openning.mp3");
    level1Music = minim.loadFile("musics/level1.mp3");
    level2Music = minim.loadFile("musics/level2.mp3");
    click = minim.loadFile("sounds/click.mp3");
    resultMusic = minim.loadFile("musics/result.mp3");
  }

  void loadFonts() {
    TCFont = createFont("fonts/Iansui-Regular.ttf", 15);
    TCFontBold = createFont("fonts/NotoSansTC-Bold.ttf", 15);
  }

  void loadBackgroundImages() {
    startBackground = loadImage("background/startBackground.png");
    startButtonImg = loadImage("icons/button_start.png");
    aboutUsButtonImg = loadImage("icons/button_aboutUs.png");
    playerImg = loadImage("icons/player.png");
  }

  void draw() {
    switch(gameStatus){
      case START:
        drawStartPage();
        break;
      case ABOUTUS:
        drawAboutUS();
        break;
      case LEVEL1:
        doodleJump.draw();
        break;
      case LEVEL2:
        break;
    }
  }

  void drawStartPage() {
    background(#88379B);
    imageMode(CENTER); 
    image(startBackground, 400, 400, 800, 800);
    image(playerImg,266, 466, 288, 288);
    image(startButtonImg, 266, 666, startBtnWidth, startBtnHeight);
    image(aboutUsButtonImg, 550, 533, aboutBtnWidth, aboutBtnHeight);
  }

  void drawAboutUS() {
    drawStartPage();
    
    textFont(TCFont);
    rectMode(CENTER);
    fill(255, 240);
    stroke(0);
    rect(width/2, height/2, 520, 600, 20);
    
    fill(0);
    textAlign(CENTER, TOP);
    textSize(30);
    text("關於我們", 400, 150);
    
    textAlign(LEFT, TOP);
    textSize(20);
    for (int i = 0; i < lines.length; i++) {
      text(lines[i], width/2 -235, height/2 - 200 + (i * 30));
    }
    
    textAlign(CENTER, BOTTOM);
    textSize(20);
    text("點擊任意位置關閉", 400, 680);
  }

  void keyPressedCheck() {
    if(gameStatus == Status.LEVEL1){
      doodleJump.keyPressedCheck();
    }
  }

  void mousePressedCheck() {
    switch (gameStatus) {
      case START:
        int aboutX = 550;
        int aboutY = 533;
        if (mouseX > aboutX - aboutBtnWidth/2 && mouseX < aboutX + aboutBtnWidth/2 && 
            mouseY > aboutY - startBtnHeight/2 && mouseY < aboutY + startBtnHeight/2)
          click.rewind();
          click.play();
          gameStatus = Status.ABOUTUS;
          

        int startX = 266;
        int startY = 666;
        if (mouseX > startX - startBtnWidth/2 && mouseX < startX + startBtnWidth/2 && 
            mouseY > startY - aboutBtnHeight/2 && mouseY < startY + aboutBtnHeight/2) {
          click.rewind();
          click.play();
          gameStatus = Status.LEVEL1;
          doodleJump.status = DoodleJumpStatus.START;
        }
        break;

      case ABOUTUS:
        gameStatus = Status.START;
        break;

      case LEVEL1:
        doodleJump.mousePressedCheck();
        break;
    }
  }
}

Game game;

void setup() {
  size(800, 800);
  surface.setLocation(500, 100);
  // set some constants
  submitX = width/2;
  questionX = width/2;
  answerX = width/2;
  restartX = width/2;

  game = new Game();
}

void draw() {
  game.draw();
}

void keyPressed() {
  game.keyPressedCheck();
}

void mousePressed() {
  game.mousePressedCheck();
}
