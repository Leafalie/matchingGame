/*
  Matching Game
  Made for Space Apps 2019
  Made by: Alissa, Donovan, Fahad, and Lex
*/
final int xamt = 8;
final int yamt = 4;
Card[][] deck = new Card[xamt][yamt];

Card clicked = null;
Card curClicked = null;
int timesClicked = 0;

boolean haveFound = false;
boolean haveWon = false; 
PImage img;
int backg = 17;

int score = 0;
int p1score = 0;
int p2score = 0;
int highscore = 1000;

String player1 = "";
String player2 = "";
int players = -1;

boolean isPlayer1Done = false;
boolean isStarting = true;
boolean shownRules = false;

int curPlayer = 1;
int roundsPlayed = 1;

void setup(){
  fullScreen();
  textAlign(CENTER);
  fill(127);
  
  // make all the cards
  for(int i = 0; i < xamt; i++){ 
    for(int j = 0; j < yamt; j++){
      deck[i][j] = new Card(i * (width / xamt), j * (height / yamt)); 
    }
  }
  
  // assign images to cards
   shuffle();
  
}

void draw(){
  
  // screen for selecting how many players
  if (players == -1){
    background(127);
    strokeWeight(3.5);
    line(width/2,0,width/2,height);
    
    fill(0);
    textSize(72);
    text("1 Player", width/4, height/2);
    text("2 Players", 3 * width/4, height/2);
    
    textSize(36);
    text("(click here)", width/4, height/2 + 75);
    text("(click here)", 3 * width/4, height/2 + 75);
    return;
  }
  
  // main display
  if (!isStarting){
    if (shownRules){
      // load background image
      PImage back = loadImage("backimages/img" + backg + ".jpg");
      back.resize(width,height);
      background(back);
      
      // shows all the cards
      strokeWeight(1);
      for(int i = 0; i < xamt; i++){
        for(int j = 0; j < yamt; j++){
         deck[i][j].show(xamt,yamt);
        }
      }
      if (timesClicked == 0 && players == 2 && !haveWon){
        textSize(72);
        fill(255);
        if (curPlayer == 1){
          text(player1, width/2, height/2);
        }
        else {
          text(player2, width/2, height/2);
        }
      }
    } else {
      showRules();
    }
  }
  else if (!isPlayer1Done){ // entering player 1 name
    background(127);
    fill(255);
    textSize(72);
    text("Player 1, enter your name:", width/2, height/2 - 25);
    text(player1 + "_", width/2, height/2 + 50);  
  }
  else { // entering player 2 name
    background(127);
    fill(255);
    textSize(72);
    text("Player 2, enter your name:", width/2, height/2 - 25);
    text(player2 + "_", width/2, height/2 + 50);  
  }
  if(haveWon){ // load end screen for correct version
    if (players == 1){
      onePlayerEnd();
    }
    if (players == 2){
      twoPlayerEnd();
    }
    text("Press SPACE to restart", width/2, height - 75);
    textSize(32);
    text("Press < or > to change the image", width/2, height - 135);
  }
}

void keyPressed(){
  
  // getting player names
  if (isStarting){
    if (!isPlayer1Done){
     player1 = getName(player1);
    }
    else{
     player2 = getName(player2);
    }
  }
  else if (key == 119){ // w (cheat to win)
     haveWon = true;
     if (score < highscore){
        highscore = score; 
     }
     for(int i = 0; i < xamt; i++){
        for(int j = 0; j < yamt; j++){
          deck[i][j].found = true;
        }
     }
  }
  else if ((key == 114 || key == 82) && !haveWon){ // R/r to show rules
    if (shownRules == true){
      shownRules = false;
    }
    else {
      shownRules = true;
    }
  }
  endScreen(); // allows switching images at end
}

void mouseClicked(){

  if(players == -1){ // selecting 1 or 2 players
    if(mouseX <= (width/2)){
      players = 1;
      isStarting = false;
    }
    else {
      players = 2;
    }
   return; 
  }
  
  if(timesClicked != 2){ // runs before 3rd click
    curClicked = deck[mouseX/(width/xamt)][mouseY/(height/yamt)];
    if (curClicked.isFlipped || curClicked.found){ // don't do anything if it's already found/flipped
      return;
    }
  }
  
  timesClicked++;
  
  if (timesClicked == 1){ // first click: flip and assign
    curClicked.flip();
    clicked = curClicked;
    addColor();
  } 
  else if (timesClicked == 2){ // second click: flip and compare
    curClicked.flip();
    addColor();
    if (clicked.pimg == curClicked.pimg){
      haveFound = true;
      if(curPlayer == 1){
        p1score++;
      }
      else {
        p2score++;
      }
    }
  }
  else { // third click: checking for found cards/winning, unflip cards
    timesClicked = 0;
    if(haveFound){ // if we found a match in 2nd click
      clicked.found = true;
      curClicked.found = true;
      haveFound = false;
      if (!haveWon){ // check if we won
          for(int i = 0; i < xamt; i++){
            for(int j = 0; j < yamt; j++){
               if(!deck[i][j].found){
                 return;
               }
            }
          }
        }
      haveWon = true; // only runs when we won
      if (score < highscore){
       highscore = score; 
      }
    } 
    if(!haveWon){ 
      score++;
      curPlayer = 3 - curPlayer;
    }    
    // unflip all cards (on third click)
    for(int i = 0; i < xamt; i++){
      for(int j = 0; j < yamt; j++){
        deck[i][j].isFlipped = false;
      }
    }
  }
  
}

