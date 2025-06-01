enum MihoyoState {
  RULE,
  PLAYING,
  SHOP,
  WIN,
  LOSE
}

class Mihoyo {
  MihoyoState state = MihoyoState.RULE;
  int credit = 0;             // 學分
  int space_CD = 0;            // space冷卻
  int level = 1;               // 商店購買次數
  int t = 0, seconds;          // 計時
  int career;                  // 職業        文理音藝體 0 1 2 3 4
  int temp = 0;                // 商店防誤觸計時

  PImage workerImg, backgroundImg, notGraduateImg, jobScene, timer;
  Player player;
  int workerX, workerY, workerWidth, workerHeight, textX;
  color textColor, textBgColor;
  String jobTitle;
  String[] monsterName, ability;
  WeaponBase currentWeapon;
  String[] introLines = loadStrings("texts/mihoyo_intro.txt");
  AudioPlayer resultMusic = minim.loadFile("musics/result.mp3");

  Mihoyo() {
  }

  void setCareer(int careerIn) {
    loadImages(careerIn);
    player = new Player(new PVector(0, 0), new PVector(0, 0), 100, 10, careerIn);
    setCareerVariables(careerIn);
  }

  void loadImages(int career) {
    timer = loadImage("subjects/clock.png");
    backgroundImg = loadImage("pic/background.jpg");
    notGraduateImg = loadImage("backgrounds/notGraduate.png");
    workerImg = loadImage("job_data/worker_" + filenames[career] + ".png");
    jobScene = loadImage("job_data/scene_" + filenames[career] + ".png");
    ability = loadStrings("texts/weapon_descriptions/" + filenames[career] + ".txt");
  }

  void setCareerVariables(int careerIn) {
    career = careerIn;
    workerX = workerXs[career];
    workerY = workerYs[career];
    workerWidth = workerWidths[career];
    workerHeight = workerHeights[career];
    textColor = textColors[career];
    textBgColor = textBgColors[career];
    textX = textXs[career];
    jobTitle = jobTitles[career];
    monsterName = monsterNames[career];

    switch (career) {
      case 0:
        currentWeapon = new Weapon0(this);
        break;
      case 1:
        currentWeapon = new Weapon1(this);
        break;
      case 2:
        currentWeapon = new Weapon2(this);
        break;
      case 3:
        currentWeapon = new Weapon3(this);
        break;
      case 4:
        currentWeapon = new Weapon4(this);
        break;
    }
  }

  void draw() {
    // update the state
    if (state!= MihoyoState.LOSE && player.HP <= 0) {
      game.level2Music.pause();
      game.gameOverSound.rewind();
      game.gameOverSound.play();
      state = MihoyoState.LOSE;
    }
    if (state!= MihoyoState.WIN && credit >= WIN_CREDIT) {
      game.level2Music.pause();
      resultMusic.rewind();
      resultMusic.play();
      state = MihoyoState.WIN;
    }

    switch (state) {
      case RULE:
        drawRuleScreen();
        break;
      case PLAYING:
        drawPlayingScreen();
        break;
      case SHOP:
        temp += 1;
        drawShopScreen();
        break;
      case WIN:
        drawWinScreen();
        break;
      case LOSE:
        drawLoseScreen();
        break;
    }
  }

  //  timer and credit header
  void drawHeader() {
    textAlign(LEFT);
    textSize(35);
    text(academics[career], width - 150, 50);
    if (state == MihoyoState.PLAYING) {
      runTimer();
      text("學分 " + credit, 50, 50);
    }
  }

  void drawRuleScreen() {
    image(backgroundImg,400, 400, 800, 800);
    textFont(TCFontBold);
    rectMode(CENTER);
    fill(255, 100);
    strokeWeight(2);
    stroke(0);
    rect(width/2, height/2, 540, 600, 20);
    
    fill(0);
    textAlign(CENTER);
    textSize(30);
    text("操作說明", 400, 150);

    textSize(20);
    textAlign(LEFT, CENTER);
    for (int i = 0; i < introLines.length; i++) {
      text(introLines[i], width/2 -245, height/2 - 200 + i*40);
      
    }

    drawHeader();
  }

