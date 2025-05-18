// 文
class Weapon0Base {
  PVector XY;
  float angle, speed, time;

  Weapon0Base(PVector XY, float angle, float speed, float time) {
    this.XY = XY;
    this.angle = angle;
    this.speed = speed;
    this.time = time;
  }

  void draw(PImage book) {
    XY.x += cos(angle) * speed;
    XY.y += sin(angle) * speed;
    time -= 1;
    image(book, XY.x, XY.y, 100, 100);
  }
}

class Weapon0 extends WeaponBase {
  ArrayList<Weapon0Base> weapons = new ArrayList<Weapon0Base>();
  Weapon0(Mihoyo game) {
    super(0, game);
  }

  void add(Weapon0Base w) {
    weapons.add(w);
  }

  void draw(Player player, int t) {
    PVector PXY = new PVector(player.XY.x + width/2, player.XY.y + height/2);
    if (game.state == MihoyoState.SHOP) {
      return;
    }

    // mode 0
    if (skill[0] && keyPressed && t % 30 == 0)
      add(new Weapon0Base(new PVector(PXY.x, PXY.y),
        vector_angle(new PVector(0, 0), player.speed), 15, 300));

    // mode 1
    if (skill[1] && t % 30 == 0 && monsters.size() > 0)
      add(new Weapon0Base(PXY,
        vector_angle(PXY, monsters.get(int(random(monsters.size()))).XY), 15, 300));

    // mode 2
    if (skill[2] && key == ' ' && keyPressed && space_CD <= 0) {
      for (int i = 0; i < 10; i++)
        add(new Weapon0Base(new PVector(PXY.x, PXY.y),
          random(0, 2 * PI), 15, 300));
      space_CD = 300;
    }

    // 飛行 & 判定
    for (int i = weapons.size() - 1; i >= 0; i--) {
      Weapon0Base w = weapons.get(i);
      w.draw(weaponImage);

      boolean removed = false;
      for (int j = monsters.size() - 1; j >= 0; j--) {
        Monster m = monsters.get(j);
        if (vector_length(w.XY, m.XY) < 140 && m.time <= 0) {
          m.HP -= player.ATK;
          if (skill[4])
            m.time = 17;         // 貫穿
          else {
            weapons.remove(i);
            removed = true;
            break;
          }
        }
      }
      if (removed) break;

      if (w.time <= 0) {
        if (skill[3] && w.speed != 0) {
          w.speed = 0;
          w.time += 300;
        } // 停留
        else
          weapons.remove(i);
      }
    }
  }

  void mousePressed() {
    add(new Weapon0Base(new PVector(game.player.XY.x + width/2, game.player.XY.y + height/2),
      vector_angle(new PVector(0, 0), new PVector(mouseX - width/2, mouseY - height/2)), 15, 300));
  }
}
