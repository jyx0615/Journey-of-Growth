// 體
class Weapon4Base {
  PVector XY;
  float angle, speed, cd, time;
  float mode4_cd;
  int size;
  boolean attack = false;
  
  Weapon4Base() {
    this.angle = 0;
    this.speed = 10; this.cd = 0; this.time = 0; this.mode4_cd = 0; this.size = 0;
    this.XY = new PVector(0, 0);
  }

  void draw(Player player, int t, PImage yaling, boolean[] skill) {
    PVector PXY = new PVector(player.XY.x + width/2, player.XY.y + height/2);
    // mode 0
    
    if (mousePressed) {
      attack = true;
    }

    if (attack && cd <= 0) {
      time++;
      XY.x = PXY.x + size*(cos(angle + time/10));
      XY.y = PXY.y + size*sin(angle + time/10);
      //mode2 加大啞鈴
      if (skill[2]){
        size = 200;
      }else{
        size = 150;
      }
      image(yaling, XY.x, XY.y,
      size, size);
      for (int i = monsters.size() - 1; i >= 0; i--) {
        Monster m = monsters.get(i);
        if (vector_length(XY , m.XY) < size && m.hit == false) {
          m.hit = true;
          m.HP -= player.ATK;
          m.hitCD = 30;
          // mode 1 擊中後怪物擊退
          if (skill[0] ) { 
            PVector knock = PVector.sub(m.XY, PXY);
            knock.normalize();
            knock.mult(100);     // 擊退距離
            m.XY.add(knock);
          }
          // mode3 給怪物上dot
          if (skill[3]) {            
            m.dotTimer = 60;                     // 持續 60 真
            m.dotDps   = player.ATK / 120.0;   // 每針扣血
          }
        }
      }
      if (time > 20) {
        attack = false;
        time = 0;
        angle = vector_angle(new PVector(0, 0), new PVector(mouseX - width/2, mouseY - height/2)) - PI/3;
        cd = 6;
      }
    }
    // mode 0
    if (skill[0] && keyPressed && t % 30 == 0);

    // mode 1 空白鍵向前衝刺 造成傷害
    if (skill[1] && key == ' ' && keyPressed && space_CD <= 0) {
      // 鼠標方向
      PVector dash = new PVector(mouseX - width/2, mouseY - height/2);
      dash.normalize();
      dash.mult(200); // 衝刺距離

      int tempHP = player.HP;
      player.XY.add(dash);
      
      for (int i = monsters.size() - 1; i >= 0; i--) {
        Monster m = monsters.get(i);
        PVector toMonster = PVector.sub(m.XY, PXY);
        float distanceToMonster = toMonster.mag();
        float angleToMonster = PVector.angleBetween(dash, toMonster);

        if (distanceToMonster < 250 && angleToMonster < PI/6) {      
          m.HP -= 100; // 衝刺攻擊    
        }
      }
      player.HP = tempHP; // 恢復血量
      
      space_CD = 120; // 衝刺CD
    }
    if (skill[1] && key == ' ' && keyPressed ) {
    }

    // mode 3
    // if (weapon_mode % 8 > 3 && key == ' ' && keyPressed && space_CD <= 0) {
    //   for (int i = 0; i < 10; i++)
    //     Weapon_id.add(new Weapon_id(new PVector(PXY.x, PXY.y),
    //     random(0, 2 * PI), 15, 300));
    //   space_CD = 300;
    // }
    
    // 更新怪物的被擊中冷卻，倒數至 0 後恢復可被擊中狀態
    for (int i = monsters.size() - 1; i >= 0; i--) {
      Monster m = monsters.get(i);
      if (m.hitCD > 0) {
        m.hitCD--;
      } else {
        m.hit = false;
      }
    }
    cd -= 1;
    mode4_cd --;
    
    // mode 4 站著時每秒回一滴血
    if (skill[4] && t % 60 == 0) {
      player.HP = min(player.HP + 1, player.MAX_HP);
    }
  }
}

class Weapon4 extends WeaponBase {
  Weapon4Base weapon = new Weapon4Base();

  Weapon4(Mihoyo game) {
    super(4, game);
  }

  void draw(Player player, int t) {
    weapon.draw(player, t, weaponImage, skill);
  }

  void mousePressed() {
    weapon.angle = vector_angle(new PVector(0, 0), new PVector(mouseX - width/2, mouseY - height/2)) - PI/3;   
  }
}

//1 攻擊擊退
//2 空白鍵向前衝刺 消滅路進上敵人
//3 加大啞鈴
//4 給怪物上dot
//5 站著時每秒回一滴血
