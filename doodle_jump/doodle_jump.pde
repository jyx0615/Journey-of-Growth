void setup() {
  size(460, 800);
  surface.setLocation(500, 100);
  blocks = randomGenBlocks();
  loadSubjectImages();
  loadBlocks();
  loadRoleImages();
}

Block[] randomGenBlocks() {
  Block[] Blocks = new Block[MAX_LEVEL * 2 + 1];
  for (int level = 0; level < MAX_LEVEL; level ++) {
    int blockLeft = int(random(40, 120));
    int blockCount = int(random(2, 4));
    Blocks[2 * level] = new Block(blockLeft, level, blockCount);
    
    int blockLeft2 = blockLeft + blockCount * BLOCK_IMG_WIDTH + int(random(40, 120));
    int blockCount2 = int(random(1, 4));
    Blocks[2 * level + 1] = new Block(blockLeft2, level, blockCount2);
  }
  
  Blocks[2 * MAX_LEVEL] = new Block(0, MAX_LEVEL, int(width/BLOCK_IMG_WIDTH) + 1);
  return Blocks;
}

void drawBlock(Block block, int y){
  noStroke();
  if(block.type == 0 || blockImgs[block.type - 1] == null) {
    fill(COLORS[block.type]);
    rect(block.left, y, block.blockCount * BLOCK_IMG_WIDTH, BLOCK_HEIGHT, 40);
  } else {
    for (int i = 0; i < block.blockCount; i++) {
      int blockLeft = block.left + BLOCK_IMG_WIDTH * i;
      image(blockImgs[block.type - 1], blockLeft, y, BLOCK_IMG_WIDTH, BLOCK_HEIGHT);
    }
    
  }

  // draw the icon if the type is not 0
  if(block.type != 0 && block.showIcon) {
    drawIcon(block.type, block.iconX, y - iconSize, iconSize);
  }
}

boolean hitBottomCheck() {
  for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT); i++) {
    int blockBottom = canva_offset + (blocks[i].level - base - 1) * LAYER_HEIGHT + BLOCK_HEIGHT;
    int blockLeft = blocks[i].left;
    int blockRight = blocks[i].left + blocks[i].blockCount * BLOCK_IMG_WIDTH;
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
    int blockRight = blocks[i].left + blocks[i].blockCount * BLOCK_IMG_WIDTH;
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
    if(blocks[i].type == 0 || !blocks[i].showIcon)
      continue;
    int iconY = canva_offset + (blocks[i].level - base - 1) * LAYER_HEIGHT - iconSize;
    if(curX + ROLE_WIDTH/2 > blocks[i].iconX && curX + ROLE_WIDTH/2 < blocks[i].iconX + iconSize) {
      if(curY + ROLE_HEIGHT >= iconY && curY + ROLE_HEIGHT <= iconY + iconSize){
        blocks[i].showIcon = false;
        println("撿到了 icon，type 為：" + blocks[i].type);
      }
    }
  }
  return false;
}

void draw() {
  background(#6CE378);
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
    if(!canva_moving_down && curY < MOVE_CANVA_THRESHOLD && base > 0){
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
  drawRole();

  // bottom section
  fill(0);
  rect(0, 600, width, height - 600);
}

void keyPressed() {
  if(key == ' ' && cur_jump_count < MAX_JUMP_COUNT) {
    jump = true;
    curV = JUMP_V0;
    cur_jump_count += 1;
  }
  if(key == CODED) {
    if(keyCode == LEFT){
      faceRight = false;
      actionIndex = (actionIndex + 1) % ROLE_ACTION_COUNT;
      if(curX >= 20)
        curX -= 20;
    } else if(keyCode == RIGHT){
      faceRight = true;
      actionIndex = (actionIndex + 1) % ROLE_ACTION_COUNT;
      if(curX <= width - 20 - ROLE_WIDTH)
        curX += 20;
    }
  }
}