void restart(){ // runs on spacebar
  if (!haveWon){ // non
    return;
  }
  roundsPlayed++;
  // reset cards
  for(int i = 0; i < xamt; i++){
    for(int j = 0; j < yamt; j++){
      deck[i][j].pimg = null;
      deck[i][j].found = false;
      deck[i][j].r = 127;
      deck[i][j].b = 127;
    }
  }
  
  // shuffling deck
  shuffle();
  
  // reset data
  score = 0;
  haveWon = false;
  if ((roundsPlayed % 2) == 0){
    curPlayer = 2;
  }
  else {
    curPlayer = 1; 
  }
  // sets background back to Earth
  backg = 17;
}

void shuffle(){
  // assigns images to cards
  for (int i = 1; i <= 16; i++){
    img = loadImage("images/img" + i + ".jpg");
    Card picked;
    for (int j = 0; j < 2; j++){
      do {
        picked = deck[floor(random(xamt))][floor(random(yamt))];
      } while (picked.pimg != null);
      picked.pimg = img;
    }
  }
}

void endScreen(){
  
  // spacebar
  if (key == 32){
    restart();
  }
  // arrow keys change image
  if (keyCode == LEFT){
   backg--;
   if (backg < 1){
     backg = 17;
   }
  }
  else if (keyCode == RIGHT){
    backg++;
    if(backg > 17){
       backg = 1;
    }
  }
  
}

void onePlayerEnd(){ // endscreen for a one player game
    fill(255);
    textSize(72);
    text("Congrats!", width/2, 85);
    textSize(64);
    text("Score: " + score, width/2, height/2 - 25 );
    text("Highscore: " + highscore, width/2, height/2 + 25);
    text("Rounds: " + roundsPlayed, width/2, height - 255);
}

void twoPlayerEnd(){ // endscreen for a two player game
    fill(255);
    textSize(72);
    text(player1, width/6, 85);
    text(player2, 5 * width/6, 85);
    textSize(64);
    text("Pairs: " + p1score, width/6, 160);
    text("Pairs: " + p2score, 5 * width/6, 160);
    
    // find winner
    if (p1score > p2score){
      text("Congrats", width/2, height/2 - 85);
      text(player1 + "!", width/2, height/2 -25);
    }
    else if (p2score > p1score) {
      text("Congrats", width/2, height/2 - 85);
      text(player2 + "!", width/2, height/2 -25);
    }
    else {
      text("Congrats!", width/2, height/2 - 85);
    }
    
    text("Total Turns: " + score, width/2, height - 285);
    text("Combined Highscore: " + highscore, width/2, height - 225);
    text("Rounds: " + roundsPlayed, width/2, 85);

}

String getName(String player){ // assigns input to player string 
    if (((key >= 65 && key <= 90) || (key >= 97 && key <= 122)) && player.length() < 10){
      player += key; // only allows lower and upper case letters
    }
    if (key == 8 && player.length() > 0){ // removes last letter from string
      player = player.substring(0,player.length()-1);
    }
    if (key == 10){ // runs when enter is hit
      if (player.length() == 0) { // sets default names
        if(isPlayer1Done){
          player = "Player 2";
        } 
        else {
          player = "Player 1";
        }
      }
      if (isPlayer1Done){
        isStarting = false;
      }
      else {
        isPlayer1Done = true;
      }
    }
  return player;
}

void addColor(){
  if(players == 2){
    if(curClicked.r < 245 && curPlayer == 1) { // adds red to cards player 1 clicks
      curClicked.r += 10;
    }
    if(curClicked.b < 245 && curPlayer == 2) { // adds blue to cards player 2 clicks
      curClicked.b += 10;
    }
  }
  else {
    if(curClicked.r < 245){
      curClicked.r += 10; // adds red during 1 player games
    }
  }
}

void showRules(){
  // displays the rules image when r is pressed
  PImage rules = loadImage("images/rules.jpg");
  rules.resize(width,height);
  background(rules);
  textSize(40);
  fill(0);
  text("Press [R/r] to open or close this page at any time", width/2, height - 100);
}
