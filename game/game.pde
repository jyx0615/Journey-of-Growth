import ddf.minim.*;
// this is the main game file for the Doodle Jump game

enum State {
  START,
  ABOUTUS,
  LEVEL1,
  LEVEL2,
}

PFont TCFont, TCFontBold, ChocolateFont;

class Game {
  PImage startBackground, startButtonImg, aboutUsButtonImg, playerImg;
  AudioPlayer openningMusic, level1Music, level2Music, click, gameOverSound;
  State state;
  DoodleJump doodleJump;
  Mihoyo mihoyo;
  String[] aboutUsLines;

  Game() {
    loadMusics();
    loadFonts();
    loadBackgroundImages();
    doodleJump = new DoodleJump();
    mihoyo = new Mihoyo();
    state = State.START;
    openningMusic.loop();

    // Load the about us content from the text file
    aboutUsLines = loadStrings("texts/aboutUs.txt");
  }

  void loadMusics() {
    openningMusic = minim.loadFile("musics/openning.mp3");
    level1Music = minim.loadFile("musics/level1.mp3");
    click = minim.loadFile("sounds/click.mp3");
    gameOverSound = minim.loadFile("sounds/gameover.mp3");
  }

  void loadFonts() {
    TCFont = createFont("fonts/Iansui-Regular.ttf", 15);
    TCFontBold = createFont("fonts/NotoSansTC-Bold.ttf", 15);
    ChocolateFont = createFont("fonts/ChocolateClassicalSans-Regular.ttf", 15);
  }

  void loadBackgroundImages() {
    startBackground = loadImage("backgrounds/startBackground.png");
    startButtonImg = loadImage("icons/button_start.png");
    aboutUsButtonImg = loadImage("icons/button_aboutUs.png");
    playerImg = loadImage("icons/player.png");
  }

  void reset() {
    doodleJump.reset();
    mihoyo.reset();

    level1Music.pause();
    level2Music.pause();
    click.pause();
    openningMusic.rewind();
    openningMusic.loop();
    
    state = State.START;
  }

  void draw() {
    switch(state) {
      case START:
        drawStartScreen();
        break;
      case ABOUTUS:
        drawAboutUsScreen();
        break;
      case LEVEL1:
        doodleJump.draw();
        break;
      case LEVEL2:
        mihoyo.draw();
        break;
    }
  }

  void drawStartScreen() {
    background(#88379B);
    imageMode(CENTER);
    image(startBackground, 400, 400, 800, 800);
    image(playerImg, 266, 466, 288, 288);
    image(startButtonImg, 266, 666, startBtnWidth, startBtnHeight);
    image(aboutUsButtonImg, 550, 533, aboutBtnWidth, aboutBtnHeight);
  }

  void drawAboutUsScreen() {
    drawStartScreen();

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
    for (int i = 0; i < aboutUsLines.length; i++) {
      text(aboutUsLines[i], width/2 -235, height/2 - 200 + (i * 30));
    }

    textAlign(CENTER, BOTTOM);
    textSize(20);
    text("點擊任意位置關閉", 400, 680);
  }

  void keyPressed() {
    if (state == State.LEVEL1) {
      doodleJump.keyPressed();
    } else if (state == State.LEVEL2) {
      mihoyo.keyPressed();
    }
  }

  void mousePressed() {
    switch (state) {
      case START:
        int aboutX = 550;
        int aboutY = 533;
        if (mouseX > aboutX - aboutBtnWidth/2 && mouseX < aboutX + aboutBtnWidth/2 &&
          mouseY > aboutY - startBtnHeight/2 && mouseY < aboutY + startBtnHeight/2) {
          click.rewind();
          click.play();
          state = State.ABOUTUS;
        }

        int startX = 266;
        int startY = 666;
        if (mouseX > startX - startBtnWidth/2 && mouseX < startX + startBtnWidth/2 &&
          mouseY > startY - aboutBtnHeight/2 && mouseY < startY + aboutBtnHeight/2) {
          click.rewind();
          click.play();
          state = State.LEVEL1;
          doodleJump.state = DoodleJumpState.START;
        }
        break;

      case ABOUTUS:
        state = State.START;
        break;

      case LEVEL1:
        doodleJump.mousePressed();
        break;

      case LEVEL2:
        mihoyo.mousePressed();
        break;
    }
  }

  void keyReleased() {
    if (state == State.LEVEL2) {
      mihoyo.keyReleased();
    }
  }
}

Game game;

void setup() {
  size(800, 800);
  surface.setLocation(500, 10);
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
  game.keyPressed();
}

void mousePressed() {
  game.mousePressed();
}

void keyReleased() {
  game.keyReleased();
}
