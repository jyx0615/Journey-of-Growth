void setup() {
  size(600, 800);
  blocks = randomGenBlocks(MAX_LEVEL);
  loadInImage();
}


Block[] randomGenBlocks(int maxLevel) {
  Block[] Blocks = new Block[maxLevel * 2 + 1];
  for (int level = 0; level < maxLevel; level ++) {
    int blockLeft = int(random(0, 100));
    int blockWidth = int(random(100, 250));
    int iconX = blockLeft + (blockWidth % 10 * 10);
    iconX = constrain(iconX, 0, width - iconSize);
    Blocks[2 * level] = new Block(blockLeft, level, blockWidth, iconX);
    
    int blockLeft2 = blockLeft + blockWidth + int(random(50, 200));
    int blockWidth2 = int(random(50, 250));
    int iconX2 = blockLeft2 + (blockWidth2 % 10 * 10);
    Blocks[2 * level + 1] = new Block(blockLeft2, level, blockWidth2, iconX2);
    
  }
  
  Blocks[2 * maxLevel] = new Block(0, maxLevel, width, 0);
  return Blocks;
}

void drawBlock(Block block, int y){
  noStroke();
  fill(COLORS[block.type]);
  rect(block.left, y, block.blockWidth, BLOCK_HEIGHT, 40);
  // draw the icon if the type is not 0
  if(block.type != 0 && block.showIcon) {
    drawIcon(block.type, block.iconX, y - iconSize, iconSize);
  }
}

boolean hitBottomCheck() {
  for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT); i++) {
    int blockBottom = canva_offset + (blocks[i].level - base - 1) * LAYER_HEIGHT + BLOCK_HEIGHT;
    int blockLeft = blocks[i].left;
    int blockRight = blocks[i].left + blocks[i].blockWidth;
    if(curX < blockRight && curX + ROLE_WIDTH > blockLeft) {
      if(curY >= blockBottom && curY + curV <= blockBottom)
        return true;
    }
  }
  return false;
}

boolean stayTopCheck() {
  for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT) + 1; i++) {
    int blockTop = canva_offset + (blocks[i].level - base - 1) * LAYER_HEIGHT;
    int blockLeft = blocks[i].left;
    int blockRight = blocks[i].left + blocks[i].blockWidth;
    if(curX < blockRight && curX + ROLE_WIDTH > blockLeft) {
      if(curY + ROLE_HEIGHT <= blockTop && curY + ROLE_HEIGHT + curV >= blockTop){
        curY = blockTop - ROLE_HEIGHT;
        return true;
      }
    }
  }
  return false;
}

boolean hitIconCheck() {
  for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT); i++) {
    int iconY = canva_offset + (blocks[i].level - base - 1) * LAYER_HEIGHT - iconSize;
    if(curX + ROLE_WIDTH/2 > blocks[i].iconX && curX + ROLE_WIDTH/2 < blocks[i].iconX + iconSize) {
      if(curY + ROLE_HEIGHT >= iconY && curY + ROLE_HEIGHT <= iconY + iconSize)
        blocks[i].showIcon = false;
        println("撿到了 icon，type 為：" + blocks[i].type);
    }
  }
  return false;
}

void draw() {
  background(#4C0995);
  // move the canva
  //if(canva_moving_up) {
  //  canva_offset -= CANVA_UP_SPEED;
  //  curY = 700;
  //}
  if(canva_offset < 200){
    canva_offset += CANVA_SPEED;
    curY += CANVA_SPEED;
  } else {
    canva_moving_down = false;
  }
  if(stayTopCheck()) {
    jump = false;
    curV = 0;
    cur_jump_count = 0;
    // move the canva
    if(!canva_moving_down && curY < 500 && base > 0){
      base -= 1;
      canva_offset -= LAYER_HEIGHT;
      canva_moving_down = true;
    }
  } else {
    if(hitBottomCheck())
      curV = -curV;
    curY += curV;
    curV += ACCELERATE;
  }

  hitIconCheck();
  
  // draw the blocks
  for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT); i++) {
    int blockY = canva_offset + (blocks[i].level - base - 1) * LAYER_HEIGHT;
    drawBlock(blocks[i], blockY);
  }
  
  // draw the role
  fill(#09951A);
  rect(curX, curY, ROLE_WIDTH, ROLE_HEIGHT, 10);
}

void keyPressed() {
  if(key == ' ' && cur_jump_count < MAX_JUMP_COUNT) {
    jump = true;
    curV = JUMP_V0;
    cur_jump_count += 1;
  }
  if(key == CODED) {
    if(keyCode == LEFT){
      if(curX >= 20)
        curX -= 20;
    } else if(keyCode == RIGHT){
      if(curX <= width - 20 - ROLE_WIDTH)
        curX += 20;
    }
  }
}
