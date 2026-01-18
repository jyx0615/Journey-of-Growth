// --------------------
// Enum replacement
// --------------------

const QuestionType = Object.freeze({
  MULTIPLE_CHOICE: 0,
  INPUT_QUESTION: 1
});

// --------------------
// Question class
// --------------------

class Question {
  constructor(obj) {
    const questionTypeStr = obj.type;
    this.type = QuestionType[questionTypeStr.toUpperCase()];
    this.questionStr = obj.question;

    this.answerStr = "";
    this.answerNum = -1;
    this.choices = [];
    this.subject = Subject.NONE;

    if (this.type === QuestionType.MULTIPLE_CHOICE) {
      this.answerNum = obj.answer;
      const c = obj.choices;
      this.choices = new Array(c.length);
      for (let i = 0; i < c.length; i++) {
        this.choices[i] = c[i];
      }
    } else if (this.type === QuestionType.INPUT_QUESTION) {
      this.answerStr = obj.answer;
    }

    if ("subject" in obj) {
      const subjectStr = obj.subject;
      this.subject = Subject[subjectStr.toUpperCase()];
    }
  }
}

// --------------------
// Quiz class
// --------------------

class Quiz {
  constructor() {
    this.loadBackgroundImage();
    this.reset();

    this.pendingAddScore = false;
    this.pendingScoreIndex = -1;
    this.pendingScoreAmount = 0;
  }

  loadBackgroundImage() {
    this.quizStartBackground = loadImage("assets/backgrounds/quiz_start.png");
    this.quizBackground = loadImage("assets/backgrounds/quiz.png");
  }

  reset() {
    this.transitionProgress = 0;
    this.show_quiz_content = false;
    this.correct = 0; // 0: none, 1: wrong, 2: correct
    this.inputText = "";
    this.activateBtn = -1;
    this.exit_counter = 0;
  }

  setQuestion(q) {
    this.question = q;
  }

  draw() {
    textFont(ChocolateFont);
    rectMode(CORNER);
    noStroke();
    fill(232, 220);
    rect(0, 0, width, height);

    // quiz intro animation
    if (!this.show_quiz_content) {
      if (this.transitionProgress < 1) {
        this.transitionProgress += 0.05;
        const scale = min(map(this.transitionProgress, 0, 1, 0, 1), 1);

        imageMode(CENTER);
        image(
          this.quizStartBackground,
          width / 2,
          360,
          400 * scale,
          600 * scale
        );
      } else {
        imageMode(CENTER);
        image(this.quizStartBackground, width / 2, 360, 400, 600);
        this.show_quiz_content = true;
      }
      return;
    }

    // quiz content
    imageMode(CENTER);
    image(this.quizBackground, width / 2, 360, 400, 600);

    this.drawQuestion();

    if (this.question.type === QuestionType.MULTIPLE_CHOICE) {
      this.drawChoices();
      this.drawButtons();
    } else {
      this.drawInputTitle();
      this.drawInput();
    }

    this.drawSubmitButton();
    this.drawResult();

    // exit quiz
    if (this.exit_counter > 0) {
      this.exit_counter -= 0.015;
      if (this.exit_counter <= 0) {
        this.reset();
        game.doodleJump.state = DoodleJumpState.PLAYING;
      }
    }
  }

  updateAnserByKeyPress() {
    if (this.question.type === QuestionType.INPUT_QUESTION) {
      if (keyCode === BACKSPACE && this.inputText.length > 0) {
        this.inputText = this.inputText.slice(0, -1);
      } else if (keyCode === ENTER || keyCode === RETURN) {
        this.handleSubmit();
      } else if (key.length === 1 && this.inputText.length < INPUT_MAX_LENGTH) {
        this.inputText += key;
      }
    }

    if (this.question.type === QuestionType.MULTIPLE_CHOICE) {
      if (key >= '1' && key <= '4') {
        const choice = int(key) - 1;
        this.activateBtn = this.activateBtn === choice ? -1 : choice;
      }
      if (
        this.activateBtn !== -1 &&
        (keyCode === ENTER || keyCode === RETURN)
      ) {
        this.handleSubmit();
      }
    }
  }

