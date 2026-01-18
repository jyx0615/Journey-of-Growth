// Enum replacement in JS
const MihoyoState = {
  RULE: "RULE",
  PLAYING: "PLAYING",
  SHOP: "SHOP",
  WIN: "WIN",
  LOSE: "LOSE"
};

class Mihoyo {
  constructor() {
    this.state = MihoyoState.RULE;
    this.credit = 0;     // 學分
    space_CD = 0;
    this.level = 1;
    this.t = 0;
    this.seconds = 0;
    this.career = 0;
    this.temp = 0;

    this.workerImg = null;
    this.backgroundImg = null;
    this.notGraduateImg = null;
    this.jobScene = null;
    this.timerImg = null;

    this.player = null;
    this.workerX = 0;
    this.workerY = 0;
    this.workerWidth = 0;
    this.workerHeight = 0;
    this.textX = 0;
    this.textColor = color(0);
    this.textBgColor = color(255);
    this.jobTitle = "";
    this.monsterName = [];
    this.ability = [];
    this.currentWeapon = null;
    this.resultMusic = null; // p5.SoundFile

    // preload will load assets before setup
  }

  setCareer(careerIn) {
    this.loadImages(careerIn);
    this.player = new Player(createVector(0, 0), createVector(0, 0), 100, 10, careerIn);
    this.setCareerVariables(careerIn);
  }

  loadImages(career) {
    this.timerImg = loadImage("assets/subjects/clock.png");
    this.backgroundImg = loadImage("assets/pic/background.jpg");
    this.notGraduateImg = loadImage("assets/backgrounds/notGraduate.png");
    this.workerImg = loadImage(`assets/job_data/worker_${filenames[career]}.png`);
    this.jobScene = loadImage(`assets/job_data/scene_${filenames[career]}.png`);
    this.ability = loadStrings(`assets/texts/weapon_descriptions/${filenames[career]}.txt`);
  }

  setCareerVariables(careerIn) {
    this.career = careerIn;
    this.workerX = workerXs[careerIn];
    this.workerY = workerYs[careerIn];
    this.workerWidth = workerWidths[careerIn];
    this.workerHeight = workerHeights[careerIn];
    this.textColor = textColors[careerIn];
    this.textBgColor = textBgColors[careerIn];
    this.textX = textXs[careerIn];
    this.jobTitle = jobTitles[careerIn];
    this.monsterName = monsterNames[careerIn];

    switch (careerIn) {
      case 0: this.currentWeapon = new Weapon0(this); break;
      case 1: this.currentWeapon = new Weapon1(this); break;
      case 2: this.currentWeapon = new Weapon2(this); break;
      case 3: this.currentWeapon = new Weapon3(this); break;
      case 4: this.currentWeapon = new Weapon4(this); break;
    }
  }

  draw() {
    // check lose
    if (this.state !== MihoyoState.LOSE && this.player.HP <= 0) {
      level2Music.pause();
      gameOverSound.play();
      this.state = MihoyoState.LOSE;
    }
    // check win
    if (this.state !== MihoyoState.WIN && this.credit >= WIN_CREDIT) {
      level2Music.pause();
      if (this.resultMusic) this.resultMusic.play();
      this.state = MihoyoState.WIN;
    }

    switch (this.state) {
      case MihoyoState.RULE: this.drawRuleScreen(); break;
      case MihoyoState.PLAYING: this.drawPlayingScreen(); break;
      case MihoyoState.SHOP: this.temp += 1; this.drawShopScreen(); break;
      case MihoyoState.WIN: this.drawWinScreen(); break;
      case MihoyoState.LOSE: this.drawLoseScreen(); break;
    }
  }

  drawHeader() {
    textAlign(LEFT);
    textSize(35);
    text(academics[this.career], width - 150, 50);
    if (this.state === MihoyoState.PLAYING) {
      this.runTimer();
      text("學分 " + this.credit, 50, 50);
    }
  }

  drawRuleScreen() {
    image(this.backgroundImg, 400, 400, 800, 800);
    textFont(TCFontBold);
    rectMode(CENTER);
    fill(255, 100);
    strokeWeight(2);
    stroke(0);
    rect(width / 2, height / 2, 540, 600, 20);

    fill(0);
    textAlign(CENTER);
    textSize(30);
    text("操作說明", 400, 150);

    textAlign(LEFT, CENTER);
    textFont(TCFont);
    textSize(20);
    for (let i = 0; i < mihoyoIntroLines.length; i++) {
      text(mihoyoIntroLines[i], width / 2 - 245, height / 2 - 200 + i * 40);
    }

    this.drawHeader();
  }

