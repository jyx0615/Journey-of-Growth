class Player {
  constructor(XY, speed, HP, ATK, career) {
    this.XY = XY;           // createVector(x, y)
    this.speed = speed;     // createVector(vx, vy)
    this.HP = HP;
    this.ATK = ATK;
    this.MAX_HP = HP;

    this.faceRight = true;           // 預設面向右側
    this.hurtTimer = 0;
    this.HURT_EFFECT_DURATION = 20;

    // Load images (should ideally be preloaded)
    this.weaponImg = loadImage("assets/weapons/" + filenames[career] + ".png");
    this.playerL = loadImage("assets/pic/playerL.png");
    this.playerR = loadImage("assets/pic/playerR.png");
  }

  getHurt(damage) {
    this.HP -= damage;
    this.hurtTimer = this.HURT_EFFECT_DURATION;
  }

  draw() {
    // hurt tint effect
    if (this.hurtTimer > 0) {
      tint(255, 80, 80); // red tint
      this.hurtTimer--;
    } else {
      noTint();
    }

    // draw player
    if (this.faceRight) {
      image(this.playerR, width / 2, height / 2, 100, 100);
    } else {
      image(this.playerL, width / 2, height / 2, 100, 100);
    }

    noTint();
    image(this.weaponImg, width / 2 + 40, height / 2 + 25, 50, 50);

    // draw stats
    textSize(20);
    textAlign(CENTER);
    if (space_CD > 0) space_CD -= 1; // note: space_CD must be global
    text("CD: " + Math.floor(space_CD / 60), width / 2, height / 2 - 50);
    text("HP: " + this.HP, width / 2, height / 2 + 70);

    textSize(10);
    textAlign(RIGHT);
    text("XY: " + Math.floor(this.XY.x) + ", " + Math.floor(this.XY.y), width - 10, height - 30);
  }

  keyPressed() {
    // WASD or Arrow Keys
    if ((key === 'w' || keyCode === 38) && this.speed.y > -v) this.speed.y -= v; // Up / W
    if ((key === 'a' || keyCode === 37) && this.speed.x > -v) {
      this.speed.x -= v;
      this.faceRight = false;
    }
    if ((key === 's' || keyCode === 40) && this.speed.y < v) this.speed.y += v; // Down / S
    if ((key === 'd' || keyCode === 39) && this.speed.x < v) {
      this.speed.x += v;
      this.faceRight = true;
    }
  }

  keyReleased() {
    if ((key === 'w' || keyCode === 38) && this.speed.y < v) this.speed.y += v; // Up / W
    if ((key === 'a' || keyCode === 37) && this.speed.x < v) this.speed.x += v; // Left / A
    if ((key === 's' || keyCode === 40) && this.speed.y > -v) this.speed.y -= v; // Down / S
    if ((key === 'd' || keyCode === 39) && this.speed.x > -v) this.speed.x -= v; // Right / D
  }
}
