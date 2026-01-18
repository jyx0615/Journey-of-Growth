// ─── Weapon3Base ───
class Weapon3Base {
  constructor(XY, size) {
    this.XY = XY.copy();
    this.size = size;
  }

  draw(R, G, B, skill) {
    fill(R, G, B);
    noStroke();
    circle(this.XY.x, this.XY.y, this.size);
    fill(255);
    strokeWeight(5);

    // damage monsters
    for (let j = monsters.length - 1; j >= 0; j--) {
      let m = monsters[j];
      if (p5.Vector.dist(this.XY, m.XY) < this.size) {
        this.size -= 1;
        if (skill[1] && m.speed > 1) m.speed = 1; // mode 2: slow
        if (skill[4]) { // mode 5: pull monsters
          let v = p5.Vector.sub(this.XY, m.XY);
          let l = v.mag();
          v.div(l * 2);
          m.XY.add(v);
        }
        m.getHurt(floor(random(0, 2)));
      }
    }

    // mode 1: stop time
    if (skill[0] && keyIsPressed && key === ' ' && space_CD === 0) {
      for (let i = monsters.length - 1; i >= 0; i--) {
        monsters[i].speed = 0;
      }
      space_CD = 600;
    }
  }
}

// ─── Weapon3 ───
class Weapon3 extends WeaponBase {
  constructor(game) {
    super(3, game);
    this.size = 50;
    this.R = random(255);
    this.G = random(255);
    this.B = random(255);
    this.weapons = [];
  }

  add(w) {
    this.weapons.push(w);
  }

  draw(player, t) {
    if (mouseIsPressed) {
      this.size += random(-1, 1);
      this.R += random(-1, 1);
      this.G += random(-1, 1);
      this.B += random(-1, 1);

      this.size = max(this.size, 10);
      this.R = constrain(this.R, 0, 255);
      this.G = constrain(this.G, 0, 255);
      this.B = constrain(this.B, 0, 255);

      if (this.skill[3] && this.size < 100) this.size = 100; // mode 3: enlarge

      this.add(new Weapon3Base(createVector(mouseX + this.game.player.XY.x, mouseY + this.game.player.XY.y), this.size));

      if (this.weapons.length > 100) {
        if (this.skill[2] && this.weapons.length > 200) this.weapons.shift(); // mode 3: extend
        else this.weapons.shift();
      }
    }

    for (let i = this.weapons.length - 1; i >= 0; i--) {
      this.weapons[i].draw(this.R, this.G, this.B, this.skill);
    }
  }

  mousePressed() {
    // handled inside draw
  }
}
