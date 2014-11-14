Ship ship;
PowerUp ruby;
Bullet[] bList;
Laser[] lList;
Alien[] aList;

//Game Status
final int GAME_START   = 0;
final int GAME_PLAYING = 1;
final int GAME_PAUSE   = 2;
final int GAME_WIN     = 3;
final int GAME_LOSE    = 4;
int status;              //Game Status
int point;               //Game Score
int expoInit;            //Explode Init Size
int countBulletFrame;    //Bullet Time Counter
int bulletNum;           //Bullet Order Number

/*--------Put Variables Here---------*/
int countLaserFrame;
int laserNum;
int rubyPoint;

void setup() {

  status = GAME_START;

  bList = new Bullet[30];
  lList = new Laser[30];
  aList = new Alien[100];

  size(640, 480);
  background(0, 0, 0);
  rectMode(CENTER);


  ship = new Ship(width/2, 460, 3);
  ruby = new PowerUp(int(random(width)), -10);

  reset();
}




void draw() {
  background(50, 50, 50);
  noStroke();


  switch(status) {

  case GAME_START:
    /*---------Print Text-------------*/

    printText(width/2, 240, 60, 20, 40, "GALAXIAN", "Press ENTER to Start"); // replace this with printText


    /*--------------------------------*/
    break;
  case GAME_PLAYING:
    background(50, 50, 50);

    drawHorizon();
    drawScore();
    drawLife();
    ship.display(); //Draw Ship on the Screen
    drawAlien();
    drawBullet();
    drawLaser();


    /*---------Call functions---------------*/
    drawRuby(); 

    alienShoot(50);

    checkAlienDead(); /*finish this function*/
    checkShipHit();  /*finish this function*/

    checkRubyDrop(200);
    checkRubyHit();
    
    checkWin();

    countBulletFrame+=1;
    countLaserFrame +=1;
    break;

  case GAME_PAUSE:
    /*---------Print Text-------------*/
    printText(width/2, 240, 40, 20, 40, "PAUSE", "Press ENTER to Resume");
    /*--------------------------------*/
    break;

  case GAME_WIN:
    /*---------Print Text-------------*/
    printText(width/2, 300, 40, 20, 40, "WINNER", "Score"+":"+point);
    /*--------------------------------*/
    winAnimate();
    break;

  case GAME_LOSE:
    loseAnimate();
    /*---------Print Text-------------*/
    printText(width/2, 240, 40, 20, 40, "BOOOM", "You are dead!!");
    /*--------------------------------*/
    break;
  }
}

void drawHorizon() {
  stroke(153);
  line(0, 420, width, 420);
}

void drawScore() {
  noStroke();
  fill(95, 194, 226);
  textAlign(CENTER, CENTER);
  textSize(23);
  text("SCORE:"+point, width/2, 16);
}

void keyPressed() {
  if (status == GAME_PLAYING) {
    ship.keyTyped();
    cheatKeys();
    shootBullet(30);
  }
  statusCtrl();
}

/*---------Make Alien Function-------------*/
void alienMaker(int total, int numInRow) {

  int ox = 50; 
  int oy = 50; 
  int xSpacing = 40; 
  int ySpacing = 50; 

  for (int i=0; i <total; ++i) {

    int x = ox + (xSpacing*(i % numInRow));
    int y = oy + (ySpacing*int(i / numInRow));

    //aList[0]= new Alien(ox,oy);
    aList[i]= new Alien(x, y);
  }
}



void drawLife() {
  fill(230, 74, 96);
  text("LIFE:", 36, 455);
  /*---------Draw Ship Life---------*/
  int ox = 78; 
  int oy = 459;
  int spacing = 25;
  int diameter = 15;

  for (int i=0; i<ship.life; i++) {

    int x = ox + spacing*i;
    int y = oy;


    ellipse(x, y, diameter, diameter);
  }
}



void drawBullet() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    if (bullet!=null && !bullet.gone) { // Check Array isn't empty and bullet still exist
      bullet.move();     //Move Bullet
      bullet.display();  //Draw Bullet on the Screen
      if (bullet.bY<0 || bullet.bX>width || bullet.bX<0) {
        removeBullet(bullet); //Remove Bullet from the Screen
      }
    }
  }
}

