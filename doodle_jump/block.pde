class Block {
  int left, level, blockWidth, type, iconX;
  boolean showIcon;

  int getRandomType() {
    float tmp = random(1);
    int type = 0;
    if(tmp > 0.9){  // incident
    
    } else if (tmp > 0.4){  // subject
      type = int(random(1, 5.1));
      println(type, random(1, 5.1));
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

  Block(int blockLeft, int blockLevel, int blockWidthIn) {
    left = blockLeft;
    level = blockLevel;
    blockWidth = blockWidthIn;
    if (blockLevel == MAX_LEVEL)
        type = 0;
    else
        type = getRandomType();
    iconX = getRandomIconX();
    showIcon = true;
  }
}