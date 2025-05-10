enum Status {
  START,
  PLAYING,
  GAMEOVER,
  QUIZ,
  ABOUT_US,
  HELP
}

class DoodleJump {
    Role role;
    Quiz quiz;
    Block[] blocks;
    Status status;
    int base;
    boolean gameOver, end, canvaMoving;
    int fireTimer, freezeTimer, canvaOffset;
    AudioPlayer correctSound, wrongSound, jumpSound, pickSound, gameOverSound;
    int []scores = new int[5];
    PImage[] blockImgs = new PImage[8];
    PImage[] icons = new PImage[8];
    PImage door;
    Question[] questions;

    DoodleJump() {
        role = new Role();
        quiz = new Quiz();
        blocks = randomGenBlocks();
        door = loadImage("icons/door.png");
        loadSounds();
        loadBlocks();
        loadSubjectImages();
        loadStartPageImages();
        loadQuestions();
        reset();
    }

    void loadSounds() {
        correctSound = minim.loadFile("sounds/correct.mp3");
        wrongSound = minim.loadFile("sounds/wrong.mp3");
        jumpSound = minim.loadFile("sounds/jump.mp3");
        pickSound = minim.loadFile("sounds/pick.mp3");
        gameOverSound = minim.loadFile("sounds/gameover.mp3");
    }

    void loadSubjectImages(){
        icons[0] = loadImage("subjects/literacture.png");
        icons[1] = loadImage("subjects/math.png");
        icons[2] = loadImage("subjects/music.png");
        icons[3] = loadImage("subjects/art.png");
        icons[4] = loadImage("subjects/sports.png");
        icons[5] = loadImage("subjects/certificate.png");
        icons[6] = loadImage("subjects/clock.png");
        icons[7] = loadImage("subjects/quiz.png");
    }
    
    void loadStartPageImages() {
      startBackground = loadImage("background/startBackground.png");
      startButtonImg = loadImage("icons/start.png");
      aboutUsButtonImg = loadImage("icons/aboutUs.png");
      helpButtonImg = loadImage("icons/help.png");
      playerImg = loadImage("icons/player.png");
    }

    void loadQuestions() {
        JSONArray quizData = loadJSONArray("quiz.json");
        questions = new Question[quizData.size()];

        for (int i = 0; i < quizData.size(); i++) {
            questions[i] = new Question(quizData.getJSONObject(i));
        }
    }

    void loadBlocks() {
        blockImgs[0] = loadImage("blocks/white.png");
        blockImgs[1] = loadImage("blocks/yellow.png");
        blockImgs[2] = loadImage("blocks/purple.png");
        blockImgs[3] = loadImage("blocks/red.png");
        blockImgs[4] = loadImage("blocks/green.png");
        blockImgs[5] = loadImage("blocks/black.png");
        blockImgs[6] = loadImage("blocks/black.png");
        blockImgs[7] = loadImage("blocks/black.png");
    }

    void reset() {
        role.reset();
        quiz.reset();
        base = MAX_LEVEL - SHOW_LEVEL_COUNT;
        gameOver = false;
        status = Status.START;
        end = false;
        fireTimer = 0;
        freezeTimer = 0;
        canvaMoving = false;
        canvaOffset = 200;
        for(int i = 0; i < scores.length; i ++)
            scores[i] = 0;
    }
    
