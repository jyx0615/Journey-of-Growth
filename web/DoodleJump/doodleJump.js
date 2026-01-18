// =====================
// Enum replacement
// =====================
const DoodleJumpState = {
  START: "START",
  RULE: "RULE",
  PLAYING: "PLAYING",
  GAMEOVER: "GAMEOVER",
  END: "END",
  QUIZ: "QUIZ",
};



// =====================
// DoodleJump class
// =====================
class DoodleJump {
  constructor() {
    this.role = new Role();
    this.quiz = new Quiz();

    this.blocks = [];
    this.state = DoodleJumpState.START;

    this.base = 0;
    this.canvaMoving = false;
    this.fireTimer = 0;
    this.freezeTimer = 0;
    this.textTimer = 0;
    this.canvaOffset = 0;

    this.scores = new Array(5).fill(0);
    this.questions = [];

    this.blockImgs = new Array(8);
    this.icons = new Array(8);

    this.symbol = null;
    this.resultBackground = null;
    this.weapon = null;

    this.background = null;
    this.gameoverbackground = null;
    this.restartButtonImg = null;
    this.envelopeBackground = null;
    this.door = null;

    this.introLines = [];
    this.intro = "";
    this.ruleLines = [];

    this.infoIndex = 0;
    this.typeInteval = 3;
    this.typeTime = 0;

    this.maxIndex = 0;
    this.maxScore = -1;
    this.doorX = 0;

    this.loadAssets();
    // Load questions after a small delay to ensure quizJSON is ready
    setTimeout(() => this.loadQuestions(), 100);
    this.reset();
  }

  // =====================
  // Asset loading (called AFTER preload)
  // =====================
  loadQuestions() {
    this.questions = [];

    if (!quizJSON) {
      console.error("quizJSON is not loaded");
      return;
    }

    // Convert object with numeric keys to array if needed
    let questionsArray;
    if (Array.isArray(quizJSON)) {
      questionsArray = quizJSON;
    } else {
      questionsArray = Object.values(quizJSON);
    }

    for (let i = 0; i < questionsArray.length; i++) {
      try {
        const qObj = questionsArray[i];
        const question = new Question(qObj);
        this.questions.push(question);
      } catch (e) {
        console.error("Failed to create Question from:", questionsArray[i], "Error:", e.message);
      }
    }
  }


  loadAssets() {
    this.correctSound = loadSound("assets/sounds/correct.mp3");
    this.wrongSound = loadSound("assets/sounds/wrong.mp3");
    this.jumpSound = loadSound("assets/sounds/jump.mp3");
    this.pickSound = loadSound("assets/sounds/pick.mp3");
    this.clockTicking = loadSound("assets/sounds/ClockTicking.mp3");

    for (let i = 0; i < filenames.length; i++) {
      this.icons[i] = loadImage(`assets/subjects/${filenames[i]}.png`);
    }

    this.blockImgs[0] = loadImage("assets/blocks/white.png");
    this.blockImgs[1] = loadImage("assets/blocks/yellow.png");
    this.blockImgs[2] = loadImage("assets/blocks/purple.png");
    this.blockImgs[3] = loadImage("assets/blocks/red.png");
    this.blockImgs[4] = loadImage("assets/blocks/green.png");
    this.blockImgs[5] = loadImage("assets/blocks/black.png");
    this.blockImgs[6] = loadImage("assets/blocks/black.png");
    this.blockImgs[7] = loadImage("assets/blocks/black.png");

    this.envelopeBackground = loadImage("assets/backgrounds/envelope.png");
    this.background = loadImage("assets/backgrounds/game1background.png");
    this.gameoverbackground = loadImage("assets/backgrounds/gameOver.jpg");
    this.restartButtonImg = loadImage("assets/icons/button_restart.png");
    this.door = loadImage("assets/icons/door.png");

    this.introLines = doodleJumpIntroLines || [];
    this.intro = this.introLines.join("\n");
    this.ruleLines = doodleJumpRuleLines || [];
  }

  loadResultImages(index) {
    this.symbol = loadImage(`assets/icons/${filenames[index]}Symbol.png`);
    this.resultBackground = loadImage(`assets/backgrounds/${filenames[index]}.png`);
    this.weapon = loadImage(`assets/weapons/${filenames[index]}.png`);
  }

  // =====================
  // Core logic
  // =====================
  reset() {
    this.role.reset();
    this.quiz.reset();

    this.blocks = this.randomGenBlocks();
    const index = floor(random(0, BLOCK_IN_ONE_LEVEL));
    this.doorX = floor(
      random(
        this.blocks[index].left,
        this.blocks[index].left +
        this.blocks[index].blockCount * BLOCK_IMG_WIDTH -
        50
      )
    );

    this.base = MAX_LEVEL - SHOW_LEVEL_COUNT;
    this.state = DoodleJumpState.PLAYING;

    this.fireTimer = 0;
    this.freezeTimer = 0;
    this.textTimer = 0;
    this.canvaMoving = false;
    this.canvaOffset = 220;

    this.scores.fill(0);
  }