  drawPlayingScreen() {
    background(200);

    if (this.level <= 5 && this.credit >= this.level * WEAPON_COST - 10) {
      this.state = MihoyoState.SHOP;
    }

    imageMode(CENTER);
    for (let i = 0; i < 4; i++)
      for (let j = 0; j < 4; j++)
        image(this.backgroundImg,
          width * (i - 1.5) + (-this.player.XY.x % width),
          height * (j - 1.5) + (-this.player.XY.y % height),
          width, height);

    push();
    translate(-this.player.XY.x, -this.player.XY.y);

    this.player.XY.add(this.player.speed);
    this.currentWeapon.draw(this.player, this.t);
    DrawMonsters(this);

    // Spawn monsters with difficulty scaling and spawn limits
    if (this.t % 10 === 0 && monsters.length < this.getMaxMonsters()) {
      const level = this.level;
      const baseDifficulty = 1 + (level - 1) * 0.3;

      let randomangle = random(0, TWO_PI);
      let randomname = int(random(0, this.monsterName.length));

      monsters.push(new Monster(
        createVector(
          this.player.XY.x + cos(randomangle) * (width * 1.5),
          this.player.XY.y + sin(randomangle) * (height * 1.5)
        ),
        int(50 * baseDifficulty),           // HP scales with level
        int(5 * baseDifficulty),            // ATK scales with level
        random(2, 4) * baseDifficulty,      // Speed scales with level
        300,                                // Despawn timer (5 sec at 60 fps)
        this.monsterName[randomname]
      ));
    }
    pop();

    this.player.draw();
    text(this.level, 400, 300);

    this.drawHeader();
  }

  drawShopScreen() {
    background(100);
    rectMode(CENTER);
    fill(255);
    stroke(0);
    for (let i = -2; i <= 2; i++)
      rect(width / 2, height / 2 + i * 100, width - 100, 100);

    textAlign(CENTER);
    textSize(20);
    fill(0);
    for (let i = 0; i < 5; i++) {
      fill(0);
      text(this.ability[i], width / 2, height / 2 + 200 - i * 100);
      if (this.currentWeapon.skill[i]) {
        fill(100, 0, 0);
        text("已解鎖", width / 2, height / 2 + 200 - i * 100 + 25);
        fill(0);
      }
    }

    if (mouseIsPressed && this.temp >= 60) {
      for (let i = 0; i < 5; i++) {
        if (!this.currentWeapon.skill[i] && mouseY > height / 2 + 150 - i * 100 &&
          mouseY < height / 2 + 250 - i * 100) {
          this.unlockSkill(i);
        }
      }
    }

    this.drawHeader();
  }

  drawWinScreen() {
    imageMode(CENTER);
    image(this.jobScene, 400, 400, 800, 800);
    image(this.workerImg, this.workerX, this.workerY, this.workerWidth, this.workerHeight);

    textFont(TCFontBold);
    textAlign(CENTER, CENTER);
    textSize(36);
    fill(this.textBgColor);
    text(congratsText, this.textX, textY);

    textSize(64);
    fill(this.textColor);
    text(this.jobTitle, this.textX, titleY);

    textSize(20);
    text("按下ENTER重新遊玩", 400, 760);
  }

  drawLoseScreen() {
    background(0);
    fill(255, 0, 0);
    image(this.notGraduateImg, 400, 400, 800, 800);
    textAlign(CENTER);
    textSize(50);
    text("你沒畢業", width / 2, height / 2 - 300);
    textSize(30);
    text("獲得學分: " + this.credit, width / 2, height / 2 + 300);

    fill(220);
    textSize(20);
    text("按下ENTER再次挑戰", width / 2, height / 2 + 350);
  }

  runTimer() {
    this.t += 1;
    if (this.t >= int(frameRate())) {
      this.seconds += 1;
      this.t = 0;
    }
    image(this.timerImg, width / 2 - 25, 25, 50, 50);
    textAlign(LEFT);
    textSize(50);
    text(this.seconds, width / 2, 50);
  }

  unlockSkill(index) {
    this.currentWeapon.skill[index] = true;
    this.state = MihoyoState.PLAYING;
    this.level += 1;
    this.temp = 0;
  }

  getMaxMonsters() {
    return 5 + this.level * 2; // More monsters as level increases
  }

  reset() {
    if (this.resultMusic) this.resultMusic.stop();
    gameOverSound.stop();
    level2Music.loop();
    this.state = MihoyoState.RULE;
    this.credit = 0;
    space_CD = 0;
    this.level = 1;
    this.t = 0;
    this.seconds = 0;
    this.player.HP = 100;
    this.player.XY.set(0, 0);
    monsters.length = 0;
    this.currentWeapon.skill = [false, false, false, false, false];
  }

  keyPressed() {
    switch (this.state) {
      case MihoyoState.RULE:
        if (keyCode === ENTER) this.state = MihoyoState.PLAYING;
        break;
      case MihoyoState.PLAYING:
        this.player.keyPressed();
        break;
      case MihoyoState.LOSE:
        if (keyCode === ENTER) this.reset();
        break;
      case MihoyoState.WIN:
        if (keyCode === ENTER) game.reset();
        break;
    }
  }

  keyReleased() {
    this.player.keyReleased();
  }

  mousePressed() {
    if (this.state === MihoyoState.PLAYING)
      this.currentWeapon.mousePressed();
  }
}
