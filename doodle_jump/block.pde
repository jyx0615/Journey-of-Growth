enum Subject {
  LITERATURE,
  SCIENCE,
  MUSIC,
  ART,
  SPORTS,
  NONE
}

enum IconType {
  LITERATURE,
  SCIENCE,
  MUSIC,
  ART,
  SPORTS,
  CERTIFICATE,
  CLOCK,
  QUIZ,
  NONE;

  Subject toSubject() {
    switch (this) {
      case LITERATURE: return Subject.LITERATURE;
      case SCIENCE: return Subject.SCIENCE;
      case MUSIC: return Subject.MUSIC;
      case ART: return Subject.ART;
      case SPORTS: return Subject.SPORTS;
      default: return Subject.NONE;
    }
  }
}

IconType[] iconTypes = IconType.values();

class Block {
  int left, level, iconX, blockCount;
  boolean showIcon;
  IconType iconType;
  Subject subject;

  Block(int blockLeft, int blockLevel, int blockCountIn) {
    left = blockLeft;
    level = blockLevel;
    blockCount = blockCountIn;
    if (blockLevel == MAX_LEVEL)
      iconType = IconType.NONE;
    else
      iconType = getRandomIconType();
    iconX = getRandomIconX();
    showIcon = true;
  }

  IconType getRandomIconType() {
    int index = 0;
    if(random(1) > 0.8) {
      index = int(random(5, 8));
    } else {
      index = int(random(0, 5));
      subject = iconTypes[index].toSubject();
    }
    return iconTypes[index];
  }

  int getRandomIconX() {
    int iconX = left + (blockCount * BLOCK_IMG_WIDTH % 10 * 10);
    iconX = min(iconX, left + blockCount * BLOCK_IMG_WIDTH - ICONSIZE);
    return iconX;
  }

  void draw(int y) {
    for (int i = 0; i < blockCount; i++) {
      int blockLeft = left + BLOCK_IMG_WIDTH * i;
      int index = iconType.ordinal();
      image(doodleJump.blockImgs[index], blockLeft, y, BLOCK_IMG_WIDTH, BLOCK_HEIGHT);
    }

    if(iconType != IconType.NONE && showIcon)
      drawIcon(y - ICONSIZE);
  }

  void drawIcon(int y) {
    int index = iconType.ordinal();
    if (iconType == IconType.NONE) {
      return;
    } else if (index >= 5) {
      imageMode(CORNER);
      image(doodleJump.icons[index], iconX, y, ICONSIZE, ICONSIZE);
    } else {
      imageMode(CORNER);
      image(doodleJump.icons[index], iconX, y, ICONSIZE, ICONSIZE);
    }
  }
}