  randomGenBlocks() {
    const Blocks = [];
    for (let level = 0; level < MAX_LEVEL; level++) {
      let blockLeft = floor(random(40, 120));
      let blockCount = floor(random(2, 4));
      Blocks.push(new Block(blockLeft, level, blockCount));

      blockLeft += blockCount * BLOCK_IMG_WIDTH + floor(random(50, 120));
      blockCount = floor(random(1, 4));
      Blocks.push(new Block(blockLeft, level, blockCount));

      blockLeft += blockCount * BLOCK_IMG_WIDTH + floor(random(40, 100));
      blockCount = floor(random(2, 4));
      Blocks.push(new Block(blockLeft, level, blockCount));

      blockLeft += blockCount * BLOCK_IMG_WIDTH + floor(random(50, 120));
      blockCount = floor(random(1, 4));
      Blocks.push(new Block(blockLeft, level, blockCount));
    }

    Blocks.push(
      new Block(0, MAX_LEVEL, floor(width / BLOCK_IMG_WIDTH) + 1)
    );

    return Blocks;
  }

  draw() {
    imageMode(CENTER);
    image(this.background, width / 2, height / 2, width, height);
    textFont(TCFont);

    if (
      this.state !== DoodleJumpState.GAMEOVER &&
      this.base < MAX_LEVEL - SHOW_LEVEL_COUNT &&
      this.role.curY > 700
    ) {
      gameOverSound.stop();
      gameOverSound.play();
      this.state = DoodleJumpState.GAMEOVER;
    }

    switch (this.state) {
      case DoodleJumpState.START:
        this.drawInfoScreen();
        break;
      case DoodleJumpState.RULE:
        this.drawRuleScreen();
        break;
      case DoodleJumpState.PLAYING:
        this.drawPlayingScreen();
        break;
      case DoodleJumpState.GAMEOVER:
        this.drawGameOverScreen();
        break;
      case DoodleJumpState.END:
        this.drawResultScreen();
        break;
      case DoodleJumpState.QUIZ:
        this.quiz.draw();
        break;
    }
  }

  drawInfoScreen() {
    image(this.envelopeBackground, width / 2, height / 2, 450, 600);

    textFont(TCFont);
    fill(0);
    textAlign(LEFT, TOP);
    textSize(20);
    textLeading(32);
    text(this.intro.substring(0, this.infoIndex), 260, 250);
    if (this.infoIndex < this.intro.length) {
      this.typeTime++;
      if (this.typeTime > this.typeInteval) {
        this.infoIndex++;
        this.typeTime = 0;
      }
    }
    textAlign(CENTER, CENTER);
    text("按下ENTER下一步", 400, 760);
  }

  drawRuleScreen() {
    textFont(TCFont);
    rectMode(CENTER);
    fill(255, 240);
    stroke(0);
    rect(width / 2, height / 2, 540, 600, 20);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("操作說明", 400, 150);
    textSize(20);
    text("按下ENTER開始遊戲", 400, 760);
    textAlign(LEFT, CENTER);
    textLeading(40);
    for (let i = 0; i < this.ruleLines.length; i++) {
      text(this.ruleLines[i], width / 2 - 245, height / 2 - 200 + (i * 40));
    }
    imageMode(CENTER);
    image(this.icons[6], 160, 560, 40, 40);
    image(this.icons[5], 160, 600, 40, 40);
    image(this.icons[7], 160, 640, 40, 40);
    image(this.door, 160, 680, 40, 40);
  }

  drawGameOverScreen() {
    background(7, 21, 39);
    imageMode(CENTER);
    image(this.gameoverbackground, width / 2, height / 2, 800, 800);
    image(this.restartButtonImg, restartX, restartY, restartBtnWidth, restartBtnHeight);
  }

