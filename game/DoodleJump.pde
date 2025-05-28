enum DoodleJumpState {
  START,
    RULE,
    PLAYING,
    GAMEOVER,
    END,
    QUIZ,
}

class DoodleJump {
  Role role;
  Quiz quiz;
  Block[] blocks;
  DoodleJumpState state;
  int base;
  boolean canvaMoving;
  int fireTimer, freezeTimer, textTimer, canvaOffset;
  AudioPlayer correctSound, wrongSound, jumpSound, pickSound, clockTicking;
  int []scores = new int[5];
  Question[] questions;
  PImage[] blockImgs = new PImage[8];
  PImage[] icons = new PImage[8];
  PImage symbol, resultBackground, weapon;
  PImage background, gameoverbackground, restartButtonImg, envelopeBackground;
  PImage door;

  String[] introLines = loadStrings("texts/doodle_jump_intro.txt");
  String intro = join(introLines, "\n");
  String[] ruleLines = loadStrings("texts/doodle_jump_rule.txt");
  int infoIndex = 0;
  int typeInteval = 3;
  int typeTime = 0;
  int maxIndex = 0;
  int maxScore = -1;
  int doorX;

  DoodleJump() {
    role = new Role();
    quiz = new Quiz();
    door = loadImage("icons/door.png");
    loadSounds();
    loadBlockImages();
    loadSubjectImages();
    loadBackgroundImages();
    loadQuestions();
    reset();
  }

  void loadSounds() {
    correctSound = minim.loadFile("sounds/correct.mp3");
    wrongSound = minim.loadFile("sounds/wrong.mp3");
    jumpSound = minim.loadFile("sounds/jump.mp3");
    pickSound = minim.loadFile("sounds/pick.mp3");
    clockTicking = minim.loadFile("sounds/ClockTicking.mp3");
  }

  void loadSubjectImages() {
    for (int i = 0; i < filenames.length; i++) {
      icons[i] = loadImage("subjects/" + filenames[i] + ".png");
    }
  }

  void loadBackgroundImages() {
    envelopeBackground = loadImage("backgrounds/envelope.png");
    background = loadImage("backgrounds/game1background.png");
    gameoverbackground = loadImage("backgrounds/gameOver.jpg");
    restartButtonImg = loadImage("icons/button_restart.png");
  }

  void loadResultImages(int index) {
    symbol = loadImage("icons/" + filenames[index] + "Symbol.png");
    resultBackground = loadImage("backgrounds/" + filenames[index]+ ".png");
    weapon = loadImage("weapons/" + filenames[index] + ".png");
  }

  void loadQuestions() {
    JSONArray quizData = loadJSONArray("quiz.json");
    questions = new Question[quizData.size()];

    for (int i = 0; i < quizData.size(); i++) {
      questions[i] = new Question(quizData.getJSONObject(i));
    }
  }

  void loadBlockImages() {
    blockImgs[0] = loadImage("blocks/white.png");
    blockImgs[1] = loadImage("blocks/yellow.png");
    blockImgs[2] = loadImage("blocks/purple.png");
    blockImgs[3] = loadImage("blocks/red.png");
    blockImgs[4] = loadImage("blocks/green.png");
    blockImgs[5] = loadImage("blocks/black.png");
    blockImgs[6] = loadImage("blocks/black.png");
    blockImgs[7] = loadImage("blocks/black.png");
  }

  void reset() {
    role.reset();
    quiz.reset();
    blocks = randomGenBlocks();
    int index = int(random(0, BLOCK_IN_ONE_LEVEL));
    doorX = int(random(blocks[index].left, blocks[index].left + blocks[index].blockCount * BLOCK_IMG_WIDTH - 50));
    base = MAX_LEVEL - SHOW_LEVEL_COUNT;
    state = DoodleJumpState.PLAYING;
    fireTimer = 0;
    freezeTimer = 0;
    textTimer = 0;
    canvaMoving = false;
    canvaOffset = 220;
    for (int i = 0; i < scores.length; i ++)
      scores[i] = 0;
  }

