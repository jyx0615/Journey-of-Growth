import ddf.minim.*;

void setup() {
  size(460, 800);
  surface.setLocation(500, 100);
  // set some constants
  submitX = width/2;
  questionX = width/2;
  answerX = width/2;
  restartX = width/2;

  doodleJump = new DoodleJump();
  TCFont = createFont("Iansui-Regular", 15);
}

void draw() {
  doodleJump.draw();
}

void keyPressed() {
  if(doodleJump.gameOver) {
    if(key == ENTER || key == RETURN) {
      doodleJump.reset();
    }
  } else if(doodleJump.status == Status.QUIZ && doodleJump.quiz.exit_counter == 0) {
    doodleJump.quiz.updateAnserByKeyPress();
  } else {
    doodleJump.role.updateByKeyPress();
  }
}

void mousePressed() {
  if(doodleJump.status == Status.QUIZ) {
     doodleJump.quiz.updateByMousePress();
  } else if(doodleJump.gameOver) {
    if(mouseX > restartX - restartWidth/2 && mouseX < restartX + restartWidth/2 && mouseY > restartY - restartHeight/2 && mouseY < restartY + restartHeight/2) {
      doodleJump.reset();
    }
  }
}
