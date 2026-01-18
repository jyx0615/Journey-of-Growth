// ─── Weapon4Base ───
class Weapon4Base {
  constructor() {
    this.XY = createVector(0, 0);
    this.angle = 0;
    this.speed = 10;
    this.cd = 0;
    this.time = 0;
    this.mode4_cd = 0;
    this.size = 0;
    this.attack = false;
  }

  draw(player, t, yaling, skill) {
    const PXY = createVector(player.XY.x + width / 2, player.XY.y + height / 2);

    // mode 0: basic attack
    if (mouseIsPressed) this.attack = true;

    if (this.attack && this.cd <= 0) {
      this.time++;
      this.XY.x = PXY.x + this.size * cos(this.angle + this.time / 10);
      this.XY.y = PXY.y + this.size * sin(this.angle + this.time / 10);

      this.size = skill[2] ? 200 : 150; // mode 3 enlarge

      image(yaling, this.XY.x, this.XY.y, this.size, this.size);

      // damage monsters
      for (let i = monsters.length - 1; i >= 0; i--) {
        const m = monsters[i];
        if (p5.Vector.dist(this.XY, m.XY) < this.size && !m.hit) {
          m.hit = true;
          m.getHurt(player.ATK);
          m.hitCD = 30;

          if (skill[0]) { // mode 1 knockback
            let knock = p5.Vector.sub(m.XY, PXY).normalize().mult(100);
            m.XY.add(knock);
          }

          if (skill[3]) { // mode 4 DOT
            m.dotTimer = 60;
            m.dotDps = player.ATK / 120.0;
          }
        }
      }

      if (this.time > 20) {
        this.attack = false;
        this.time = 0;
        this.angle = vector_angle(createVector(0, 0), createVector(mouseX - width / 2, mouseY - height / 2)) - PI / 3;
        this.cd = 6;
      }
    }

    // mode 2: dash with spacebar
    if (skill[1] && keyIsPressed && key === ' ' && space_CD <= 0) {
      const dash = createVector(mouseX - width / 2, mouseY - height / 2).normalize().mult(200);
      player.XY.add(dash);

      for (let i = monsters.length - 1; i >= 0; i--) {
        const m = monsters[i];
        const toMonster = p5.Vector.sub(m.XY, PXY);
        const distanceToMonster = toMonster.mag();
        const angleToMonster = p5.Vector.angleBetween(dash, toMonster);

        if (distanceToMonster < 250 && angleToMonster < PI / 6) {
          m.getHurt(100);
        }
      }

      space_CD = 120;
    }

    // update monsters hit cooldown
    for (let i = monsters.length - 1; i >= 0; i--) {
      const m = monsters[i];
      if (m.hitCD > 0) m.hitCD--;
      else m.hit = false;
    }

    this.cd -= 1;
    this.mode4_cd--;

    // mode 5: regenerate HP
    if (skill[4] && t % 60 === 0) {
      player.HP = min(player.HP + 1, player.MAX_HP);
    }
  }
}

// ─── Weapon4 ───
class Weapon4 extends WeaponBase {
  constructor(game) {
    super(4, game);
    this.weapon = new Weapon4Base();
  }

  draw(player, t) {
    this.weapon.draw(player, t, this.weaponImage, this.skill);
  }

  mousePressed() {
    this.weapon.angle = vector_angle(
      createVector(0, 0),
      createVector(mouseX - width / 2, mouseY - height / 2)
    ) - PI / 3;
  }
}
