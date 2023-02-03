//IMPORTS/////////////////////////////////////////////////////////////////////////

import processing.sound.*;
import ddf.minim.*;

//DECLARATIONS////////////////////////////////////////////////////////////////////

Alien myAliens[];
Player thePlayer;
Shield shield1;
Shield shield2;
ArrayList <PowerUp> powerups;
ArrayList <Bullet> bullets;
Bomb bombs[];

int x;
int y;
float counter;
float volume;
PImage alienImage;
PImage playerImage;
PImage bulletImage;
PImage powerUpImage;
PImage bombImage;
PImage shieldImage;
PFont myFont;
boolean gameStart;
boolean gameOver;
boolean gameWin;
Minim minim;
AudioPlayer Start;
AudioPlayer Main;
AudioPlayer Dead;
AudioPlayer Win;
SoundFile Explode;
SoundFile Blaster;
SoundFile Upgrade;
SoundFile Damage;
Reverb reverb;
TriOsc wave;

//INITIALIZATIONS/////////////////////////////////////////////////////////////////

void settings() {
  size(SCREENX, SCREENY);
}

void setup() {
  background(255);
  gameStart = false;
  gameOver = false;
  gameWin = false;
  myAliens = new Alien[NUMBER_OF_ALIENS];
  bullets = new ArrayList();
  powerups = new ArrayList();
  bombs = new Bomb[NUMBER_OF_ALIENS];
  x = 0;
  y = 0;
  counter = 0;
  volume = 0;
  alienImage = loadImage("invader1.png");
  playerImage = loadImage("player_back.png");
  bulletImage = loadImage("fireball1.png");
  powerUpImage = loadImage("explode5.png");
  bombImage = loadImage("Bomb1.png");
  shieldImage = loadImage("Shield1.png");
  myFont = loadFont("Orbitron-Bold-28.vlw");
  initAliens(myAliens);
  thePlayer = new Player(SCREENY-MARGIN-PLAYER_HEIGHT, playerImage);
  shield1 = new Shield(200, SCREENY-MARGIN-(3*PLAYER_HEIGHT), shieldImage);
  shield2 = new Shield(SCREENX-SHIELD_WIDTH-200, SCREENY-MARGIN-(3*PLAYER_HEIGHT), shieldImage);
  minim = new Minim(this);
  Start = minim.loadFile("File Select.mp3");
  Main = minim.loadFile("Green Hill Zone.mp3");
  Dead = minim.loadFile("mario dead.mp3");
  Win = minim.loadFile("Star Catch Fanfare.mp3");
  Explode = new SoundFile(this, "Explosion.mp3");
  Blaster = new SoundFile(this, "blaster-firing.mp3");
  Upgrade = new SoundFile(this, "Upgrade.mp3");
  Damage = new SoundFile(this, "Brick Break.wav");
  reverb = new Reverb(this);
  wave = new TriOsc(this);
  reverb.process(wave);
  Start.loop();
}

//DRAWINGS////////////////////////////////////////////////////////////////////////

void draw() {
  if (!gameStart) {
    Main.loop();
    background(255);
    textFont(myFont);
    fill(0);
    text("Press any key\n       to play", SCREENX/3 + 35, SCREENY/3);
    thePlayer.move((SCREENX/2)-(PLAYER_WIDTH/2), SCREENY/2);
    thePlayer.draw();
  } else if (!gameOver && !gameWin) {
    Start.pause();
    frameRate(FRAME_RATE);
    background(255);
    moveAliens(myAliens);
    drawAliens(myAliens);
    movePowerUps();
    drawPowerUps();
    moveBullets();
    drawBullets();
    removePowerUp();
    collideBullets();
    removeToLimit(BulletLimit);
    if (!shield1.destroyed) {
      shield1.draw();
    }
    if (!shield2.destroyed) {
      shield2.draw();
    }
    thePlayer.win();
    thePlayer.move(mouseX, SCREENY-MARGIN-PLAYER_HEIGHT);
    thePlayer.draw();
  } else if (gameOver) {
    Main.pause();
    Dead.play();
    frameRate(12.5);
    background(255);
    textFont(myFont);
    fill(0);
    text("   Game Over", SCREENX/3 + 35, SCREENY/3);
    thePlayer.explode();
    thePlayer.draw();
  } else {
    frameRate(50);
    Main.pause();
    Win.play();
    if (Win.position() > 3250) {
      if (counter <= 1000) {
        wave.play(4186.01, ((0.5-volume>0)?(0.5-volume):(0.00001)));
        counter+=25;
        volume+=0.0250;
      } else
        wave.stop();
    }
    background(255);
    thePlayer.win();
    textFont(myFont);
    fill(0);
    text("Congratulations!\n        You win!", SCREENX/3 + 35, SCREENY/3);
    thePlayer.draw();
  }
}

//COMMANDS////////////////////////////////////////////////////////////////////////

void keyPressed()
{
  gameStart = true;
}

void mousePressed()
{
  if (gameStart) {
    Bullet temp = new Bullet(thePlayer, bulletImage);
    bullets.add(temp);
    Blaster.play();
  }
}

//ALIENS//////////////////////////////////////////////////////////////////////////

void initAliens(Alien array[]) {
  for (int i=0; i<array.length; i++)
    array[i] = new Alien((2*i*ALIEN_WIDTH)-OFFSET, y, alienImage, i);
}

void moveAliens(Alien array[]) {
  for (int i=0; i<array.length; i++) {
    array[i].move();
    array[i].bomb(thePlayer);
  }
}

void drawAliens(Alien array[]) {
  for (int i=0; i<array.length; i++) {
    array[i].explode();
    array[i].animate();
    array[i].draw();
  }
}