void drawLaser() {
  for (int i=0; i<lList.length-1; i++) { 
    Laser laser = lList[i];
    if (laser!=null && !laser.gone) { // Check Array isn't empty and Laser still exist
      laser.move();      //Move Laser
      laser.display();   //Draw Laser
      if (laser.lY>480) {
        removeLaser(laser); //Remove Laser from the Screen
      }
    }
  }
}


//draw ruby
void drawRuby() {
  if (ruby.show == true) {
    ruby.move();      //Move Ruby
    ruby.display();   //Draw Ruby
    if (ruby.pY>480) {
      ruby.show = false; //Remove ruby from the Screen
    }
  }
}


void drawAlien() {
  for (int i=0; i<aList.length-1; i++) {
    Alien alien = aList[i];
    if (alien!=null && !alien.die) { // Check Array isn't empty and alien still exist
      alien.move();    //Move Alien
      alien.display(); //Draw Alien
      /*---------Call Check Line Hit---------*/
      if (alienCheckBut(alien) == true) {
        status = GAME_LOSE;
        break;
      }
      /*--------------------------------------*/
    }
  }
}

/*--------Check Line Hit---------*/
boolean alienCheckBut(Alien alien) {
  if (alien.aY + alien.aSize >= 420) {
    return true;
  } else {
    return false;
  }
}

/*---------Ship Shoot-------------*/
void shootBullet(int frame) {
  if ( key == ' ' && countBulletFrame>frame) {
    if (!ship.upGrade) {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0);
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    } 
    /*---------Ship Upgrade Shoot-------------*/
    else {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }

      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 1); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }

      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, -1); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    }
    countBulletFrame = 0;
  }
}

/*---------Check Alien Hit-------------*/
void checkAlienDead() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    for (int j=0; j<aList.length-1; j++) {
      Alien alien = aList[j];
      if (bullet != null && alien != null && !bullet.gone && !alien.die // Check Array isn't empty and bullet / alien still exist
      /*------------Hit detect-------------*/
      && bullet.bX < alien.aX + alien.aSize && bullet.bX > alien.aX - alien.aSize && bullet.bY < alien.aY + alien.aSize && bullet.bY < alien.aY - alien.aSize) {
        /*-------do something------*/
        point = point + alien.aScore;
        rubyPoint = rubyPoint + alien.aScore;
        removeBullet(bullet);
        removeAlien(alien);
      }
    }
  }
}



/*---------Alien Drop Laser-----------------*/
void alienShoot(int frame) { 
  if (countLaserFrame>frame) {
    int alive = 0;
    for (int i=0; i<aList.length-1; i++) {
      Alien alien = aList[i]; 
      if (alien!=null && !alien.die) { 
        alive++;
      }
    }

    int alienShootNum = int(random(alive))+1;

    for (int i=0; i<aList.length-1; i++) {
      Alien alien = aList[i]; 
      if (alien!=null && !alien.die) { 
        alienShootNum-- ;
        if (alienShootNum == 0) {
          lList[laserNum]= new Laser(alien.aX, alien.aY);
          if (laserNum<lList.length-1) {
            laserNum+=1;
          } else {
            laserNum = 0;
          }
          countLaserFrame = 0;
          break;
        }
      }
    }
  }
}

/*---------Check Laser Hit Ship-------------*/
void checkShipHit() {
  for (int i=0; i<lList.length-1; i++) {
    Laser laser = lList[i];
    if (laser!= null && !laser.gone // Check Array isn't empty and laser still exist
    && laser.lX < ship.posX + ship.shipSize && laser.lX > ship.posX - ship.shipSize  && laser.lY < ship.posY + ship.shipSize && laser.lY > ship.posY - ship.shipSize
    /*------------Hit detect-------------*/      ) {
      /*-------do something------*/
      removeLaser(laser);
      ship.life--;
      if (ship.life == 0 ) {
        status = GAME_LOSE;
        reset();
      }
    }
  }
}

/*---------Check Win Lose------------------*/
void checkWin() {

  boolean aliveAlien = false; 

  for (int i=0; i<aList.length-1; i++) {
    Alien alien = aList[i]; 
    if (alien!=null && !alien.die) { 
      aliveAlien = true;
      break ;
    }
  }
  //aliveAlien == false
  if(!aliveAlien){
  status = GAME_WIN;
  }
 
}