    void checkStartPageButtons() {
      if (showAboutUs || showHelp) {
        showAboutUs = false;
        showHelp = false;
        return;
      }
      
      // check start button
      int startX = width/3;
      int startY = height/6*5;
      if (mouseX > startX - buttonW/2 && mouseX < startX + buttonW/2 && 
          mouseY > startY - buttonH/2 && mouseY < startY + buttonH/2) {
        doodleJump.status = Status.PLAYING;
        return;
      }
      
      // check help button
      int helpX = width/11*7;
      int helpY = height/2;
      if (mouseX > helpX - buttonW/2 && mouseX < helpX + buttonW/2 && 
          mouseY > helpY - buttonH/2 && mouseY < helpY + buttonH/2) {
        showHelp = true;
        return;
      }
      
      // check aboutUs button
      int aboutX = width/11*9;
      int aboutY = height/6*4;
      if (mouseX > aboutX - (buttonW+10)/2 && mouseX < aboutX + (buttonW+10)/2 && 
          mouseY > aboutY - buttonH/2 && mouseY < aboutY + buttonH/2) {
        showAboutUs = true;
        return;
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

    boolean hitBottomCheck() {
        for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT); i++) {
            int blockBottom = canvaOffset + (blocks[i].level - base - 1) * LAYER_HEIGHT + BLOCK_HEIGHT;
            int blockLeft = blocks[i].left;
            int blockRight = blocks[i].left + blocks[i].blockCount * BLOCK_IMG_WIDTH;
            if(role.curX < blockRight && role.curX + ROLE_WIDTH > blockLeft) {
            if(role.curY >= blockBottom && role.curY + role.curV <= blockBottom)
                return true;
            }
        }
        return false;
    }

