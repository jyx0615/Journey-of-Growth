// 藝
class Weapon3Base {
  PVector XY;
  float size;

  Weapon3Base(PVector XY, float size) {
    this.size = size;
    this.XY = XY;
  }

  void draw(float R, float G, float B, boolean[] skill) {
    fill(R, G, B);
    noStroke();
    circle(XY.x, XY.y, size);
    fill(255);
    strokeWeight(5);
    for (int j = monsters.size() - 1; j >= 0; j--) {
      Monster m = monsters.get(j);
      if (vector_length(XY, m.XY) < size) {
        size -= 1;
        if (skill[1] && m.speed > 1)
          m.speed = 1; // 減速 mode 2
        if (skill[4]) {
          float l = XY.dist(m.XY);
          PVector v = PVector.sub(XY, m.XY);
          v = v.div(l*2);
          m.XY.add(v);
        }// 聚怪 mode 5
        m.getHurt(int(random(0, 2)));
      }
    }

    if (skill[0] && keyPressed && key == ' ' && space_CD == 0) { // 時停 mode 1
      for (int i = monsters.size() - 1; i >= 0; i--) {
        Monster m = monsters.get(i);
        m.speed = 0;
        space_CD = 600;
      }
    }
  }
}

class Weapon3 extends WeaponBase {
  float size = 50, R = random(255), G = random(255), B = random(255);
  ArrayList<Weapon3Base> weapons = new ArrayList<Weapon3Base>();

  Weapon3(Mihoyo game) {
    super(3, game);
  }

  void add(Weapon3Base w) {
    weapons.add(w);
  }

  void draw(Player player, int t) {
    if (mousePressed) {
      size += random(-1, 1);
      R += random(-1, 1);
      G += random(-1, 1);
      B += random(-1, 1);
      if (size < 10) size = 10;
      R = constrain(R, 0, 255);
      G = constrain(G, 0, 255);
      B = constrain(B, 0, 255);
      if (skill[3] && size < 100) size = 100; // mode 3 變大
      add(new Weapon3Base(new PVector(mouseX + game.player.XY.x, mouseY + game.player.XY.y), size));
      if (weapons.size() > 100 ) {
        if (game.currentWeapon.skill[2] && weapons.size() > 200) {
          weapons.remove(0);
        } // mode 3 變長
        else weapons.remove(0);
      }
    }
    for (int i = weapons.size() - 1; i >= 0; i--) {
      Weapon3Base w = weapons.get(i);
      w.draw(R, G, B, skill);
    }
  }

  void mousePressed() {
  }
}
