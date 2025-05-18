class Monster {
  PVector XY;
  float   HP, ATK, speed;
  int     time;
  String  name;
  boolean hit;
  int hitCD; // 被擊中冷卻時間
  // ── weapon4_DOT ──

  int   dotTimer ;   // 剩餘 DOT 時間（frame）
  float dotDps   ;   // 每 frame 扣血量

  Monster(PVector XY, float HP, float ATK, float speed, int time, String name) {
    this.XY = XY;
    this.HP = HP;
    this.ATK = ATK;
    this.speed = speed;
    this.time = time;
    this.name = name;
    this.hit = false;
    // 初始化 DOT
    this.dotTimer = 0;
    this.dotDps   = 0;
    this.hitCD = 0;
  }

  void draw(PVector m, String name) {
    stroke(153);
    rect(m.x, m.y, 80, 80);
    textAlign(CENTER);
    textSize(40);
    fill(0);
    text(name, m.x, m.y + 10);
    textSize(20);
    fill(255);
    text("HP: " + nf(HP, 0, 1), m.x, m.y + 60);  // 顯示至小數點後 1 位
  }
}

ArrayList<Monster> monsters   = new ArrayList<Monster>();

void DrawMonsters(Mihoyo game) {
  float PX = game.player.XY.x + width/2;
  float PY = game.player.XY.y + height/2;
  PVector PXY = new PVector(PX, PY);

  for (int i = 0; i < monsters.size(); i++) {
    Monster m = monsters.get(i);
    // ── weapon4_DOT  ──
    if (m.dotTimer > 0) {
      m.HP -= m.dotDps;
      m.dotTimer--;
    }
    m.time -= 1;
    m.XY.x -= cos(vector_angle(PXY, m.XY)) * m.speed;
    m.XY.y -= sin(vector_angle(PXY, m.XY)) * m.speed;
    m.draw(m.XY, m.name);
    if (vector_length(PXY, m.XY) < 50) {
      game.player.HP -= 1;
      m.HP -= 100;
      game.credit -= 1;
    }
    if (m.HP <= 0) {
      monsters.remove(i);
      game.credit += 1;
    }
    for (int j = i + 1; j < monsters.size(); j++) {
      Monster m2 = monsters.get(j);
      if (vector_length(m.XY, m2.XY) < 10) {
        m.HP += m2.HP;
        monsters.remove(i);
      }
    }
  }
}
