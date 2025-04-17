class Block {
  int left, level, type, iconX, blockCount;
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
    int iconX = left + (blockCount * BLOCK_IMG_WIDTH % 10 * 10);
    iconX = min(iconX, left + blockCount * BLOCK_IMG_WIDTH - iconSize);
    return iconX;
  }

  Block(int blockLeft, int blockLevel, int blockCountIn) {
    left = blockLeft;
    level = blockLevel;
    blockCount = blockCountIn;
    if (blockLevel == MAX_LEVEL)
        type = 0;
    else
        type = getRandomType();
    iconX = getRandomIconX();
    showIcon = true;
  }
}

void loadBlocks() {
  blockImgs[0] = loadImage("blocks/white.png");
  blockImgs[1] = loadImage("blocks/yellow.png");
  blockImgs[2] = loadImage("blocks/purple.png");
  blockImgs[3] = loadImage("blocks/red.png");
  blockImgs[4] = loadImage("blocks/white.png");
}