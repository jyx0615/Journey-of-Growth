/////////////--------------音------------------------//////////////////
//mode0 每６０幀畫面隨機一個位置出現音符 在指定的拍數內點擊音符即對範圍造成傷害 done
//mode1 獲得連擊模式 如果連續攻擊的話會有額外的傷害
//mode2 節奏變快    not done
//mode3 空白鍵按下後，怪物會往音符拉近  done
//mode4 操作者無需按到指定位置即可造成傷害  done
//mode5 造成的傷害不再根據完美時間而減少
PVector weaponXY = new PVector(0, 0);

class Weapon2Base {
  PVector XY;
  float time, cd, damage;
  int tick, combo, temp;
  AudioPlayer touch = minim.loadFile("sounds/beats.mp3");

  boolean attack = false;
  boolean draw = false;

  Weapon2Base() {
    this.time = 0;
    this.cd = 0;
    this.XY = new PVector(0, 0);
    this.attack = false;
    this.tick = 60;
    this.draw = false;
    this.damage = 20;
    this.combo = 0;
    this.temp = 0;
  }

  void draw(Player player, PImage music, boolean[] skill, Mihoyo game) {
    if (game.state == MihoyoState.SHOP) {
      return;
    }
    time ++;
    PVector PXY = new PVector(player.XY.x + width/2, player.XY.y + height/2);
    // mode 0
    if (skill[1]) {       //mode 1
      tick = 40;
    }
    if (time % tick == 0) {
      XY.x = PXY.x + random(-width/3, width/3);
      XY.y = PXY.y + random(-height/3, height/3);
      time = 0;
      if (attack == false) {
        combo = 0;
      }
      attack = false;
    }

    image(music, XY.x, XY.y, 100, 100);
    if (attack == false) {
      noFill();
      stroke(255, 255, 0);
      circle(XY.x, XY.y, 100);
      fill(255);
    }
    // 播放節拍音效：標準節奏於第 40 幀（tick = 60），加速節奏於第 30 幀（tick = 40）
    int playFrame = (tick == 60) ? 40 : 30;
    if (time == playFrame) {
      touch.rewind();   // 從頭播放
      touch.play();
    }
    if (mousePressed  && attack == false) {
      if (vector_length(new PVector(PXY.x + mouseX - width/2, PXY.y + mouseY - height/2), XY) < 50
        || skill[3]) {      //mode 3
        weaponXY = new PVector(XY.x, XY.y);
        attack = true;
        float d = 0;
        // mode 4
        if (skill[4]) {
          d = damage;
        } else if (skill[1]) {
          d = damage - abs(30 - (time));   //mode 1
        } else {
          d = damage - abs(40 - (time));
        }
        if (d <= 0) {
          d = 0;
          combo = 0;
        }
        if (skill[0]) {
          d += combo;   //mode 0
          combo += 1;
        }

        for (int i = monsters.size() - 1; i >= 0; i--) {
          Monster m = monsters.get(i);
          if (vector_length(XY, m.XY) < 1000) {
            m.HP -= d;
            if (m.HP <= 0) {
              monsters.remove(i);
              game.credit += 1;
            }
          }
        }
        draw = true;
      }
    }

    if (skill[2]) {    // mode 2
      // 如果空白鍵被按下且冷卻結束，啟動拉近效果並設定冷卻時間
      if (key == ' ' && keyPressed && space_CD == 0) {
        space_CD = 120;
      }

      // 冷卻期間內持續執行拉近效果
      if (space_CD > 90) {
        for (int i = monsters.size() - 1; i >= 0; i--) {
          Monster m = monsters.get(i);
          if (vector_length(XY, m.XY) < 1000) {
            m.XY.x -= cos(vector_angle(XY, m.XY)) * 10;
            m.XY.y -= sin(vector_angle(XY, m.XY)) * 10;
          }
        }
      }
    }
    if (draw) {
      noFill();
      stroke(255, 255, 0);
      circle(weaponXY.x, weaponXY.y, 100 + temp*100 );
      fill(255);
      temp++;
      if (temp > 20) {
        temp = 0;
        draw = false;
      }
    }

    if (skill[0]) {
      // 在模式1時印出combo值
      textAlign(CENTER);
      textSize(32);
      fill(255, 255, 0);
      text("Combo: " + combo, weaponXY.x, weaponXY.y - 50);
      fill(255);
    }

    if (space_CD > 0) space_CD--;
  }
}

class Weapon2 extends WeaponBase {
  Weapon2Base weapon = new Weapon2Base();

  Weapon2(Mihoyo game) {
    super(2, game);
  }

  void draw(Player player, int t) {
    weapon.draw(player, weaponImage, skill, game);
  }

  void mousePressed() {
  }
}