  updateByMousePress() {
    if (this.question.type === QuestionType.MULTIPLE_CHOICE) {
      for (let i = 0; i < this.question.choices.length; i++) {
        const startX = buttonX + buttonOffsetX * i;
        if (
          mouseX > startX &&
          mouseX < startX + buttonWidth &&
          mouseY > buttonY &&
          mouseY < buttonY + buttonHeight
        ) {
          this.activateBtn = this.activateBtn === i ? -1 : i;
        }
      }
    }

    if (
      mouseX > submitX - submitWidth / 2 &&
      mouseX < submitX + submitWidth / 2 &&
      mouseY > submitY - submitHeight / 2 &&
      mouseY < submitY + submitHeight / 2
    ) {
      this.handleSubmit();
    }
  }

  handleSubmit() {
    this.correct = 1;

    if (
      this.question.type === QuestionType.MULTIPLE_CHOICE &&
      this.activateBtn === this.question.answerNum - 1
    ) {
      this.correct = 2;
    }

    if (
      this.question.type === QuestionType.INPUT_QUESTION &&
      this.inputText === this.question.answerStr
    ) {
      this.correct = 2;
    }

    if (this.correct === 2) {
      game.doodleJump.correctSound.play();
      if (this.pendingAddScore && this.pendingScoreIndex >= 0) {
        game.doodleJump.scores[this.pendingScoreIndex] += this.pendingScoreAmount;
      }
    } else {
      game.doodleJump.wrongSound.play();
    }

    this.exit_counter = 1;
    this.pendingAddScore = false;
    this.pendingScoreIndex = -1;
    this.pendingScoreAmount = 0;
  }

  drawSubmitButton() {
    rectMode(CENTER);
    fill("#3DB709");
    rect(submitX, submitY, submitWidth, submitHeight, 5);
    fill("#1D5D03");
    textAlign(CENTER, CENTER);
    text("submit", submitX, submitY);
  }

  drawQuestion() {
    textAlign(CENTER, CENTER);
    textSize(23);
    fill(20);
    text(this.question.questionStr, questionX, questionY);
  }

  drawInputTitle() {
    textSize(24);
    textAlign(LEFT, CENTER);
    text("Your answer", inputX - 30, inputY - 30);
  }

  drawInput() {
    rectMode(CORNER);
    stroke("#2609E8");
    fill(240);
    rect(inputX, inputY, inputWidth, inputHeight, 5);
    fill(0);
    textSize(20);
    text(this.inputText, inputX + 10, inputY + inputHeight / 2 - 5);
  }

  drawResult() {
    textAlign(CENTER, CENTER);
    if (this.correct === 1) {
      fill("#E80911");
      text("wrong", answerX, answerY);
    } else if (this.correct === 2) {
      fill("#3DB709");
      text("correct", answerX, answerY);
    }
  }

  drawChoices() {
    textAlign(LEFT, CENTER);
    for (let i = 0; i < this.question.choices.length; i++) {
      text(
        `(${i + 1}) ${this.question.choices[i]}`,
        choicesX,
        choicesY + choicesOffsetY * i
      );
    }
  }

  drawButtons() {
    rectMode(CORNER);
    textAlign(CENTER, CENTER);
    textSize(24);

    for (let i = 0; i < this.question.choices.length; i++) {
      const startX = buttonX + buttonOffsetX * i;

      stroke(23, 92, 192);
      noFill();
      rect(startX, buttonY, buttonWidth, buttonHeight, 5);

      stroke(0);
      circle(startX + 50, buttonY + buttonHeight / 2, 15);
      text(`(${i + 1})`, startX + 20, buttonY + buttonHeight / 2 - 5);

      if (this.activateBtn === i) {
        fill(23, 92, 192);
        noStroke();
        circle(startX + 50, buttonY + buttonHeight / 2, 10);
      }
    }
  }
}
