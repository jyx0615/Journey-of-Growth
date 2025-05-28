//  理
// 路徑上造成數字一半的傷害
// 0 變為一擊必殺
// 增加怪物當前血量的50%作為傷害
// 空白鍵將所有數字改為 9 (CD:1)
// 每次點擊多一次隨機

class Weapon1Base {
  PVector XY, targetXY;
  float angle;
  int num;
  Weapon1Base(PVector XY, PVector targetXY, float angle, int num) {
    this.XY = XY;
    this.targetXY = targetXY;
    this.angle = angle;
    this.num = num;
  }

  void draw(boolean[] skill) {
    XY.x += cos(angle) * 50;
    XY.y += sin(angle) * 50;

    noStroke();
    fill(0);
    circle(XY.x, XY.y, 50);
    fill(0, 255, 0);
    textSize(50);
    text(num, XY.x, XY.y + 20);
    noFill();
    stroke(255, 0, 0);
    strokeWeight(5);
    circle(targetXY.x, targetXY.y, 50);
    noStroke();
    for (int j = monsters.size() - 1; j >= 0; j--) {
      Monster m = monsters.get(j);
      if (vector_length(targetXY, m.XY) < 100 && vector_length(targetXY, XY) < 100) {
        if (skill[1] && num == 0) { // 0 變成必殺 mode 1
          m.getHurt(m.HP);
        }
        if (skill[2]) { // 增加怪物當前血量的一半 mode 2
          m.getHurt(int(m.HP/2));
        }
        m.getHurt(num);
      }
      if (skill[0]) { // 路徑傷害 mode 0
        if (vector_length(XY, m.XY) < 100) {
          m.getHurt(num/2);
          break;
        }
      }
    }
  }
}

class Weapon1 extends WeaponBase {
  ArrayList<Weapon1Base> weapons = new ArrayList<Weapon1Base>();

  Weapon1(Mihoyo game) {
    super(1, game);
  }

  void add(Weapon1Base w) {
    weapons.add(w);
  }

  void draw(Player player, int t) {
    textAlign(CENTER);
    for (int i = weapons.size() - 1; i >= 0; i--) {
      Weapon1Base w = weapons.get(i);
      w.draw(skill);
      if (vector_length(w.XY, w.targetXY) < 100) {
        weapons.remove(i);
      }
    }
    fill(255);
    if (skill[3] && keyPressed && key == ' ' && space_CD <= 0) { // 空白鍵將所有數字改為 9 (CD:1) mode 3
      for (int i = weapons.size() - 1; i >= 0; i--) {
        Weapon1Base w = weapons.get(i);
        w.num = 9;
      }
      space_CD = 60;
    }
  }

  void mousePressed() {
    float randomangle = random(0, 2 * PI);
    weapons.add(new Weapon1Base(
      new PVector(mouseX + game.player.XY.x - 800 * cos(randomangle), mouseY + game.player.XY.y - 800 * sin(randomangle)),
      new PVector(mouseX + game.player.XY.x, mouseY + game.player.XY.y),
      randomangle, int(random(0, 10))));
    if (game.currentWeapon.skill[4]) { // 隨機攻擊 mode 4
      randomangle = random(0, 2 * PI);
      float randomX = random(-width, width);
      float randomY = random(-height, height);
      weapons.add(new Weapon1Base(
        new PVector(randomX + game.player.XY.x - 800 * cos(randomangle), randomY + game.player.XY.y - 800 * sin(randomangle)),
        new PVector(randomX + game.player.XY.x, randomY + game.player.XY.y),
        randomangle, int(random(0, 10))));
    }
  }
}