  Block[] randomGenBlocks() {
    Block[] Blocks = new Block[MAX_LEVEL * BLOCK_IN_ONE_LEVEL + 1];
    for (int level = 0; level < MAX_LEVEL; level ++) {
      int blockLeft = int(random(40, 120));
      int blockCount = int(random(2, 4));
      Blocks[BLOCK_IN_ONE_LEVEL * level] = new Block(blockLeft, level, blockCount);

      blockLeft = blockLeft + blockCount * BLOCK_IMG_WIDTH + int(random(50, 120));
      blockCount = int(random(1, 4));
      Blocks[BLOCK_IN_ONE_LEVEL * level + 1] = new Block(blockLeft, level, blockCount);

      blockLeft = blockLeft + blockCount * BLOCK_IMG_WIDTH + int(random(40, 100));
      blockCount = int(random(2, 4));
      Blocks[BLOCK_IN_ONE_LEVEL * level + 2] = new Block(blockLeft, level, blockCount);

      blockLeft = blockLeft + blockCount * BLOCK_IMG_WIDTH + int(random(50, 120));
      blockCount = int(random(1, 4));
      Blocks[BLOCK_IN_ONE_LEVEL * level + 3] = new Block(blockLeft, level, blockCount);
    }

    Blocks[BLOCK_IN_ONE_LEVEL * MAX_LEVEL] = new Block(0, MAX_LEVEL, int(width/BLOCK_IMG_WIDTH) + 1);
    return Blocks;
  }

  boolean hitBottomCheck() {
    for (int i = BLOCK_IN_ONE_LEVEL * base; i < BLOCK_IN_ONE_LEVEL * (base + SHOW_LEVEL_COUNT); i++) {
      int blockBottom = canvaOffset + (blocks[i].level - base - 1) * LAYER_HEIGHT + BLOCK_HEIGHT;
      int blockLeft = blocks[i].left;
      int blockRight = blocks[i].left + blocks[i].blockCount * BLOCK_IMG_WIDTH;
      if (role.curX < blockRight && role.curX + ROLE_WIDTH > blockLeft) {
        if (role.curY >= blockBottom && role.curY + role.curV <= blockBottom)
          return true;
      }
    }
    return false;
  }

  boolean stayTopCheck() {
    for (int i = BLOCK_IN_ONE_LEVEL * base; i < BLOCK_IN_ONE_LEVEL * (base + SHOW_LEVEL_COUNT) + 1; i++) {
      int blockTop = canvaOffset + (blocks[i].level - base - 1) * LAYER_HEIGHT/5*6;
      int blockLeft = blocks[i].left;
      int blockRight = blocks[i].left + blocks[i].blockCount * BLOCK_IMG_WIDTH;
      if (role.curX < blockRight && role.curX + ROLE_WIDTH > blockLeft) {
        if (role.curY + ROLE_HEIGHT <= blockTop && role.curY + ROLE_HEIGHT + role.curV >= blockTop) {
          role.curY = blockTop - ROLE_HEIGHT;
          return true;
        }
      }
    }
    return false;
  }

  boolean hitIconCheck() {
    for (int i = BLOCK_IN_ONE_LEVEL * base; i < BLOCK_IN_ONE_LEVEL * (base + SHOW_LEVEL_COUNT); i++) {
      IconType type = blocks[i].iconType;
      if (type == IconType.NONE || !blocks[i].showIcon)
        continue;
      int iconY = canvaOffset + (blocks[i].level - base - 1) * LAYER_HEIGHT/5*6 - ICONSIZE;
      if (role.curX + ROLE_WIDTH/2 > blocks[i].iconX && role.curX + ROLE_WIDTH/2 < blocks[i].iconX + ICONSIZE) {
        if (role.curY + ROLE_HEIGHT >= iconY && role.curY + ROLE_HEIGHT <= iconY + ICONSIZE) {
          blocks[i].showIcon = false;
          switch (type) {
          case CERTIFICATE:
            println("撿到了 certificate，啟動火焰模式");
            fireTimer = FIRE_DURATION;
            textTimer = 120;
            pickSound.rewind();
            pickSound.play();
            currentHint = "獲得獎狀，讓你信心爆棚！心情好，做事更有效率！趁這段黃金時間瘋狂加分吧";
            break;

          case CLOCK:
            println("撿到了 clock，角色凍結");
            freezeTimer = FREEZE_DURATION;
            textTimer = 120;
            currentHint = "遲到了！時間的壓力讓你瞬間凍住，心情有點低落...暫時無法行動";
            clockTicking.rewind();
            clockTicking.play();
            break;

          case QUIZ:
            println("撿到了 icon，type 為：" + blocks[i].iconType);
            //get random quiz
            quiz.setQuestion(questions[int(random(questions.length))]);
            quiz.show_quiz_content = false;
            state = DoodleJumpState.QUIZ;

            //int scoreToAdd = (fireTimer > 0) ? 10 : 1;
            int scoreToAdd = 10;

            Subject qSubject = quiz.question.subject;
            int qIndex = qSubject.ordinal();

            quiz.pendingAddScore = true;
            quiz.pendingScoreIndex = qIndex;
            quiz.pendingScoreAmount = scoreToAdd;
            break;

          default:
            int index = type.ordinal();
            //when onfire, score add 10, else add 1
            if (fireTimer > 0)
              scores[index] += 10;
            else
              scores[index] += 1;
            pickSound.rewind();
            pickSound.play();
            break;
          }
        }
      }
    }
    return false;
  }

