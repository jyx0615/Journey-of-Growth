// ─── Weapon1Base ───
class Weapon1Base {
  constructor(XY, targetXY, angle, num) {
    this.XY = XY.copy();          // p5.Vector
    this.targetXY = targetXY.copy();
    this.angle = angle;
    this.num = num;
  }

  draw(skill) {
    // Move along angle
    this.XY.x += cos(this.angle) * 50;
    this.XY.y += sin(this.angle) * 50;

    // Draw projectile
    noStroke();
    fill(0);
    circle(this.XY.x, this.XY.y, 50);
    fill(0, 255, 0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text(this.num, this.XY.x, this.XY.y + 20);

    // Draw target indicator
    noFill();
    stroke(255, 0, 0);
    strokeWeight(5);
    circle(this.targetXY.x, this.targetXY.y, 50);
    noStroke();

    // Damage monsters
    for (let j = monsters.length - 1; j >= 0; j--) {
      let m = monsters[j];
      const distTarget = dist(this.targetXY.x, this.targetXY.y, m.XY.x, m.XY.y);
      const distPath = dist(this.XY.x, this.XY.y, m.XY.x, m.XY.y);

      // Mode 1: 0 becomes instant kill
      if (skill[1] && this.num === 0 && distTarget < 100 && distPath < 100) {
        m.getHurt(m.HP);
      }
      // Mode 2: add half of current HP as damage
      if (skill[2] && distTarget < 100 && distPath < 100) {
        m.getHurt(Math.floor(m.HP / 2));
      }
      // Normal damage
      if (distTarget < 100 && distPath < 100) {
        m.getHurt(this.num);
      }

      // Mode 0: path damage
      if (skill[0] && distPath < 100) {
        m.getHurt(this.num / 2);
        break;
      }
    }
  }
}

// ─── Weapon1 ───
class Weapon1 extends WeaponBase {
  constructor(game) {
    super(1, game);
    this.weapons = [];
  }

  add(w) {
    this.weapons.push(w);
  }

  draw(player, t) {
    textAlign(CENTER, CENTER);

    for (let i = this.weapons.length - 1; i >= 0; i--) {
      let w = this.weapons[i];
      w.draw(this.skill);

      if (dist(w.XY.x, w.XY.y, w.targetXY.x, w.targetXY.y) < 100) {
        this.weapons.splice(i, 1); // remove when reaching target
      }
    }

    // Mode 3: space key turns all numbers to 9
    if (this.skill[3] && keyIsPressed && key === ' ' && space_CD <= 0) {
      for (let i = this.weapons.length - 1; i >= 0; i--) {
        this.weapons[i].num = 9;
      }
      space_CD = 60;
    }
  }

  mousePressed() {
    let randomangle = random(0, TWO_PI);
    let startX = mouseX + this.game.player.XY.x - 800 * cos(randomangle);
    let startY = mouseY + this.game.player.XY.y - 800 * sin(randomangle);
    this.weapons.push(new Weapon1Base(
      createVector(startX, startY),
      createVector(mouseX + this.game.player.XY.x, mouseY + this.game.player.XY.y),
      randomangle,
      int(random(0, 10))
    ));

    // Mode 4: extra random attack
    if (this.game.currentWeapon.skill[4]) {
      randomangle = random(0, TWO_PI);
      let randomX = random(-width, width);
      let randomY = random(-height, height);
      this.weapons.push(new Weapon1Base(
        createVector(randomX + this.game.player.XY.x - 800 * cos(randomangle),
                     randomY + this.game.player.XY.y - 800 * sin(randomangle)),
        createVector(randomX + this.game.player.XY.x, randomY + this.game.player.XY.y),
        randomangle,
        int(random(0, 10))
      ));
    }
  }
}
