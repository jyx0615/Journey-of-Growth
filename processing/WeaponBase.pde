abstract class WeaponBase {
  PImage weaponImage;
  Mihoyo game;
  boolean[] skill = {false, false, false, false, false};

  WeaponBase(int index, Mihoyo game) {
    weaponImage = loadImage("weapons/" + filenames[index] + ".png");
    this.game = game;
  }

  abstract void draw(Player player, int t);
  abstract void mousePressed();
}
