class Monster {
  constructor(XY, HP, ATK, speed, time, name) {
    this.XY = XY.copy(); // createVector
    this.HP = HP;
    this.ATK = ATK;
    this.speed = speed;
    this.time = time;
    this.name = name;

    this.hit = false;
    this.hitCD = 0;

    this.hurtTimer = 0;
    this.HURT_EFFECT_DURATION = 5;

    // weapon4 DOT
    this.dotTimer = 0; // remaining DOT frames
    this.dotDps = 0;   // damage per frame
  }

  getHurt(damage) {
    if (damage > 0) {
      this.HP -= damage;
      this.hurtTimer = this.HURT_EFFECT_DURATION;
    }
  }

  draw() {
    // Calculate opacity based on despawn timer
    let opacity = 255;
    if (this.time <= 0 && this.time > -60) {
      // Fade out effect in last 1 second
      opacity = map(this.time, 0, -60, 255, 0);
    }

    // Hurt effect (takes priority)
    if (this.hurtTimer > 0) {
      strokeWeight(3);
      stroke(250, 0, 0);
      fill(255, 0, 0, opacity);
      this.hurtTimer--;
    } else {
      stroke(153);
      fill(255, opacity);
    }

    rect(this.XY.x, this.XY.y, 80, 80);

    textAlign(CENTER);
    textSize(40);
    fill(0, opacity);
    text(this.name, this.XY.x, this.XY.y + 10);

    textSize(20);
    fill(255, opacity);
    text("HP: " + this.HP.toFixed(1), this.XY.x, this.XY.y + 60); // one decimal
  }
}

// global monsters array
let monsters = [];

// Helper functions for vectors
function vector_angle(v1, v2) {
  return atan2(v2.y - v1.y, v2.x - v1.x);
}

function vector_length(v1, v2) {
  return dist(v1.x, v1.y, v2.x, v2.y);
}

function DrawMonsters(game) {
  const PX = game.player.XY.x + width / 2;
  const PY = game.player.XY.y + height / 2;
  const PXY = createVector(PX, PY);

  for (let i = monsters.length - 1; i >= 0; i--) {
    const m = monsters[i];

    // weapon4 DOT
    if (m.dotTimer > 0) {
      m.getHurt(m.dotDps);
      m.dotTimer--;
    }

    m.time -= 1;

    const angle = vector_angle(PXY, m.XY);
    m.XY.x -= cos(angle) * m.speed;
    m.XY.y -= sin(angle) * m.speed;

    m.draw();

    // collision with player
    if (vector_length(PXY, m.XY) < 50) {
      game.player.getHurt(1);
      m.HP -= 100;
      game.credit -= 1;
    }

    // remove dead or despawned monster
    if (m.HP <= 0) {
      monsters.splice(i, 1);
      game.credit += 1;
      continue;
    }
    if (m.time <= -60) {
      // Despawned without being killed: no credit reward
      monsters.splice(i, 1);
      continue;
    }

    // collision between monsters
    for (let j = i - 1; j >= 0; j--) {
      const m2 = monsters[j];
      if (vector_length(m.XY, m2.XY) < 10) {
        m.HP += m2.HP;
        monsters.splice(i, 1);
        break;
      }
    }
  }
}
