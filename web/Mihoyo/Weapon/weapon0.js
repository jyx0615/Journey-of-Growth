// ─── Weapon0Base ───
class Weapon0Base {
  constructor(XY, angle, speed, time) {
    this.XY = XY.copy();
    this.angle = angle;
    this.speed = speed;
    this.time = time;
  }

  draw(book) {
    this.XY.x += cos(this.angle) * this.speed;
    this.XY.y += sin(this.angle) * this.speed;
    this.time -= 1;
    image(book, this.XY.x, this.XY.y, 100, 100);
  }
}

// ─── Weapon0 ───
class Weapon0 extends WeaponBase {
  constructor(game) {
    super(0, game);
    this.weapons = [];
  }

  add(w) {
    this.weapons.push(w);
  }

  draw(player, t) {
    const PXY = createVector(player.XY.x + width / 2, player.XY.y + height / 2);

    if (game.state === MihoyoState.SHOP) return;

    // mode 0: auto fire
    if (this.skill[0] && keyIsPressed && t % 30 === 0) {
      this.add(
        new Weapon0Base(
          PXY,
          vector_angle(createVector(0, 0), player.speed),
          15,
          300
        )
      );
    }

    // mode 1: auto target random monster
    if (this.skill[1] && t % 30 === 0 && monsters.length > 0) {
      const target = monsters[int(random(monsters.length))].XY;
      this.add(new Weapon0Base(PXY, vector_angle(PXY, target), 15, 300));
    }

    // mode 2: spacebar scatter
    if (this.skill[2] && keyIsPressed && key === ' ' && space_CD <= 0) {
      for (let i = 0; i < 10; i++) {
        this.add(new Weapon0Base(PXY, random(0, TWO_PI), 15, 300));
      }
      space_CD = 300;
    }

    // update all bullets
    for (let i = this.weapons.length - 1; i >= 0; i--) {
      const w = this.weapons[i];
      w.draw(this.weaponImage);

      let removed = false;

      for (let j = monsters.length - 1; j >= 0; j--) {
        const m = monsters[j];
        if (p5.Vector.dist(w.XY, m.XY) < 200 && m.time <= 0) {
          m.getHurt(player.ATK);
          if (this.skill[4]) {
            m.time = 17; // piercing
          } else {
            this.weapons.splice(i, 1);
            removed = true;
            break;
          }
        }
      }
      if (removed) continue;

      if (w.time <= 0) {
        if (this.skill[3] && w.speed !== 0) {
          w.speed = 0;
          w.time += 300; // freeze
        } else {
          this.weapons.splice(i, 1);
        }
      }
    }
  }

  mousePressed() {
    const PXY = createVector(this.game.player.XY.x + width / 2, this.game.player.XY.y + height / 2);
    this.add(
      new Weapon0Base(
        PXY,
        vector_angle(createVector(0, 0), createVector(mouseX - width / 2, mouseY - height / 2)),
        15,
        300
      )
    );
  }
}
