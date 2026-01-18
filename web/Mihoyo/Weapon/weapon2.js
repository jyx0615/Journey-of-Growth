// ─── Weapon2Base ───
class Weapon2Base {
  constructor() {
    this.XY = createVector(0, 0);
    this.time = 0;
    this.cd = 0;
    this.damage = 20;
    this.tick = 60;
    this.combo = 0;
    this.temp = 0;
    this.attack = false;
    this.drawEffect = false;
    this.touch = loadSound("assets/sounds/beats.mp3"); // p5.js version of AudioPlayer
  }

  draw(player, musicImg, skill, game) {
    if (game.state === MihoyoState.SHOP) return;

    this.time++;
    const PXY = createVector(player.XY.x + width / 2, player.XY.y + height / 2);

    // mode 2: faster rhythm
    if (skill[1]) this.tick = 40;

    // spawn new note every tick
    if (this.time % this.tick === 0) {
      this.XY.x = PXY.x + random(-width / 3, width / 3);
      this.XY.y = PXY.y + random(-height / 3, height / 3);
      this.time = 0;
      if (!this.attack) this.combo = 0;
      this.attack = false;
    }

    // draw music note
    imageMode(CENTER);
    image(musicImg, this.XY.x, this.XY.y, 100, 100);

    if (!this.attack) {
      noFill();
      stroke(255, 255, 0);
      circle(this.XY.x, this.XY.y, 100);
      fill(255);
    }

    // play beat sound at proper frame
    let playFrame = (this.tick === 60) ? 40 : 30;
    if (this.time === playFrame && this.touch.isLoaded()) {
      this.touch.stop();
      this.touch.play();
    }

    // player click attack
    if (mouseIsPressed && !this.attack) {
      const mousePos = createVector(PXY.x + mouseX - width / 2, PXY.y + mouseY - height / 2);
      if (p5.Vector.dist(mousePos, this.XY) < 50 || skill[3]) { // mode 4
        weaponXY = this.XY.copy();
        this.attack = true;
        let d = 0;

        // mode 5: damage ignores timing
        if (skill[4]) {
          d = this.damage;
        } else if (skill[1]) {
          d = this.damage - abs(30 - this.time); // faster mode
        } else {
          d = this.damage - abs(40 - this.time);
        }

        if (d <= 0) {
          d = 0;
          this.combo = 0;
        }

        // mode 1: combo bonus
        if (skill[0]) {
          d += this.combo;
          this.combo++;
        }

        // apply damage to monsters
        for (let i = monsters.length - 1; i >= 0; i--) {
          const m = monsters[i];
          if (p5.Vector.dist(this.XY, m.XY) < 1000) {
            m.getHurt(d);
            if (m.HP <= 0) {
              monsters.splice(i, 1);
              game.credit += 1;
            }
          }
        }
        this.drawEffect = true;
      }
    }

    // mode 3: pull monsters towards note
    if (skill[2] && keyIsPressed && key === ' ' && space_CD === 0) {
      space_CD = 120;
    }
    if (space_CD > 90) {
      for (let i = monsters.length - 1; i >= 0; i--) {
        const m = monsters[i];
        if (p5.Vector.dist(this.XY, m.XY) < 1000) {
          const angle = atan2(m.XY.y - this.XY.y, m.XY.x - this.XY.x);
          m.XY.x -= cos(angle) * 10;
          m.XY.y -= sin(angle) * 10;
        }
      }
    }

    // draw attack effect
    if (this.drawEffect) {
      noFill();
      stroke(255, 255, 0);
      circle(weaponXY.x, weaponXY.y, 100 + this.temp * 100);
      fill(255);
      this.temp++;
      if (this.temp > 20) {
        this.temp = 0;
        this.drawEffect = false;
      }
    }

    // draw combo text in mode 1
    if (skill[0]) {
      textAlign(CENTER, CENTER);
      textSize(32);
      fill(255, 255, 0);
      text("Combo: " + this.combo, weaponXY.x, weaponXY.y - 50);
      fill(255);
    }

    if (space_CD > 0) space_CD--;
  }
}

// ─── Weapon2 ───
class Weapon2 extends WeaponBase {
  constructor(game) {
    super(2, game);
    this.weapon = new Weapon2Base();
  }

  draw(player, t) {
    this.weapon.draw(player, this.weaponImage, this.skill, this.game);
  }

  mousePressed() {
    // handled inside Weapon2Base
  }
}