  void drawInfoPage() {
    image(envelopeBackground, width/2, height/2, 450, 600);

    textFont(TCFont);
    fill(0);
    textAlign(LEFT, TOP);
    textSize(20);
    textLeading(32);
    text(intro.substring(0, infoIndex), 260, 250);
    if (infoIndex < intro.length()) {
      typeTime++;
      if (typeTime > typeInteval) {
        infoIndex++;
        typeTime = 0;
      }
    }
    textAlign(CENTER, CENTER);
    text("按下ENTER下一步", 400, 760);
  }

  void drawRulePage() {
    textFont(TCFont);
    rectMode(CENTER);
    fill(255, 240);
    stroke(0);
    rect(width/2, height/2, 540, 600, 20);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("操作說明", 400, 150);
    textSize(20);
    text("按下ENTER開始遊戲", 400, 760);
    textAlign(LEFT, CENTER);
    textLeading(40);
    for (int i = 0; i < ruleLines.length; i++) {
      text(ruleLines[i], width/2 -245, height/2 - 200 + (i * 40));
    }
    imageMode(CENTER);
    image(icons[6], 160, 560, 40, 40);
    image(icons[5], 160, 600, 40, 40);
    image(icons[7], 160, 640, 40, 40);
    image(door, 160, 680, 40, 40);
  }

