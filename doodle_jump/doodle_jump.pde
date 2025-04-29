import ddf.minim.*;

void setup() {
  size(460, 800);
  surface.setLocation(500, 100);
  // set some constants
  submitX = width/2;
  questionX = width/2;
  answerX = width/2;
  restartX = width/2;

  loadSounds();
  loadSubjectImages();
  loadBlocks();
  loadRoleImages();
  loadBackgroundImage();
  readQuiz();

  startGame();
}

void startGame() {
  blocks = randomGenBlocks();
  curX = 300;
  curY = 539;
  curV = 0;
  base = MAX_LEVEL - SHOW_LEVEL_COUNT;
  gameOver = false;
  quiz_mode = false;
  // clear the scores
  for(int i = 0; i < scores.length; i ++){
    scores[i] = 0;
  }
}

Block[] randomGenBlocks() {
  Block[] Blocks = new Block[MAX_LEVEL * 2 + 1];
  for (int level = 0; level < MAX_LEVEL; level ++) {
    int blockLeft = int(random(40, 120));
    int blockCount = int(random(2, 4));
    Blocks[2 * level] = new Block(blockLeft, level, blockCount);
    
    int blockLeft2 = blockLeft + blockCount * BLOCK_IMG_WIDTH + int(random(50, 120));
    int blockCount2 = int(random(1, 4));
    Blocks[2 * level + 1] = new Block(blockLeft2, level, blockCount2);
  }
  
  Blocks[2 * MAX_LEVEL] = new Block(0, MAX_LEVEL, int(width/BLOCK_IMG_WIDTH) + 1);
  return Blocks;
}

void drawBlock(Block block, int y){
  noStroke();
  if(block.type == 0 || blockImgs[block.type - 1] == null) {
    //fill(COLORS[block.type]);
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
        if(blocks[i].type<6){
          scores[blocks[i].type - 1] += 1;
          println("撿到了 icon，type 為：" + blocks[i].type);
          pickSound.rewind();
          pickSound.play();
        }else if(blocks[i].type == 6){
          //certificate
          println("撿到了 icon，type 為：" + blocks[i].type);
        }else if(blocks[i].type == 7){
          // clock
          println("撿到了 icon，type 為：" + blocks[i].type);
        }else if(blocks[i].type == 8){
          //quiz
          // randomly select a quiz and show it
          println("撿到了 icon，type 為：" + blocks[i].type);
          questionIndex = int(random(quizzes.length));
          setQuiz(quizzes[questionIndex]);
          show_quiz_content = false;
          quiz_mode = true;
        }
      }
    }
  }
  return false;
}

void drawGameOver() {
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  textSize(50);
  text("Game Over", width/2, height/2);

  // restart button
  rectMode(CENTER);
  fill(0, 255, 0);
  rect(restartX, restartY, restartWidth, restartHeight, 20);
  fill(0);
  textSize(20);
  text("Restart", restartX, restartY);
}

void draw() {
  background(#6CE378);
  textFont(TCFont);
  
  if(gameOver) {
    drawGameOver();
    return;
  }

  // game over
  if (!gameOver && base < MAX_LEVEL - SHOW_LEVEL_COUNT && curY > 600) {
    gameOverSound.rewind();
    gameOverSound.play();
    gameOver = true;
    return;
  }

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
  rectMode(CORNER);
  fill(0);
  rect(0, 600, width, height - 600);

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(20);
  for(int i = 0; i < scores.length; i ++){
    text(subjects[i] + ": " + scores[i], 20, 620 + i * 30);
  }
  
  if(quiz_mode) {
    drawQuizSection();
  }
}

void keyPressed() {
  if(quiz_mode) {
    // input question
    if (type == 2) {
     if (key == BACKSPACE) {
       if (inputText.length() > 0) {
         inputText = inputText.substring(0, inputText.length() - 1);
       }
     } else if (key == ENTER || key == RETURN) {
       handleSubmit();
     } else if (key != CODED) {
       if (inputText.length() < inputMaxLength)
         inputText += key;
     }
    }
    // multiple choice question
    if(type == 1){
      if(key == '1' || key == '2' || key == '3' || key == '4') {
        int choice = int(key) - 49;
        if(choice == activateBtn) {
          activateBtn = -1;
        } else {
          activateBtn = choice;
        }
      }
      if (activateBtn != -1 && key == ENTER || key == RETURN)
       handleSubmit();
    } 
  } else {
    if(key == ' ' && cur_jump_count < MAX_JUMP_COUNT) {
      jump = true;
      curV = JUMP_V0;
      cur_jump_count += 1;
      jumpSound.rewind();
      jumpSound.play();
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
}

void mousePressed() {
  if(quiz_mode){
     // check if a choice button is clicked
     if (type == 1) {
       for (int i = 0; i < choices.length; i ++) {
         int startX = buttonX + buttonOffsetX * i;
         if(mouseX > startX && mouseX < startX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight){
           if(activateBtn == i)
             activateBtn = -1;
           else
             activateBtn = i;
         }
       }
     } 

     // check if the submit button is clicked
     if(mouseX > submitX - submitWidth/2 && mouseX < submitX + submitWidth/2 && mouseY > submitY - submitHeight/2 && mouseY < submitY + submitHeight/2)
       handleSubmit();
  } else if(gameOver) {
    if(mouseX > restartX - restartWidth/2 && mouseX < restartX + restartWidth/2 && mouseY > restartY - restartHeight/2 && mouseY < restartY + restartHeight/2) {
      startGame();
    }
  }
}