void winAnimate() {
  int x = int(random(128))+70;
  fill(x, x, 256);
  ellipse(width/2, 200, 136, 136);
  fill(50, 50, 50);
  ellipse(width/2, 200, 120, 120);
  fill(x, x, 256);
  ellipse(width/2, 200, 101, 101);
  fill(50, 50, 50);
  ellipse(width/2, 200, 93, 93);
  ship.posX = width/2;
  ship.posY = 200;
  ship.display();
}

void loseAnimate() {
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+200, expoInit+200);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+150, expoInit+150);
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+100, expoInit+100);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+50, expoInit+50);
  fill(50, 50, 50);
  ellipse(ship.posX, ship.posY, expoInit, expoInit);
  expoInit+=5;
}

void checkRubyDrop(int pt) {
  if (rubyPoint >= pt) {
    if (!ruby.show) {
      ruby.show = true;
      ruby.pX = int(random(width));
      ruby.pY = -10;
      //      rubyPoint=0;
    }
  }
}


/*---------Check Ruby Hit Ship-------------*/
void checkRubyHit() {
  if (ruby.pX < ship.posX + ship.shipSize && ruby.pX > ship.posX - ship.shipSize  && ruby.pY < ship.posY + ship.shipSize && ruby.pY > ship.posY - ship.shipSize
  /*------------Hit detect-------------*/    ) {
    /*-------do something------*/
    ruby.show = false;
    ship.upGrade = true;
  }
}

/*---------Check Level Up------------------*/


/*---------Print Text Function-------------*/

//print text when GAME_START, GAME_PAUSE, GAME_WIN, GAME_LOSE
void printText(int x, int y, int size1, int size2, int distance, String line1, String line2) {
  colorMode(RGB);
  fill(95, 194, 226);
  textSize(size1);
  textAlign(CENTER, CENTER);
  text(line1, x, y);

  fill(95, 194, 226);
  textSize(size2);
  text(line2, x, y+distance);
}



void removeBullet(Bullet obj) {
  obj.gone = true;
  obj.bX = 2000;
  obj.bY = 2000;
}

void removeLaser(Laser obj) {
  obj.gone = true;
  obj.lX = 2000;
  obj.lY = 2000;
}

void removeAlien(Alien obj) {
  obj.die = true;
  obj.aX = 1000;
  obj.aY = 1000;
}

/*---------Reset Game-------------*/
void reset() {
  for (int i=0; i<bList.length-1; i++) {
    bList[i] = null;
    lList[i] = null;
  }

  for (int i=0; i<aList.length-1; i++) {
    aList[i] = null;
  }

  point = 0;
  expoInit = 0;
  countBulletFrame = 30;
  bulletNum = 0;


  /*--------Init Variable Here---------*/

  ship.life = 3;
  countLaserFrame = 50;
  laserNum = 0;
  rubyPoint = 0;

  /*-----------Call Make Alien Function--------*/
  alienMaker(53, 12);


  ship.posX = width/2;
  ship.posY = 460;
  ship.upGrade = false;
  ruby.show = false;
  ruby.pX = int(random(width));
  ruby.pY = -10;
}

/*-----------finish statusCtrl--------*/
void statusCtrl() {
  if (key == ENTER) {
    switch(status) {

    case GAME_START:
      status = GAME_PLAYING;
      reset();
      ship.life = 3;
      break;

      /*-----------add things here--------*/

    case GAME_PLAYING:
      status = GAME_PAUSE;

      break;

    case GAME_PAUSE:
      status = GAME_PLAYING;
      break;

    case GAME_WIN:
      status = GAME_PLAYING;
      reset();
      break;

    case GAME_LOSE:
      status = GAME_PLAYING;
      reset();
      break;
    }
  }
}

void cheatKeys() {

  if (key == 'R'||key == 'r') {
    ruby.show = true;
    ruby.pX = int(random(width));
    ruby.pY = -10;
  }
  if (key == 'Q'||key == 'q') {
    ship.upGrade = true;
  }
  if (key == 'W'||key == 'w') {
    ship.upGrade = false;
  }
  if (key == 'S'||key == 's') {
    for (int i = 0; i<aList.length-1; i++) {
      if (aList[i]!=null) {
        aList[i].aY+=50;
      }
    }
  }
}