  void drawPlayingScreen() {
    background(200);

    // enter shop condition check
    if (level <= 5 && credit >= level * WEAPON_COST - 10) {
      state = MihoyoState.SHOP;
    }

    imageMode(CENTER);
    for (int i = 0; i < 4; i++)
      for (int j = 0; j < 4; j++)
        image(backgroundImg,
          width * (i - 1.5) + (-player.XY.x % width),
          height * (j - 1.5) + (-player.XY.y % height),
          width, height);

    pushMatrix();
    translate(-player.XY.x, -player.XY.y);

    player.XY.add(player.speed);
    currentWeapon.draw(player, t);
    DrawMonsters(this);

    if (t % 10 == 0) {
      float randomangle = random(0, 2 * PI);
      int randomname = int(random(0, 3));
      monsters.add(new Monster(
        new PVector(player.XY.x + cos(randomangle) * random(width, width*2),
        player.XY.y + sin(randomangle) * random(height, height*2)),
        int(random(10, 100)), 10, random(1, 7.5), 0, monsterName[randomname]));
    }
    popMatrix();

    player.draw();
    text(level, 400, 300);

    drawHeader();
  }

  void drawShopScreen() {
    background(100);
    rectMode(CENTER);
    fill(255);
    stroke(0);
    for (int i = -2; i <= 2; i++)
      rect(width/2, height/2 + i*100, width - 100, 100);

    textAlign(CENTER);
    textSize(20);
    fill(0);
    for (int i = 0; i < 5; i++) {
      fill(0);
      text(ability[i], width/2, height/2 + 200 - i*100);
      if (currentWeapon.skill[i]) {
        fill(100, 0, 0);
        text("已解鎖", width/2, height/2 + 200 - i*100 + 25);
        fill(0);
      }
    }

    if (mousePressed && temp >= 60) {
      for (int i = 0; i < 5; i++) {
        if (!currentWeapon.skill[i] && mouseY > height/2 + 150 - i*100 && mouseY < height/2 + 250 - i*100) {
          unlockSkill(i);
        }
      }
    }

    drawHeader();
  }

  void drawWinScreen() {
    // 繪製背景場景
    imageMode(CENTER);
    image(jobScene, 400, 400, 800, 800);

    // 繪製人物
    image(workerImg, workerX, workerY, workerWidth, workerHeight);

    // 繪製文字
    textFont(TCFontBold);
    textAlign(CENTER, CENTER);
    textSize(36);
    fill(textBgColor);
    text(congratsText, textX, textY);

    textSize(64);
    fill(textColor);
    text(jobTitle, textX, titleY);

    textSize(20);
    text("按下ENTER重新遊玩", 400, 760);
  }

  void drawLoseScreen() {
    background(0);
    fill(255, 0, 0);
    image(notGraduateImg, 400, 400, 800, 800);
    textAlign(CENTER);
    textSize(50);
    text("你沒畢業", width/2, height/2 - 300);
    textSize(30);
    text("獲得學分: " + credit, width/2, height/2+300);

    fill(220);
    textSize(20);
    text("按下ENTER再次挑戰", width/2, height/2 + 350);
  }

  void runTimer() {
    t += 1;
    if (t >= int(frameRate)) {
      seconds += 1;
      t = 0;
    }
    image(timer, width/2 - 25, 25, 50, 50);
    textAlign(LEFT);
    textSize(50);
    text(seconds, width/2, 50);
  }

  void unlockSkill(int index) {
    currentWeapon.skill[index] = true;
    state = MihoyoState.PLAYING;
    level += 1;
    temp = 0;
  }

  void reset() {
    resultMusic.pause();
    game.gameOverSound.pause();
    game.level2Music.rewind();
    game.level2Music.loop();
    state = MihoyoState.RULE;
    credit = 0;
    space_CD = 0;
    level = 1;
    t = 0;
    seconds = 0;
    player.HP = 100;
    player.XY.set(0, 0);
    monsters.clear();
    currentWeapon.skill = new boolean[5];
    for(int i = 0; i < currentWeapon.skill.length; i++)
      currentWeapon.skill[i] = false;
  }

  void keyPressed() {
    switch (state) {
      case RULE:
        if (key == ENTER || key == RETURN)
          state = MihoyoState.PLAYING;
        break;
      case PLAYING:
        player.keyPressed();
        break;
      case LOSE:
        if (key == ENTER || key == RETURN)
          reset();
        break;
      case WIN:
        if (key == ENTER || key == RETURN){
          game.reset();
        }
        break;
    }
  }

  void keyReleased() {
    player.keyReleased();
  }

  void mousePressed() {
    if (state == MihoyoState.PLAYING)
      currentWeapon.mousePressed();
  }
}