    boolean stayTopCheck() {
        for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT) + 1; i++) {
            int blockTop = canvaOffset + (blocks[i].level - base - 1) * LAYER_HEIGHT;
            int blockLeft = blocks[i].left;
            int blockRight = blocks[i].left + blocks[i].blockCount * BLOCK_IMG_WIDTH;
            if(role.curX < blockRight && role.curX + ROLE_WIDTH > blockLeft) {
                if(role.curY + ROLE_HEIGHT <= blockTop && role.curY + ROLE_HEIGHT + role.curV >= blockTop){
                    role.curY = blockTop - ROLE_HEIGHT;
                    return true;
                }
            }
        }
        return false;
    }

    boolean hitIconCheck() {
        for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT); i++) {
            IconType type = blocks[i].iconType;
            if(type == IconType.NONE || !blocks[i].showIcon)
            continue;
            int iconY = canvaOffset + (blocks[i].level - base - 1) * LAYER_HEIGHT - ICONSIZE;
            if(role.curX + ROLE_WIDTH/2 > blocks[i].iconX && role.curX + ROLE_WIDTH/2 < blocks[i].iconX + ICONSIZE) {
                if(role.curY + ROLE_HEIGHT >= iconY && role.curY + ROLE_HEIGHT <= iconY + ICONSIZE){
                    blocks[i].showIcon = false;
                    switch (type) {
                        case CERTIFICATE:
                            println("撿到了 certificate，啟動火焰模式");
                            fireTimer = FIRE_DURATION;
                            pickSound.rewind();
                            pickSound.play();
                            break;
                        
                        case CLOCK:
                            println("撿到了 clock，角色凍結");
                            freezeTimer = FREEZE_DURATION;
                            break;

                        case QUIZ:
                            println("撿到了 icon，type 為：" + blocks[i].iconType);
                            quiz.set(questions[int(random(questions.length))]);
                            quiz.show_quiz_content = false;
                            status = Status.QUIZ;
                            break;
                        
                        default:
                            int index = type.ordinal();
                            //when onfire, score add 10, else add 1
                            if(fireTimer > 0)
                                scores[index] += 10;
                            else
                                scores[index] += 1;
                            pickSound.rewind();
                            pickSound.play();
                            
                            // get quiz by subject type
                            ArrayList<Integer> matchingQuizzes = new ArrayList<Integer>();
                            for (int q = 0; q < questions.length; q++)
                                if (questions[q].subject == blocks[i].subject)
                                    matchingQuizzes.add(q);
                            
                            // get random quiz
                            if (matchingQuizzes.size() > 0) {
                                int questionIndex = matchingQuizzes.get(int(random(matchingQuizzes.size())));
                                quiz.set(questions[questionIndex]);
                                quiz.show_quiz_content = false;
                                status = Status.QUIZ;
                            }
                            break;
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

    void drawResultPage() {
        background(#AACCFF);
        textFont(TCFont);
        
        // 計算最高分的科目
        int maxScore = -1;
        int maxIndex = -1;
        for (int i = 0; i < scores.length; i++) {
            if (scores[i] > maxScore) {
                maxScore = scores[i];
                maxIndex = i;
            }
        }
  
        // 繪製結果頁面
        fill(0);
        textSize(40);
        textAlign(CENTER, CENTER);
        text("遊戲結束", width/2, height/4);
        
        textSize(30);
        text("你的最高分科目：" + subjects[maxIndex], width/2, height/2 - 50);
        text("得分：" + maxScore, width/2, height/2);
        text("恭喜你分配到", width/2, height/2 + 50);
        
        textSize(50);
        fill(#FF5733);
        text(academics[maxIndex], width/2, height/2 + 120);
    }

    void drawBottomSection() {
        rectMode(CORNER);
        fill(0);
        rect(0, 600, width, height - 600);

        fill(255);
        textAlign(CORNER, CORNER);
        textSize(20);
        // scores
        for(int i = 0; i < scores.length; i ++){
            text(subjects[i] + ": " + scores[i], 20, 620 + i * 30);
        }
        
        // show fire mode time
        if(fireTimer > 0) {
            fireTimer --;
            fill(#FF5733);
            text("火焰模式: " + fireTimer / 60 + "秒", 250, 620);
        }
        
        // show frozen mode time
        if(freezeTimer > 0) {
            freezeTimer --;
            fill(#3357FF);
            text("凍結: " + freezeTimer / 60 + "秒", 250, 650);
        }
    }
 
    void draw() {
        if (status == Status.START) {
            drawStartPage();
        }else{
            background(#6CE378);
            textFont(TCFont);
        
            if(gameOver) {
                drawGameOver();
                return;
            }
        
            if(end) {
                drawResultPage();
                return;
            }

            // game over
            if (!gameOver && base < MAX_LEVEL - SHOW_LEVEL_COUNT && role.curY > 600) {
                gameOverSound.rewind();
                gameOverSound.play();
                gameOver = true;
                return;
            }

            if(canvaOffset < 200){
                canvaOffset += CANVA_SPEED;
                role.curY += CANVA_SPEED;
            } else {
                canvaMoving = false;
            }
            
            // roles can only move when not frozen
            if (freezeTimer == 0) {
                if(stayTopCheck()) {
                    role.jump = false;
                    role.curV = 0;
                    role.curJumpCount = 0;
                    // move the canva
                    if(!canvaMoving && role.curY < MOVE_CANVA_THRESHOLD && base > 0){
                        base -= 1;
                        canvaOffset -= LAYER_HEIGHT;
                        canvaMoving = true;
                    }
                } else {
                    if(hitBottomCheck())
                        role.curV = -role.curV;
                    role.curY += role.curV;
                    role.curV += ACCELERATE;
                }
                hitIconCheck();
            }
    
            // draw the blocks
            for (int i = 2 * base; i < 2 * (base + SHOW_LEVEL_COUNT); i++) {
                int blockY = canvaOffset + (blocks[i].level - base - 1) * LAYER_HEIGHT;
                blocks[i].draw(blockY);
            }
        
            // draw the door
            if (base == 0) {
                Block topRightBlock = blocks[1];
                int doorX = topRightBlock.left + topRightBlock.blockCount * BLOCK_IMG_WIDTH - 50;  // 門放在右邊平台的右側
                int doorY = canvaOffset - LAYER_HEIGHT - 60;
                image(door, doorX, doorY, 50, 60);
                // touch door or not
                if (role.curX + ROLE_WIDTH > doorX && role.curX < doorX + 50 && role.curY + ROLE_HEIGHT > doorY && role.curY < doorY + 60) {
                    end = true;
                }
            }
    
            // draw the role
            role.draw();
    
            // bottom section
            drawBottomSection();
            
            if(status == Status.QUIZ) {
                quiz.draw();
                }
        }
    }
}
