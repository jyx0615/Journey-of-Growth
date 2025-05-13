import ddf.minim.*;

enum Status {
  START,
  ABOUTUS,
  LEVEL1,
  LEVEL2,
}

Status gameStatus = Status.START;
AudioPlayer openningMusic, level1Music, level2Music;

void setup() {
  size(800, 800);
  surface.setLocation(500, 100);
  // set some constants
  submitX = width/2;
  questionX = width/2;
  answerX = width/2;
  restartX = width/2;

  // Load content from JSON
  JSONObject content = loadJSONObject("content.json");
  aboutUsContent = content.getString("aboutUsContent");

  doodleJump = new DoodleJump();
  TCFont = createFont("fonts/Iansui-Regular.ttf", 15);
  TCFontBold = createFont("fonts/NotoSansTC-Bold.ttf", 15);
  loadMusics();

  openningMusic.loop();
}

void loadMusics() {
  openningMusic = minim.loadFile("musics/openning.mp3");
  level1Music = minim.loadFile("musics/level1.mp3");
  level2Music = minim.loadFile("musics/level2.mp3");
}

void draw() {
  switch(gameStatus){
    case START:
      drawStartPage();
      break;
    case ABOUTUS:
      drawAboutUS();
      break;
    case LEVEL1:
      doodleJump.draw();
      break;
    case LEVEL2:
      break;
  }
}

void keyPressed() {
  if(gameStatus == Status.LEVEL1){
    doodleJump.keyPressedCheck();
  }
}

void mousePressed() {
  switch (gameStatus) {
    case START:
      int aboutX = width/11*9;
      int aboutY = height/6*4;
      if (mouseX > aboutX - (buttonW+10)/2 && mouseX < aboutX + (buttonW+10)/2 && 
          mouseY > aboutY - buttonH/2 && mouseY < aboutY + buttonH/2)
        gameStatus = Status.ABOUTUS;

      int startX = width/3;
      int startY = height/6*5;
      if (mouseX > startX - buttonW/2 && mouseX < startX + buttonW/2 && 
          mouseY > startY - buttonH/2 && mouseY < startY + buttonH/2) {
        gameStatus = Status.LEVEL1;
      }
      break;

    case ABOUTUS:
      gameStatus = Status.START;
      break;

    case LEVEL1:
      doodleJump.mousePressedCheck();
      break;
  }
  
}
