void setup() {
  size(600, 800);
  surface.setLocation(500, 10);
  blocks = randomGenBlocks(MAX_LEVEL);
}

int[][] randomGenBlocks(int maxLevel) {
  int[][] blocks = new int[maxLevel * 2 + 1][4];
  for (int level = 0; level < maxLevel; level ++) {
    int blockLeft = int(random(0, 100));
    int blockWidth = int(random(100, 250));
    blocks[2 * level][0] = blockLeft;
    blocks[2 * level][1] = level;
    blocks[2 * level][2] = blockWidth;
    float tmp = random(1);
    if(tmp > 0.9){  // incident
     
    } else if (tmp > 0.6){  // subject
      tmp = random(1);
      blocks[2 * level][3] = int(tmp / 0.2) + 1;
    } else {
      blocks[2 * level + 1][3] = 0;
    }
    
    int blockLeft2 = blockLeft + blockWidth + int(random(50, 200));
    int blockWidth2 = int(random(50, 250));
    blocks[2 * level + 1][0] = blockLeft2;
    blocks[2 * level + 1][1] = level;
    blocks[2 * level + 1][2] = blockWidth2;
    tmp = random(1);
    if(tmp > 0.9){  // incident
      
    } else if (tmp > 0.6){  // subject
      tmp = random(1);
      blocks[2 * level + 1][3] = int(tmp / 0.2) + 1;
    } else {
      blocks[2 * level + 1][3] = 0;
    }
  }
  blocks[2 * maxLevel][0] = 0;
  blocks[2 * maxLevel][1] = maxLevel;
  blocks[2 * maxLevel][2] = width;
  blocks[2 * maxLevel][3] = 0;
  return blocks;
}

void drawBlock(int x, int y, int blockWidth, int type){
  noStroke();
  fill(COLORS[type]);
  rect(x, y, blockWidth, BLOCK_HEIGHT, 40);
  // add the icon if the type is not 0
  if(type != 0){
    int iconX = x + blockWidth % 10 * 10;
    rect(iconX, y-20, 20, 20, 3);
  }
}

boolean hitBottomCheck() {
  for (int i = 2 * base; i < blocks.length; i++) {
    int blockBottom = canva_offset + (blocks[i][1] - base - 1) * LAYER_HEIGHT + BLOCK_HEIGHT;
    int blockLeft = blocks[i][0];
    int blockRight = blocks[i][0] + blocks[i][2];
    if(curX < blockRight && curX + ROLE_WIDTH > blockLeft) {
      if(curY >= blockBottom && curY + curV <= blockBottom)
        return true;
    }
  }
  return false;
}

boolean stayTopCheck() {
  for (int i = 2 * base; i < blocks.length; i++) {
    int blockTop = canva_offset + (blocks[i][1] - base - 1) * LAYER_HEIGHT;
    int blockLeft = blocks[i][0];
    int blockRight = blocks[i][0] + blocks[i][2];
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
  if(canva_offset < 200){
    canva_offset += CANVA_SPEED;
    curY += CANVA_SPEED;
  } else {
    is_moving = false;
  }
  if(stayTopCheck()) {
    jump = false;
    curV = 0;
    cur_jump_count = 0;
    // move the canva
    if(!is_moving && curY < 500 && base > 0){
      base -= 1;
      canva_offset -= LAYER_HEIGHT;
      is_moving = true;
    }
  } else {
    if(hitBottomCheck())
      curV = -curV;
    curY += curV;
    curV += ACCELERATE;
  }
   
  for (int i = 2 * base; i < blocks.length; i++) {
    int blockY = canva_offset + (blocks[i][1] - base - 1) * LAYER_HEIGHT;
    drawBlock(blocks[i][0], blockY, blocks[i][2], blocks[i][3]);
  }
  
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
