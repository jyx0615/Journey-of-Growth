class Role {
  constructor() {
    this.curV = 0;
    this.curX = 0;
    this.curY = 0;
    this.curJumpCount = 0;
    this.actionIndex = 0;

    this.jump = false;
    this.faceRight = true;
    this.spacePressed = false;

    this.rockImg = null;

    this.roleImgs = new Array(3);
    this.roleImgsLeft = new Array(3);
    this.roleFireImgs = new Array(3);
    this.roleFireImgsLeft = new Array(3);

    this.loadRoleImages();
    this.reset();
  }

  loadRoleImages() {
    this.roleFireImgs[0] = loadImage("assets/roles/fire1.png");
    this.roleFireImgs[1] = loadImage("assets/roles/fire2.png");
    this.roleFireImgs[2] = loadImage("assets/roles/fire3.png");

    this.roleFireImgsLeft[0] = loadImage("assets/roles/fire1L.png");
    this.roleFireImgsLeft[1] = loadImage("assets/roles/fire2L.png");
    this.roleFireImgsLeft[2] = loadImage("assets/roles/fire3L.png");

    this.roleImgs[0] = loadImage("assets/roles/normal1.png");
    this.roleImgs[1] = loadImage("assets/roles/normal2.png");
    this.roleImgs[2] = loadImage("assets/roles/normal3.png");

    this.roleImgsLeft[0] = loadImage("assets/roles/normal1L.png");
    this.roleImgsLeft[1] = loadImage("assets/roles/normal2L.png");
    this.roleImgsLeft[2] = loadImage("assets/roles/normal3L.png");

    this.rockImg = loadImage("assets/roles/rock.png");
  }

  reset() {
    this.curX = 300;
    this.curY = 539;
    this.curV = 0;
    this.curJumpCount = 0;
    this.jump = false;
    this.faceRight = true;
    this.actionIndex = 0;
    this.spacePressed = false;
  }

  updateByKeyPress() {
    // move when not frozen
    if (game.doodleJump.freezeTimer === 0) {

      // jump - only trigger on space key press transition (not held)
      if ((key === ' ' || keyCode === 32) && !this.spacePressed && this.curJumpCount < MAX_JUMP_COUNT) {
        this.jump = true;
        this.curV = JUMP_V0;
        this.curJumpCount += 1;
        this.spacePressed = true;

        game.doodleJump.jumpSound.stop();
        game.doodleJump.jumpSound.play();
      }

      // horizontal movement - move continuously while keys are pressed
      if (keyIsPressed) {
        if (keyCode === 37) { // LEFT arrow
          this.faceRight = false;
          this.actionIndex = (this.actionIndex + 1) % ROLE_ACTION_COUNT;
          if (this.curX >= 20) this.curX -= 8;
        } else if (keyCode === 39) { // RIGHT arrow
          this.faceRight = true;
          this.actionIndex = (this.actionIndex + 1) % ROLE_ACTION_COUNT;
          if (this.curX <= width - 20 - ROLE_WIDTH) this.curX += 8;
        }
      }
    }
  }

  resetSpaceKey() {
    this.spacePressed = false;
  }

  draw() {
    // frozen state
    if (game.doodleJump.freezeTimer > 0) {
      image(this.rockImg, this.curX, this.curY, ROLE_WIDTH, ROLE_HEIGHT);
      return;
    }

    let indexToShow = this.actionIndex;
    if (this.jump) indexToShow = 2;

    if (this.faceRight) {
      if (game.doodleJump.fireTimer > 0)
        image(this.roleFireImgs[indexToShow], this.curX, this.curY, ROLE_WIDTH, ROLE_HEIGHT);
      else
        image(this.roleImgs[indexToShow], this.curX, this.curY, ROLE_WIDTH, ROLE_HEIGHT);
    } else {
      if (game.doodleJump.fireTimer > 0)
        image(this.roleFireImgsLeft[indexToShow], this.curX, this.curY, ROLE_WIDTH, ROLE_HEIGHT);
      else
        image(this.roleImgsLeft[indexToShow], this.curX, this.curY, ROLE_WIDTH, ROLE_HEIGHT);
    }
  }
}
