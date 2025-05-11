enum QuestionType {
  MULTIPLE_CHOICE,
  INPUT_QUESTION
}

class Question {
  QuestionType type;  // 1 => multiple choice, 2 => input question 
  String questionStr;
  String answerStr;
  int answerNum;
  Subject subject;
  String[] choices;

  Question(JSONObject obj) {
    String questionTypeStr = obj.getString("type");
    type = QuestionType.valueOf(questionTypeStr.toUpperCase());
    questionStr = obj.getString("question");

    if (type == QuestionType.MULTIPLE_CHOICE) {
      answerNum = obj.getInt("answer");
      JSONArray c = obj.getJSONArray("choices");
      choices = new String[c.size()];
      for (int i = 0; i < c.size(); i++) {
        choices[i] = c.getString(i);
      }
    } else if (type == QuestionType.INPUT_QUESTION) {
      answerStr = obj.getString("answer");
    }
    
    // get subject
    if (obj.hasKey("subject")) {
      String subjectStr = obj.getString("subject");
      subject = Subject.valueOf(subjectStr.toUpperCase());
    } else {
      subject = Subject.NONE;
    }
  }
}

class Quiz {
  String inputText;
  float transitionProgress;  // Progress of the transition (0 to 1)
  boolean show_quiz_content; // Flag to show quiz content
  float exit_counter;
  int correct = 0;           // 0: not answered, 1: wrong, 2: correct
  int activateBtn = -1;
  Question question;
  PImage quizBackground;
  PImage quizStartBackground;
  boolean pendingAddScore = false;
  int pendingScoreIndex = -1;
  int pendingScoreAmount = 0;

  Quiz() {
    loadBackgroundImage();
    reset();
  }

  void loadBackgroundImage() {
    quizStartBackground = loadImage("background/quiz_start.png");
    quizBackground = loadImage("background/quiz.png");
  }

  void reset() {
    transitionProgress = 0;    // Reset transition progress
    show_quiz_content = false; // Reset quiz content visibility
    correct = 0;               // Reset answer status
    inputText = "";
    activateBtn = -1;
    exit_counter = 0;
  }

  void set(Question q) {
    question = q;
  }

  void draw() {
    rectMode(CORNER);
    noStroke();
    fill(232, 220);
    rect(0, 0, width, height);

    // draw the quiz start background
    if (!show_quiz_content) {
      // Draw the quiz start background
      if (transitionProgress < 1) {
        transitionProgress += 0.02; // Adjust speed of transition
        float scale = min(map(transitionProgress, 0, 1, 0, 1), 1);
        float centerX = width / 2;
        float centerY = 360;
        float imgWidth = 400 * scale;
        float imgHeight = 600 * scale;

        imageMode(CENTER);
        image(quizStartBackground, centerX, centerY, imgWidth, imgHeight);
      } else {
        imageMode(CENTER);
        image(quizStartBackground, width/2, 360, 400, 600);
        show_quiz_content = true; // Show quiz content after transition
      } 
    } 
    // draw the quiz background with content
    else {
      imageMode(CENTER);
      image(quizBackground, width/2, 360, 400, 600);

      // Draw quiz content
      drawQuestion();
      if (question.type == QuestionType.MULTIPLE_CHOICE) {
        drawChoices();
        drawButtons();
      } else if (question.type == QuestionType.INPUT_QUESTION) {
        drawInputTitle();
        drawInput();
      }
      drawSubmitButton();
      drawResult();

      // Leave the quiz section
      if(exit_counter > 0) {
        exit_counter -= 0.015;
        if(exit_counter <= 0) {
          reset();
          doodleJump.status = Status.PLAYING;
        }
      }
    }
  }

  void updateAnserByKeyPress() {
    switch (question.type) {
      case INPUT_QUESTION:
        if (key == BACKSPACE && inputText.length() > 0) {
          inputText = inputText.substring(0, inputText.length() - 1);
        } else if (key == ENTER || key == RETURN) {
          handleSubmit();
        } else if (key != CODED && inputText.length() < INPUT_MAX_LENGTH) {
          inputText += key;
        } 
        break;

      case MULTIPLE_CHOICE:
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
        break;
    }
  }

  void updateByMousePress() {
    // check if a choice button is clicked
     if (question.type == QuestionType.MULTIPLE_CHOICE) {
       for (int i = 0; i < question.choices.length; i ++) {
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
  }

  void drawSubmitButton() {
    noStroke();
    rectMode(CENTER);
    fill(#3DB709);
    rect(submitX, submitY, submitWidth, submitHeight, 5);
    fill(#1D5D03);
    textAlign(CENTER, CENTER);
    text("submit", submitX, submitY);
  }

  void drawQuestion() {
    textAlign(CENTER, CENTER);
    textSize(18);
    fill(20);
    text(question.questionStr, questionX, questionY);
  }

  void drawInput() {
    rectMode(CORNER);
    textAlign(LEFT, CENTER);

    stroke(#2609E8);
    fill(240);
    rect(inputX, inputY, inputWidth, inputHeight, 5);

    fill(0);
    textSize(20);
    text(inputText, inputX + 10, inputY + inputHeight/2);
  }

  void drawInputTitle() {
    textSize(24);
    textAlign(LEFT, CENTER);
    text("Your answer", inputX - 30, inputY - 30);
  }

  void drawResult() {
    textAlign(CENTER, CENTER);
    if(correct == 1){
      fill(#E80911);
      text("wrong", answerX, answerY);
    } else if (correct == 2){
      fill(#3DB709);
      text("correct", answerX, answerY);
    }
  }

  void handleSubmit() {
    correct = 1;
    // multiple choice
    if (question.type == QuestionType.MULTIPLE_CHOICE && activateBtn == question.answerNum - 1)
      correct = 2;
    // input question
    else if (question.type == QuestionType.INPUT_QUESTION && inputText.equals(question.answerStr))
      correct = 2;
    if(correct == 2) {
      doodleJump.correctSound.rewind();
      doodleJump.correctSound.play();
      //add point only when correct
      if (pendingAddScore && pendingScoreIndex >= 0) {
        doodleJump.scores[pendingScoreIndex] += pendingScoreAmount;
      }
    } else {
      doodleJump.wrongSound.rewind();
      doodleJump.wrongSound.play();
    }
    exit_counter = 1;
    pendingAddScore = false;
    pendingScoreIndex = -1;
    pendingScoreAmount = 0;
  }

  void drawChoices() {
    textAlign(LEFT, CENTER);
    for (int i = 0; i < question.choices.length; i++) {
      text("(" + str(i+1) + ") " + question.choices[i], choicesX, choicesY + choicesOffsetY * i);
    }
  }

  void drawButtons() {
    rectMode(CORNER);
    textAlign(CENTER, CENTER);
    textSize(24);
    for (int i = 0; i < question.choices.length; i ++) {
      int startX = buttonX + buttonOffsetX * i;
      stroke(23, 92, 192);
      noFill();
      rect(startX, buttonY, buttonWidth, buttonHeight, 5);

      stroke(0);
      circle(startX + 50, buttonY + buttonHeight/2, 15);
      fill(0);

      text("(" + str(i+1) + ")", startX + 20, buttonY + buttonHeight/2);
      if(activateBtn == i) {
        fill(23, 92, 192);
        circle(startX + 50, buttonY + buttonHeight/2, 10);
      }
    }
  }
}
