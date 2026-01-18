// =====================
// Global constants / enums
// =====================
const State = {
  START: "START",
  ABOUTUS: "ABOUTUS",
  LEVEL1: "LEVEL1",
  LEVEL2: "LEVEL2",
};

// =====================
// Global assets
// =====================
let TCFont, TCFontBold, ChocolateFont;
let startBackground, startButtonImg, aboutUsButtonImg, playerImg;
let openningMusic, level1Music, level2Music, clickSound, gameOverSound, resultMusic;
let aboutUsLines;
let doodleJumpIntroLines, doodleJumpRuleLines;
let mihoyoIntroLines;

// =====================
// Game class
// =====================
class Game {
  constructor() {
    this.state = State.START;
    this.audioStarted = false;

    this.doodleJump = new DoodleJump();
    this.mihoyo = new Mihoyo();
  }

  reset() {
    this.doodleJump.reset();
    this.mihoyo.reset();

    level1Music.stop();
    level2Music.stop();
    clickSound.stop();

    openningMusic.stop();
    openningMusic.loop();

    this.state = State.START;
  }

  draw() {
    switch (this.state) {
      case State.START:
        this.drawStartScreen();
        break;
      case State.ABOUTUS:
        this.drawAboutUsScreen();
        break;
      case State.LEVEL1:
        this.doodleJump.draw();
        break;
      case State.LEVEL2:
        this.mihoyo.draw();
        break;
    }
  }

  drawStartScreen() {
    background("#88379B");
    imageMode(CENTER);

    image(startBackground, 400, 400, 800, 800);
    image(playerImg, 266, 466, 288, 288);
    image(startButtonImg, 266, 666, startBtnWidth, startBtnHeight);
    image(aboutUsButtonImg, 550, 533, aboutBtnWidth, aboutBtnHeight);
  }

  drawAboutUsScreen() {
    this.drawStartScreen();

    textFont(TCFont);
    rectMode(CENTER);
    fill(255, 240);
    stroke(0);
    rect(width / 2, height / 2, 520, 600, 20);

    fill(0);
    textAlign(CENTER, TOP);
    textSize(30);
    text("關於我們", 400, 150);

    textAlign(LEFT, TOP);
    textSize(20);
    for (let i = 0; i < aboutUsLines.length; i++) {
      text(
        aboutUsLines[i],
        width / 2 - 235,
        height / 2 - 200 + i * 30
      );
    }

    textAlign(CENTER, BOTTOM);
    textSize(20);
    text("點擊任意位置關閉", 400, 680);
  }

  keyPressed() {
    if (this.state === State.LEVEL1) {
      this.doodleJump.keyPressed();
    } else if (this.state === State.LEVEL2) {
      this.mihoyo.keyPressed();
    }
  }

  keyReleased() {
    if (this.state === State.LEVEL2) {
      this.mihoyo.keyReleased();
    }
  }

  mousePressed() {
    // Start audio on first user interaction
    if (!this.audioStarted) {
      userStartAudio();
      openningMusic.loop();
      this.audioStarted = true;
    }

    switch (this.state) {
      case State.START: {
        const aboutX = 550;
        const aboutY = 533;

        if (
          mouseX > aboutX - aboutBtnWidth / 2 &&
          mouseX < aboutX + aboutBtnWidth / 2 &&
          mouseY > aboutY - startBtnHeight / 2 &&
          mouseY < aboutY + startBtnHeight / 2
        ) {
          clickSound.stop();
          clickSound.play();
          this.state = State.ABOUTUS;
        }

        const startX = 266;
        const startY = 666;

        if (
          mouseX > startX - startBtnWidth / 2 &&
          mouseX < startX + startBtnWidth / 2 &&
          mouseY > startY - aboutBtnHeight / 2 &&
          mouseY < startY + aboutBtnHeight / 2
        ) {
          clickSound.stop();
          clickSound.play();
          this.state = State.LEVEL1;
          this.doodleJump.state = DoodleJumpState.START;
        }
        break;
      }

      case State.ABOUTUS:
        this.state = State.START;
        break;

      case State.LEVEL1:
        this.doodleJump.mousePressed();
        break;

      case State.LEVEL2:
        this.mihoyo.mousePressed();
        break;
    }
  }
}

// =====================
// p5.js lifecycle
// =====================
let game;

function preload() {
  // Fonts
  TCFont = loadFont("assets/fonts/Iansui-Regular.ttf");
  TCFontBold = loadFont("assets/fonts/NotoSansTC-Bold.ttf");
  ChocolateFont = loadFont("assets/fonts/ChocolateClassicalSans-Regular.ttf");

  // Images
  startBackground = loadImage("assets/backgrounds/startBackground.png");
  startButtonImg = loadImage("assets/icons/button_start.png");
  aboutUsButtonImg = loadImage("assets/icons/button_aboutUs.png");
  playerImg = loadImage("assets/icons/player.png");

  // Audio
  openningMusic = loadSound("assets/musics/openning.mp3");
  level1Music = loadSound("assets/musics/level1.mp3");
  level2Music = loadSound("assets/musics/art.mp3");
  clickSound = loadSound("assets/sounds/click.mp3");
  gameOverSound = loadSound("assets/sounds/gameover.mp3");
  resultMusic = loadSound("assets/musics/result.mp3");

  // Text
  aboutUsLines = loadStrings("assets/texts/aboutUs.txt");
  doodleJumpIntroLines = loadStrings("assets/texts/doodle_jump_intro.txt");
  doodleJumpRuleLines = loadStrings("assets/texts/doodle_jump_rule.txt");
  mihoyoIntroLines = loadStrings("assets/texts/mihoyo_intro.txt");

  // Quiz JSON - Load as array
  quizJSON = loadJSON("assets/quiz.json");
}

function setup() {
  const canvas = createCanvas(800, 800);
  canvas.parent('p5-container');

  // Initialize global vectors
  weaponXY = createVector(0, 0);

  // constants you referenced
  submitX = width / 2;
  questionX = width / 2;
  answerX = width / 2;
  restartX = width / 2;

  game = new Game();
}

function draw() {
  game.draw();
}

function keyPressed() {
  game.keyPressed();
}

function keyReleased() {
  // Reset space key flag when space is released
  if (key === ' ' || keyCode === 32) {
    if (game.doodleJump) {
      game.doodleJump.role.resetSpaceKey();
    }
  }
  if (game != null)
    game.keyReleased();
}

function mousePressed() {
  game.mousePressed();
}