  void drawGameOver() {
    background(#071527);
    imageMode(CENTER);
    image(gameoverbackground, width/2, height/2, 600, 600);
    image(restartButtonImg, restartX, restartY, restartBtnWidth, restartBtnHeight);
  }

  void drawResultPage() {
    background(#AACCFF);
    textFont(TCFontBold);

    // 繪製結果頁面
    imageMode(CENTER);
    textAlign(CENTER, CENTER);
    textFont(TCFontBold);
    image(resultBackground, 400, 400, 800, 800);
    image(symbol, 240, 150, 183, 183);

    rectMode(CENTER);
    fill(255, 50);
    stroke(0);
    rect(240, 500, 200, 200, 10);
    image(weapon, 240, 500, 200, 200);

    float textX = 560;
    fill(255);
    textSize(30);
    text("恭喜你被分配到", textX, height * 0.15);
    text("你的最高分科目", textX, height * 0.45);
    text("得分", textX, height * 0.75);
    text("你的技能", 240, height * 0.45);
    textSize(20);
    text(skillDescriptions[maxIndex], 240, 640);

    textSize(50);
    fill(COLORS[maxIndex]);
    text(academics[maxIndex], textX, height * 0.25);
    text(subjects[maxIndex], textX, height * 0.53);
    text(str(maxScore), textX, height * 0.83);
    textSize(20);
    text("按下ENTER進入下一關", 400, 760);
  }

  void drawBottomSection() {
    rectMode(CORNER);
    fill(0);
    rect(0, 700, width, height - 600);

    fill(255);
    textAlign(CORNER, CORNER);
    textSize(20);
    // scores
    for (int i = 0; i < scores.length; i ++) {
      text(subjects[i] + ": " + scores[i], 20 + i * 90, 770);
    }

    // show fire mode time
    if (fireTimer > 0) {
      fireTimer --;
      fill(#FF5733);
      text("專注模式: " + fireTimer / 60 + "秒", 490, 770);
      fill(255);
    }

    // show frozen mode time
    if (freezeTimer > 0) {
      freezeTimer --;
      fill(#3357FF);
      text("遲到效應: " + freezeTimer / 60 + "秒", 650, 770);
      fill(255);
    }

    if (textTimer > 0) {
      fill(255);
      textSize(20);
      text(currentHint, 20, 730);
      textTimer--;
    }
  }

  void draw() {
    imageMode(CENTER);
    image(background, width/2, height/2, width, height);
    textFont(TCFont);

    // game over
    if (state != DoodleJumpState.GAMEOVER && base < MAX_LEVEL - SHOW_LEVEL_COUNT && role.curY > 700) {
      game.gameOverSound.rewind();
      game.gameOverSound.play();
      state = DoodleJumpState.GAMEOVER;
    }

    switch (state) {
    case START:
      drawInfoPage();
      break;
    case RULE:
      drawRulePage();
      break;
    case PLAYING:
      drawPlayingPage();
      break;
    case GAMEOVER:
      drawGameOver();
      break;
    case END:
      drawResultPage();
      break;
    case QUIZ:
      quiz.draw();
      break;
    }
  }

  void drawPlayingPage() {
    if (canvaOffset < 200) {
      canvaOffset += CANVA_SPEED;
      role.curY += CANVA_SPEED;
    } else {
      canvaMoving = false;
    }

    // roles can only move when not frozen
    if (freezeTimer == 0) {
      if (stayTopCheck()) {
        role.jump = false;
        role.curV = 0;
        role.curJumpCount = 0;
        // move the canva
        if (!canvaMoving && role.curY < MOVE_CANVA_THRESHOLD && base > 0) {
          base -= 1;
          canvaOffset -= LAYER_HEIGHT;
          canvaMoving = true;
        }
      } else {
        // if(hitBottomCheck())
        //     role.curV = -role.curV;
        role.curY += role.curV;
        role.curV += ACCELERATE;
      }
      hitIconCheck();
    }

    // draw the blocks
    for (int i = BLOCK_IN_ONE_LEVEL * base; i < BLOCK_IN_ONE_LEVEL * (base + SHOW_LEVEL_COUNT); i++) {
      int blockY = canvaOffset + (blocks[i].level - base - 1) * LAYER_HEIGHT/5*6;
      blocks[i].draw(blockY);
    }

    // draw the door and check if the player can win
    if (base == 0) {
      int doorY = canvaOffset - LAYER_HEIGHT/5*6 - 70;
      image(door, doorX, doorY, 50, 60);
      fill(255, 0, 0);
      winCheck(doorY);
    }

    // draw the role
    role.draw();

    // bottom section
    drawBottomSection();
  }

  void winCheck(int doorY) {
    if (role.curX + ROLE_WIDTH > doorX && role.curX < doorX + 50 && role.curY + ROLE_HEIGHT > doorY && role.curY < doorY + 60) {
      // 計算最高分的科目
      maxScore = -1;
      for (int i = 0; i < scores.length; i++) {
        if (scores[i] > maxScore) {
          maxScore = scores[i];
          maxIndex = i;
        }
      }
      loadResultImages(maxIndex);
      game.mihoyo.setCareer(maxIndex);
      println("最高分科目: " + filenames[maxIndex] + ", 分數: " + maxScore);
      game.level2Music = minim.loadFile("musics/" + filenames[maxIndex] + ".mp3");
      state = DoodleJumpState.END;
    }
  }

  void keyPressed() {
    switch (state) {
    case START:
      if (key == ENTER || key == RETURN){
        state = DoodleJumpState.RULE;
        game.level1Music.loop();
        game.openningMusic.pause();
      }
      break;
    case RULE:
      if (key == ENTER || key == RETURN)
        state = DoodleJumpState.PLAYING;
    case GAMEOVER:
      if (key == ENTER || key == RETURN)
        reset();
      break;
    case QUIZ:
      if (quiz.exit_counter == 0)
        quiz.updateAnserByKeyPress();
      break;
    case END:
      if (key == ENTER || key == RETURN) {
        game.level1Music.pause();
        game.level2Music.loop();
        game.state = State.LEVEL2;
        game.mihoyo.state = MihoyoState.OPENING;
      }
      break;
    default:
      role.updateByKeyPress();
    }
  }

  void mousePressed() {
    if (state == DoodleJumpState.START) {
    } else if (state == DoodleJumpState.QUIZ) {
      quiz.updateByMousePress();
    } else if (state == DoodleJumpState.GAMEOVER) {
      if (mouseX > restartX - restartWidth/2 && mouseX < restartX + restartWidth/2 && mouseY > restartY - restartHeight/2 && mouseY < restartY + restartHeight/2) {
        reset();
      }
    }
  }
}
