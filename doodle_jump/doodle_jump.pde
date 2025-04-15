void setup() {
  size(600, 800);
  blocks = randomGenBlocks(MAX_LEVEL);
  loadInImage();
}

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

Block[] randomGenBlocks(int maxLevel) {
  Block[] Blocks = new Block[maxLevel * 2 + 1];
  for (int level = 0; level < maxLevel; level ++) {
    int blockLeft = int(random(0, 100));
    int blockWidth = int(random(100, 250));
    int type = getRandomType();
    Blocks[2 * level] = new Block(blockLeft, level, blockWidth, type);
    
    if (type != 0) {
      int iconX = blockLeft + (blockWidth % 10 * 10);
      int iconY = (level) * LAYER_HEIGHT - (iconSize * 7)/2;
      icons.add(new Icon(iconX, iconY, type));
    }

    int blockLeft2 = blockLeft + blockWidth + int(random(50, 200));
    int blockWidth2 = int(random(50, 250));
    int type2 = getRandomType();
    Blocks[2 * level + 1] = new Block(blockLeft2, level, blockWidth2, type2);
    
    if (type2 != 0) {
      int iconX2 = blockLeft2 + (blockWidth2 % 10 * 10);
      int iconY2 = (level) * LAYER_HEIGHT - (iconSize * 7)/2;
      icons.add(new Icon(iconX2, iconY2, type2));
    }
  }
  
  Blocks[2 * maxLevel] = new Block(0, maxLevel, width, 0);
  return Blocks;
}

void drawBlock(Block block, int y){
  noStroke();
  fill(COLORS[block.type]);
  rect(block.left, y, block.blockWidth, BLOCK_HEIGHT, 40);
  // add the icon if the type is not 0
  /*
  if(block.type != 0){
    int iconX = block.left + block.blockWidth % 10 * 10;
    rect(iconX, y-iconSize, iconSize, iconSize, 3);
  }
  */
}

boolean hitBottomCheck() {
  for (int i = 2 * base; i < blocks.length; i++) {
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
  for (int i = 2 * base; i < blocks.length; i++) {
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
  
  // draw the blocks
  for (int i = 2 * base; i < blocks.length; i++) {
    int blockY = canva_offset + (blocks[i].level - base - 1) * LAYER_HEIGHT;
    drawBlock(blocks[i], blockY);
  }
  // draw icons
  for (Icon icon : icons) {
    if (icon.active){
    int iconY = icon.worldY + canva_offset - base * LAYER_HEIGHT;
    drawIcon(icon.type, icon.imgX, iconY, iconSize);
    }
  }

// check collision
  for (Icon icon : icons) {
    if (!icon.active) continue;
    int iconY = icon.worldY + canva_offset - base * LAYER_HEIGHT;
    boolean xOverlap = curX + ROLE_WIDTH > icon.imgX && curX < icon.imgX + iconSize;
    boolean yOverlap = curY + ROLE_HEIGHT > iconY && curY < iconY + iconSize;

    if (xOverlap && yOverlap) {
      icon.active = false; 
      println("撿到了 icon，type 為：" + icon.type);
      // 可以在這裡加特效
    }
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