//BULLETS/////////////////////////////////////////////////////////////////////////

void removeToLimit(int maxLength)
{
  while (bullets.size() > maxLength)
  {
    bullets.remove(0);
  }
}

void moveBullets()
{
  for (Bullet temp : bullets)
  {
    temp.move();
    if (!shield1.destroyed)
      collideShield1Bullets(temp);
    if (!shield2.destroyed)
      collideShield2Bullets(temp);
  }
}

void drawBullets()
{
  for (Bullet temp : bullets)
  {
    temp.animate();
    temp.draw();
  }
}

void collideBullets()
{
  for (Bullet temp : bullets)
  {
    temp.collideAliens(myAliens);
    collidePowerUps(temp);
  }
}

//POWERUPS////////////////////////////////////////////////////////////////////////

void spawnPowerUp(float xpos, float ypos) {
  String powerUpType = "";
  int random = (int)random(1, 4);
  if (random == 1 && !effect1Added) {
    powerUpType = "P_Speed";
    powerUpImage = loadImage("P_Speed1.png");
  } else if (random == 2 && !effect2Added) {
    powerUpType = "P_Big";
    powerUpImage = loadImage("P_Big1.png");
  } else if (random == 3 && !effect3Added) {
    powerUpType = "P_Mul";
    powerUpImage = loadImage("P_Mul1.png");
  }
  PowerUp temp = new PowerUp(xpos, ypos+BulletHeight+4, powerUpType, powerUpImage);
  powerups.add(temp);
}

void removePowerUp() {
  for (int i = powerups.size()-1; i >= 0; i--) {
    if (powerups.get(i).remove == true)
      powerups.remove(i);
  }
}

void movePowerUps()
{
  for (PowerUp temp : powerups)
  {
    temp.move();
  }
}

void drawPowerUps()
{
  for (PowerUp temp : powerups)
  {
    temp.draw();
  }
}

void collidePowerUps(Bullet bullet)
{
  for (PowerUp temp : powerups)
  {
    temp.collidePowerUps(bullet);
  }
}

//BOMBS///////////////////////////////////////////////////////////////////////////

void spawnBomb(float xpos, float ypos, int ID) {
  bombs[ID] = new Bomb(xpos, ypos, bombImage);
}

void moveBombs(int ID)
{
  bombs[ID].move();
  if (!shield1.destroyed)
    collideShield1Bombs(bombs[ID]);
  if (!shield2.destroyed)
    collideShield2Bombs(bombs[ID]);
}

void drawBombs(int ID)
{
  if (!bombs[ID].offScreen())
    bombs[ID].draw();
  else
    myAliens[ID].bombDropped = false;
}

void collideBombs(Player thePlayer, int ID)
{
  if (bombs[ID].collideBomb(thePlayer)) {
    gameOver = true;
    Explode.play();
  }
}

//SHIELDS/////////////////////////////////////////////////////////////////////////

void collideShield1Bullets(Bullet bullet) {
  if (bullet.y <= shield1.y+SHIELD_HEIGHT &&
    bullet.y+BulletHeight >= shield1.y &&
    bullet.x <= shield1.x+SHIELD_WIDTH &&
    bullet.x+BulletWidth >= shield1.x) {
    bullet.y = 0-(2*BulletHeight);
    shield1Damage++;
    if (shield1Damage == 4) {
      shield1.damage();
      println("Left Shield damaged!");
    } else if (shield1Damage == 8) {
      shield1.destroyed = true;
      println("Left Shield destroyed!");
    } else
      println("Left Shield hit!");
    Damage.play();
  }
}

void collideShield2Bullets(Bullet bullet) {
  if (bullet.y <= shield2.y+SHIELD_HEIGHT &&
    bullet.y+BulletHeight >= shield2.y &&
    bullet.x <= shield2.x+SHIELD_WIDTH &&
    bullet.x+BulletWidth >= shield2.x) {
    bullet.y = 0-(2*BulletHeight);
    shield2Damage++;
    if (shield2Damage == 4) {
      shield2.damage();
      println("Right Shield damaged!");
    } else if (shield2Damage == 8) {
      shield2.destroyed = true;
      println("Right Shield destroyed!");
    } else
      println("Right Shield hit!");
    Damage.play();
  }
}

void collideShield1Bombs(Bomb bomb) {
  if (bomb.y <= shield1.y+SHIELD_HEIGHT &&
    bomb.y+BOMB_HEIGHT >= shield1.y &&
    bomb.x <= shield1.x+SHIELD_WIDTH &&
    bomb.x+BOMB_WIDTH >= shield1.x) {
    bomb.y = SCREENY;
    shield1Damage++;
    if (shield1Damage == 4) {
      shield1.damage();
      println("Left Shield damaged!");
    } else if (shield1Damage == 8) {
      shield1.destroyed = true;
      println("Left Shield destroyed!");
    } else
      println("Left Shield hit!");
    Damage.play();
  }
}

void collideShield2Bombs(Bomb bomb) {
  if (bomb.y <= shield2.y+SHIELD_HEIGHT &&
    bomb.y+BOMB_HEIGHT >= shield2.y &&
    bomb.x <= shield2.x+SHIELD_WIDTH &&
    bomb.x+BOMB_WIDTH >= shield2.x) {
    bomb.y = SCREENY;
    shield2Damage++;
    if (shield2Damage == 4) {
      shield2.damage();
      println("Right Shield damaged!");
    } else if (shield2Damage == 8) {
      shield2.destroyed = true;
      println("Right Shield destroyed!");
    } else
      println("Right Shield hit!");
    Damage.play();
  }
}