  drawResultScreen() {
    background(170, 204, 255);
    textFont(TCFontBold);

    imageMode(CENTER);
    textAlign(CENTER, CENTER);
    textFont(TCFontBold);
    image(this.resultBackground, 400, 400, 800, 800);
    image(this.symbol, 240, 150, 183, 183);

    rectMode(CENTER);
    fill(255, 50);
    stroke(0);
    rect(240, 500, 200, 200, 10);
    image(this.weapon, 240, 500, 200, 200);

    let textX = 560;
    fill(255);
    textSize(30);
    text("恭喜你被分配到", textX, height * 0.15);
    text("你的最高分科目", textX, height * 0.45);
    text("得分", textX, height * 0.75);
    text("你的技能", 240, height * 0.45);
    textSize(20);
    text(skillDescriptions[this.maxIndex], 240, 640);

    textSize(50);
    fill(COLORS[this.maxIndex]);
    text(academics[this.maxIndex], textX, height * 0.25);
    text(subjects[this.maxIndex], textX, height * 0.53);
    text(str(this.maxScore), textX, height * 0.83);
    textSize(20);
    text("按下ENTER進入下一關", 400, 760);
  }

  drawBottomSection() {
    rectMode(CORNER);
    fill(0);
    rect(0, 700, width, height - 600);

    fill(255);
    textAlign(LEFT, TOP);
    textSize(20);
    for (let i = 0; i < this.scores.length; i++) {
      text(subjects[i] + ": " + this.scores[i], 20 + i * 90, 770);
    }

    if (this.fireTimer > 0) {
      this.fireTimer--;
      fill(255, 87, 51);
      text("專注模式: " + floor(this.fireTimer / 60) + "秒", 490, 770);
      fill(255);
    }

    if (this.freezeTimer > 0) {
      this.freezeTimer--;
      fill(51, 87, 255);
      text("遲到效應: " + floor(this.freezeTimer / 60) + "秒", 650, 770);
      fill(255);
    }

    if (this.textTimer > 0) {
      fill(255);
      textSize(20);
      text(currentHint, 20, 730);
      this.textTimer--;
    }
  }

  drawPlayingScreen() {
    if (this.canvaOffset < 200) {
      this.canvaOffset += CANVA_SPEED;
      this.role.curY += CANVA_SPEED;
    } else {
      this.canvaMoving = false;
    }

    // Handle continuous keyboard input for movement
    this.role.updateByKeyPress();

    if (this.freezeTimer === 0) {
      if (this.stayTopCheck()) {
        this.role.jump = false;
        this.role.curV = 0;
        this.role.curJumpCount = 0;
        if (!this.canvaMoving && this.role.curY < MOVE_CANVA_THRESHOLD && this.base > 0) {
          this.base -= 1;
          this.canvaOffset -= LAYER_HEIGHT;
          this.canvaMoving = true;
        }
      } else {
        this.role.curY += this.role.curV;
        this.role.curV += ACCELERATE;
      }
      this.hitIconCheck();
    }

    for (let i = BLOCK_IN_ONE_LEVEL * this.base; i < BLOCK_IN_ONE_LEVEL * (this.base + SHOW_LEVEL_COUNT); i++) {
      let blockY = this.canvaOffset + (this.blocks[i].level - this.base - 1) * LAYER_HEIGHT / 5 * 6;
      this.blocks[i].draw(blockY);
    }

    if (this.base === 0) {
      let doorY = this.canvaOffset - LAYER_HEIGHT / 5 * 6 - 70;
      image(this.door, this.doorX, doorY, 50, 60);
      fill(255, 0, 0);
      this.winCheck(doorY);
    }

    this.role.draw();
    this.drawBottomSection();
  }

  hitBottomCheck() {
    for (let i = BLOCK_IN_ONE_LEVEL * this.base; i < BLOCK_IN_ONE_LEVEL * (this.base + SHOW_LEVEL_COUNT); i++) {
      let blockBottom = this.canvaOffset + (this.blocks[i].level - this.base - 1) * LAYER_HEIGHT + BLOCK_HEIGHT;
      let blockLeft = this.blocks[i].left;
      let blockRight = this.blocks[i].left + this.blocks[i].blockCount * BLOCK_IMG_WIDTH;
      if (this.role.curX < blockRight && this.role.curX + ROLE_WIDTH > blockLeft) {
        if (this.role.curY >= blockBottom && this.role.curY + this.role.curV <= blockBottom)
          return true;
      }
    }
    return false;
  }

  stayTopCheck() {
    for (let i = BLOCK_IN_ONE_LEVEL * this.base; i < BLOCK_IN_ONE_LEVEL * (this.base + SHOW_LEVEL_COUNT) + 1; i++) {
      let blockTop = this.canvaOffset + (this.blocks[i].level - this.base - 1) * LAYER_HEIGHT / 5 * 6;
      let blockLeft = this.blocks[i].left;
      let blockRight = this.blocks[i].left + this.blocks[i].blockCount * BLOCK_IMG_WIDTH;
      if (this.role.curX < blockRight && this.role.curX + ROLE_WIDTH > blockLeft) {
        if (this.role.curY + ROLE_HEIGHT <= blockTop && this.role.curY + ROLE_HEIGHT + this.role.curV >= blockTop) {
          this.role.curY = blockTop - ROLE_HEIGHT;
          return true;
        }
      }
    }
    return false;
  }

