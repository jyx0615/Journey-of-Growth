class Block {
  int left, level, blockWidth, type, iconX;
  boolean showIcon;

  int getRandomType() {
    float tmp = random(1);
    int type = 0;
    if(tmp > 0.9){  // incident
    
    } else if (tmp > 0.6){  // subject
      tmp = random(1);
      type = int(tmp / 0.2) + 1;
    } else {
      type = 0;
    }
    return type;
  }

  int getRandomIconX() {
    int iconX = left + (blockWidth % 10 * 10);
    iconX = min(iconX, left + blockWidth - iconSize);
    return iconX;
  }

  Block(int blockLeft, int blockLevel, int blockWidthIn, int iconXIn) {
    left = blockLeft;
    level = blockLevel;
    blockWidth = blockWidthIn;
    type = getRandomType();
    iconX = getRandomIconX();
    showIcon = true;
  }
}