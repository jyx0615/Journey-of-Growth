enum MihoyoState {
    OPENING,
    MORNING,
    SHOP,
    WIN,
    LOSE
}

class Mihoyo {
    MihoyoState state = MihoyoState.OPENING;
    int credit = 0;             // 學分
    int space_CD = 0;            // space冷卻
    int level = 1;               // 商店購買次數
    int t = 0, seconds;          // 計時
    int career;                  // 職業        文理音藝體 0 1 2 3 4
    int temp = 0;                // 商店防誤觸計時

    PImage worker, jobScene, timer, backgroundImg;
    Player player;
    int workerX, workerY, workerWidth, workerHeight, textX;
    color textColor, textBgColor;
    String jobTitle;
    String[] m_name, ability;
    WeaponBase currentWeapon;

    Mihoyo(int careerIn) {
        timer = loadImage("pic/timer.png");
        backgroundImg = loadImage("pic/background.jpg");
        player = new Player(new PVector(0, 0), new PVector(0, 0), 100, 10, careerIn);
        career = careerIn;
        worker = loadImage("job_data/worker_" + filenames[career] + ".png");
        jobScene = loadImage("job_data/scene_" + filenames[career] + ".png");
        ability = loadStrings("texts/weapon_descriptions/" + filenames[career] + ".txt");
        workerX = workerXs[career];
        workerY = workerYs[career];
        workerWidth = workerWidths[career];
        workerHeight = workerHeights[career];
        textColor = textColors[career];
        textBgColor = textBgColors[career];
        textX = textXs[career];
        jobTitle = jobTitles[career];
        m_name = m_names[career];

        switch (career) {
            case 0: currentWeapon = new Weapon0(this); break;
            case 1: currentWeapon = new Weapon1(this); break;
            case 2: currentWeapon = new Weapon2(this); break;
            case 3: currentWeapon = new Weapon3(this); break;
            case 4: currentWeapon = new Weapon4(this); break;
        }
    }

    void draw() {
        if (player.HP <= 0) {
            state = MihoyoState.LOSE;
        }
        if (credit >= WIN_CREDIT) {
            state = MihoyoState.WIN;
        }

        switch (state) {
            case OPENING:
                open();
                break;
            case MORNING:
                morning();
                break;
            case SHOP:
                temp += 1;
                shop();
                break;
            case WIN:
                win();
                break;
            case LOSE:
                lose();
                break;
        }
    }

    //  timer and credit header
    void header() {
        textAlign(LEFT);
        textSize(35);
        text("學分 " + credit, 50, 50);
        String[] career_name = {"文學院", "理學院", "音樂學院", "藝術學院", "體育學院"};
        text(career_name[career], width - 150, 50);
        if (state == MihoyoState.MORNING) {
            RunTimer();
        }
        
    }

    void open() {
        background(0);
        fill(255);
        textAlign(CENTER);
        textSize(50); 
        text("遊戲介紹", width/2, height/2 - 100);
        
        textSize(30);
        text("遊玩方式", width/2, height/2);
        text("使用wasd進行上下左右移動，並且玩家會保持在畫面中心。", width/2, height/2 + 50);
        text("你可以使用滑鼠來攻擊", width/2, height/2 + 100);
        text("獲得足夠的分數(50分)時，會進入到商店畫面。", width/2, height/2 + 150);
        text("死亡或是學分夠了，即結束遊戲。", width/2, height/2 + 200);
        text("按下 Enter 開始遊戲", width/2, height/2 + 300);

        header();
        if (key == ENTER) 
            state = MihoyoState.MORNING;
    }

    void morning() {
        background(200);

        // enter shop condition check
        if (credit >= 50) {
            boolean allSkillsUnlocked = true;
            for (int i = 0; i < currentWeapon.skill.length; i++) {
                if (!currentWeapon.skill[i]) {
                    allSkillsUnlocked = false;
                    break;
                }
            }
            if(!allSkillsUnlocked)
                state = MihoyoState.SHOP;
        }

        imageMode(CENTER);
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                image(backgroundImg, 
                            width * (i - 1.5) + (-player.XY.x % width),
                            height * (j - 1.5) + (-player.XY.y % height),
                            width, height);

        pushMatrix();
        translate(-player.XY.x, -player.XY.y);

        player.XY.add(player.speed);
        currentWeapon.draw(player, t);
        DrawMonsters(this);

        if (t % 10 == 0) {
            float randomangle = random(0, 2 * PI);
            int randomname = int(random(0, 3));
            monsters.add(new Monster(
                new PVector(player.XY.x + cos(randomangle) * random(width, width*2),
                            player.XY.y + sin(randomangle) * random(height, height*2)),
                            int(random(10, 100)), 10, random(1, 7.5), 0, m_name[randomname]));
        }
        popMatrix();

        player.draw();
        text(level, 400, 300);

        header();
    }

    void shop() {
        background(100);
        rectMode(CENTER); 
        fill(255); 
        stroke(0);
        for (int i = -2; i <= 2; i++)
            rect(width/2, height/2 + i*100, width - 100, 100);

        textAlign(CENTER); 
        textSize(20); 
        fill(0);
        for (int i = 0; i < 5; i++) {
            fill(0);
            text(ability[i], width/2, height/2 + 200 - i*100);
            if (currentWeapon.skill[i]) {
                fill(100, 0, 0); 
                text("已解鎖", width/2, height/2 + 200 - i*100 + 25); 
                fill(0);
            }
        }

        if (mousePressed && temp >= 60) {
            if (!currentWeapon.skill[0]   && mouseY > height/2 + 150 && mouseY < height/2 + 250) unlock(0);
            if (!currentWeapon.skill[1]   && mouseY > height/2 +  50 && mouseY < height/2 + 150) unlock(1);
            if (!currentWeapon.skill[2]   && mouseY > height/2 -  50 && mouseY < height/2 +  50) unlock(2);
            if (!currentWeapon.skill[3]   && mouseY > height/2 - 150 && mouseY < height/2 -  50) unlock(3);
            if (!currentWeapon.skill[4]   && mouseY > height/2 - 250 && mouseY < height/2 - 150) unlock(4);
        }

        header();
    }

    void win() {
        // 繪製背景場景
        imageMode(CENTER);
        image(jobScene, 400, 400, 800, 800);
        
        // 繪製人物
        image(worker, workerX, workerY, workerWidth, workerHeight);
        
        // 繪製文字
        textFont(TCFontBold);
        textAlign(CENTER, CENTER);
        textSize(36);
        fill(textBgColor);
        text(congratsText, textX, textY);
        
        textSize(64);
        fill(textColor);
        text(jobTitle, textX, titleY);
    }

    void lose() {
        background(0);
        fill(255, 0, 0);
        textAlign(CENTER);
        textSize(50); text("你沒畢業", width/2, height/2 - 100);
        textSize(30); text("獲得學分: " + credit, width/2, height/2);
    }

    void RunTimer() {
        t += 1;
        if (t >= int(frameRate)) { 
            seconds += 1; 
            t = 0; 
        }
        image(timer, width/2 - 25, 25, 50, 50);
        textAlign(LEFT); 
        textSize(50); 
        text(seconds, width/2, 50);
    }

    void unlock(int index) {
        currentWeapon.skill[index] = true;
        state = MihoyoState.MORNING;
        credit -= WEAPON_COST;
        level += 1;
        temp = 0;
    }

    void keyPressed() {
        player.keyPressed();
    }

    void keyReleased() {
        player.keyReleased();
    }

    void mousePressed() {
        if(state == MihoyoState.MORNING) 
            currentWeapon.mousePressed();
    }
}