  hitIconCheck() {
    for (let i = BLOCK_IN_ONE_LEVEL * this.base; i < BLOCK_IN_ONE_LEVEL * (this.base + SHOW_LEVEL_COUNT); i++) {
      let type = this.blocks[i].iconType;
      if (type === IconType.NONE || !this.blocks[i].showIcon)
        continue;
      let iconY = this.canvaOffset + (this.blocks[i].level - this.base - 1) * LAYER_HEIGHT / 5 * 6 - ICONSIZE;
      if (this.role.curX + ROLE_WIDTH / 2 > this.blocks[i].iconX && this.role.curX + ROLE_WIDTH / 2 < this.blocks[i].iconX + ICONSIZE) {
        if (this.role.curY + ROLE_HEIGHT >= iconY && this.role.curY + ROLE_HEIGHT <= iconY + ICONSIZE) {
          this.blocks[i].showIcon = false;
          switch (type) {
            case IconType.CERTIFICATE:
              this.fireTimer = FIRE_DURATION;
              this.textTimer = 120;
              this.pickSound.stop();
              this.pickSound.play();
              currentHint = "獲得獎狀，讓你信心爆棚！心情好，做事更有效率！趁這段黃金時間瘋狂加分吧";
              break;

            case IconType.CLOCK:
              this.freezeTimer = FREEZE_DURATION;
              this.textTimer = 120;
              currentHint = "遲到了！時間的壓力讓你瞬間凍住，心情有點低落...暫時無法行動";
              this.clockTicking.stop();
              this.clockTicking.play();
              break;

            case IconType.QUIZ:
              let randomQuestion = this.questions[floor(random(this.questions.length))];
              this.quiz.setQuestion(randomQuestion);
              this.quiz.show_quiz_content = false;
              this.state = DoodleJumpState.QUIZ;

              let scoreToAdd = 10;

              let qSubject = randomQuestion.subject;
              let qIndex = qSubject;

              this.quiz.pendingAddScore = true;
              this.quiz.pendingScoreIndex = qIndex;
              this.quiz.pendingScoreAmount = scoreToAdd;
              break;

            default:
              let index = type;
              if (this.fireTimer > 0)
                this.scores[index] += 10;
              else
                this.scores[index] += 1;
              this.pickSound.stop();
              this.pickSound.play();
              break;
          }
        }
      }
    }
    return false;
  }

  winCheck(doorY) {
    if (this.role.curX + ROLE_WIDTH > this.doorX && this.role.curX < this.doorX + 50 &&
      this.role.curY + ROLE_HEIGHT > doorY && this.role.curY < doorY + 60) {
      this.maxScore = -1;
      for (let i = 0; i < this.scores.length; i++) {
        if (this.scores[i] > this.maxScore) {
          this.maxScore = this.scores[i];
          this.maxIndex = i;
        }
      }
      this.loadResultImages(this.maxIndex);
      game.mihoyo.setCareer(this.maxIndex);
      level2Music = loadSound(`assets/musics/${filenames[this.maxIndex]}.mp3`);
      this.state = DoodleJumpState.END;
    }
  }

  // =====================
  // Input handling
  // =====================
  keyPressed() {
    switch (this.state) {
      case DoodleJumpState.START:
        if (keyCode === ENTER) {
          this.state = DoodleJumpState.RULE;
          level1Music.loop();
          openningMusic.pause();
        }
        break;

      case DoodleJumpState.RULE:
        if (keyCode === ENTER) this.state = DoodleJumpState.PLAYING;
        break;

      case DoodleJumpState.GAMEOVER:
        if (keyCode === ENTER) this.reset();
        break;

      case DoodleJumpState.QUIZ:
        if (this.quiz.exit_counter === 0)
          this.quiz.updateAnserByKeyPress();
        break;

      case DoodleJumpState.END:
        if (keyCode === ENTER) {
          level1Music.pause();
          level2Music.loop();
          game.state = State.LEVEL2;
          game.mihoyo.state = MihoyoState.RULE;
        }
        break;
    }
  }

  mousePressed() {
    if (this.state === DoodleJumpState.QUIZ) {
      this.quiz.updateByMousePress();
    } else if (this.state === DoodleJumpState.GAMEOVER) {
      if (
        mouseX > restartX - restartWidth / 2 &&
        mouseX < restartX + restartWidth / 2 &&
        mouseY > restartY - restartHeight / 2 &&
        mouseY < restartY + restartHeight / 2
      ) {
        this.reset();
      }
    }
  }
}
