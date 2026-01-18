// --------------------
// Enum replacements
// --------------------

const Subject = Object.freeze({
  LITERATURE: 0,
  SCIENCE: 1,
  MUSIC: 2,
  ART: 3,
  SPORTS: 4,
  NONE: 5
});

const IconType = Object.freeze({
  LITERATURE: 0,
  SCIENCE: 1,
  MUSIC: 2,
  ART: 3,
  SPORTS: 4,
  CERTIFICATE: 5,
  CLOCK: 6,
  QUIZ: 7,
  NONE: 8
});

const iconTypes = Object.values(IconType).filter(v => typeof v === "number");

// --------------------
// Helper functions
// --------------------

function iconTypeToSubject(iconType) {
  switch (iconType) {
    case IconType.LITERATURE:
      return Subject.LITERATURE;
    case IconType.SCIENCE:
      return Subject.SCIENCE;
    case IconType.MUSIC:
      return Subject.MUSIC;
    case IconType.ART:
      return Subject.ART;
    case IconType.SPORTS:
      return Subject.SPORTS;
    default:
      return Subject.NONE;
  }
}

// --------------------
// Block class
// --------------------

class Block {
  constructor(blockLeft, blockLevel, blockCountIn) {
    this.left = blockLeft;
    this.level = blockLevel;
    this.blockCount = blockCountIn;

    this.iconX = 0;
    this.showIcon = true;
    this.iconType = IconType.NONE;
    this.subject = Subject.NONE;

    while (
      this.left + this.blockCount * BLOCK_IMG_WIDTH > width &&
      this.blockCount > 1
    ) {
      this.blockCount--;
    }

    if (blockLevel === 0) {
      this.iconType = IconType.QUIZ;
      this.showIcon = false;
      return;
    }

    if (blockLevel === MAX_LEVEL) {
      this.iconType = IconType.NONE;
    } else {
      this.iconType = this.getRandomIconType();
    }

    this.iconX = this.getRandomIconX();
    this.showIcon = true;
  }

  getRandomIconType() {
    // add quiz every 5 levels
    if (this.level % 5 === 1) {
      return IconType.QUIZ;
    }

    let index;
    if (random(1) > 0.8) {
      index = floor(random(5, 7)); // CERTIFICATE or CLOCK
    } else {
      index = floor(random(0, 5));
      this.subject = iconTypeToSubject(iconTypes[index]);
    }

    return iconTypes[index];
  }

  getRandomIconX() {
    return (
      this.left +
      floor(random(0, this.blockCount * BLOCK_IMG_WIDTH - ICONSIZE))
    );
  }

  draw(y) {
    for (let i = 0; i < this.blockCount; i++) {
      const blockLeft = this.left + BLOCK_IMG_WIDTH * i;
      const index = this.iconType;
      image(
        game.doodleJump.blockImgs[index],
        blockLeft,
        y,
        BLOCK_IMG_WIDTH,
        BLOCK_HEIGHT
      );
    }

    if (this.iconType !== IconType.NONE && this.showIcon) {
      this.drawIcon(y - ICONSIZE);
    }
  }

  drawIcon(y) {
    if (this.iconType === IconType.NONE) return;

    const index = this.iconType;
    imageMode(CORNER);
    image(
      game.doodleJump.icons[index],
      this.iconX,
      y,
      ICONSIZE,
      ICONSIZE
    );
  }
}
