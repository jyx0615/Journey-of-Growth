class WeaponBase {
  constructor(index, game) {
    this.weaponImage = loadImage("assets/weapons/" + filenames[index] + ".png");
    this.game = game;
    this.skill = [false, false, false, false, false]; // default 5 skills, all locked
  }

  // abstract draw method
  draw(player, t) {
    throw new Error("draw() must be implemented by subclass");
  }

  // abstract mousePressed method
  mousePressed() {
    throw new Error("mousePressed() must be implemented by subclass");
  }
}
