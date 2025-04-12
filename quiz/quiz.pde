void setup() {
  size(600, 800);
  surface.setLocation(500, 100);
  readQuiz();
  //if (type == 1)
  //  generateMultipleChoice();
  //else if(type == 2)
  //  generateInputQuiz();
}

void readQuiz() {
  JSONArray quizData = loadJSONArray("quiz.json");
  quizzes = new Quiz[quizData.size()];

  for (int i = 0; i < quizData.size(); i++) {
    quizzes[i] = new Quiz(quizData.getJSONObject(i));
  }

  //// Example: show all loaded quizzes
  //for (int i = 0; i < quizzes.length; i++) {
  //  displayQuiz(quizzes[i], i + 1);
  //}
}

void displayQuiz(Quiz q) {
  question = q.question;
  type = q.type;
  if (q.type == 1){
    answerChoice = q.answerNum;
    choices = q.choices;
  } else if(q.type == 2) {
    answer = q.answerStr;
  }
}

void drawQuestion() {
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(20);
  text(question, questionX, questionY);
}

void drawChoices() {
  textAlign(LEFT, CENTER);
  for (int i = 0; i < choices.length; i++) {
    text("(" + str(i+1) + ") " + choices[i], choicesX, choicesY + choicesOffsetY * i);
  }
}

void drawButtons() {
  rectMode(CORNER);
  textAlign(CENTER, CENTER);
  textSize(24);
  for (int i = 0; i < choices.length; i ++) {
     int startX = buttonX + buttonOffsetX * i;
     stroke(23, 92, 192);
     noFill();
     rect(startX, buttonY, buttonWidth, buttonHeight, 5);
     stroke(0);
     circle(startX + 75, buttonY + buttonHeight/2, 15);
     fill(0);
     text("(" + str(i+1) + ")", startX + 30, buttonY + buttonHeight/2);
     if(activateBtn == i) {
       fill(23, 92, 192);
       circle(startX + 75, buttonY + buttonHeight/2, 10);
     }
  }
}

void drawInput() {
  rectMode(CORNER);
  textAlign(LEFT, CENTER);
  
  if (isActive) {
    stroke(#2609E8);
    fill(240);
  } else {
    stroke(0);
    fill(200);
  }
  rect(inputX, inputY, inputWidth, inputHeight, 5);

  fill(0);
  textSize(20);
  text(inputText, inputX + 10, inputY + inputHeight/2);
}

void drawInputTitle() {
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Your answer: ", inputX - 150, inputY + inputHeight/2);
}

void drawAnswer() {
  textAlign(CENTER, CENTER);
  if(correct == 1){
    fill(#E80911);
    text("wrong", answerX, answerY);
  } else if (correct == 2){
    fill(#3DB709);
    text("correct", answerX, answerY);
  }
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

void draw() {
  background(230);
  displayQuiz(quizzes[0]);
  drawQuestion();
  if (type == 1){    // mulitple choice
    drawChoices();
    drawButtons();
  }
  else if (type == 2) {  // input question
    drawInputTitle();
    drawInput();
  }
  drawSubmitButton();
  drawAnswer();
}

void mousePressed() {
   // check if a choice button is clicked
   if (type == 1) {
     for (int i = 0; i < choices.length; i ++) {
       int startX = buttonX + buttonOffsetX * i;
       println(mouseX, startX, startX + buttonWidth);
       println(mouseY, buttonY, buttonY + buttonHeight);
       if(mouseX > startX && mouseX < startX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight){
         if(activateBtn == i)
           activateBtn = -1;
         else
           activateBtn = i;
       }
     }
   } 
   // Check if the input box is activated
   else if (type == 2) {
     if (mouseX > inputX && mouseX < inputX + inputWidth && mouseY > inputY && mouseY < inputY + inputHeight) {
       isActive = true;
     } else {
       isActive = false;
     }
   }
   // check if the submit button is clicked
   if(mouseX > submitX - submitWidth/2 && mouseX < submitX + submitWidth/2 && mouseY > submitY - submitHeight/2 && mouseY < submitY + submitHeight/2)
     handleSubmit();
}

void handleSubmit() {
  println("Submitted: " + activateBtn);
  correct = 1;
  if (type == 1 && activateBtn == answerChoice - 1)
    correct = 2;
  else if (type == 2 && inputText.equals(answer))
    correct = 2;
  inputText = "";
  activateBtn = -1;
}

void keyPressed() {
  if (isActive) {
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
  if(type == 1 && activateBtn != -1)
    if (key == ENTER || key == RETURN)
      handleSubmit();
}
