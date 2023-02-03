class Alien {
  boolean startGame;
  float x, y;
  float current_y;
  int dx, dy;
  int exno;
  int flip;
  int id;
  boolean left, right, down;
  boolean explode, exploded;
  boolean animate1, animate2, animate3, animate4;
  boolean pointAdded, bombDropped;
  PImage myImage;

  Alien(float xpos, float ypos, PImage alienImage, int ID) {
    startGame = false;
    x = xpos;
    y = ypos;
    dx = 3;
    dy = 3;
    exno = 1;
    flip = 1;
    id = ID;
    current_y = y;
    left = false;
    right = true;
    down = false;
    explode = false;
    exploded = false;
    animate1 = false;
    animate2 = false;
    animate3 = false;
    animate4 = false;
    pointAdded = false;
    bombDropped = false;
    myImage = alienImage;
  }

  void move() {
    if (right == true) {
      if (x >= SCREENX - ALIEN_WIDTH) {
        right = false;
        down = true;
      } else x = x + dx;
      current_y = y;
    } else if (left == true) {
      if (x <= 0) {
        left = false;
        down = true;
      } else x = x - dx;
      current_y = y;
    } else if (down == true) {
      if (y >= SCREENY - ALIEN_HEIGHT - (2*MARGIN)) {
        y = y + dy;
      } else if (y >= current_y + ALIEN_HEIGHT) {
        down = false;
        if (x <= 0) right = true;
        else left = true;
      } else y = y + dy;
    }
  }

  void bomb(Player player) {
    if (bombDropped) {
      moveBombs(id);
      drawBombs(id);
      collideBombs(player, id);
    }
  }

  void draw() {
    if (!exploded) {
      if (points < NUMBER_OF_ALIENS)
        image(myImage, x, y);
      if (random(0, 1) < SpawnRateB && !bombDropped) {
        spawnBomb(x+3, y, id);
        bombDropped = true;
      }
    }
  }

  void explode() {
    if (animate1) {
      if (animate2) {
        if (explode == true) {
          myImage = loadImage("explode" + exno + ".png");
          if (exno < 5)
            exno++;
          else {
            exploded = true;
            if (!pointAdded) {
              points++;
              println("points = " + points);
              if (random(0, 1) < SpawnRateP)
                spawnPowerUp(x, y);
              pointAdded = true;
              SpawnRateB = SpawnRateB + 0.0005;
              Explode.play();
            }
          }
        }
      }
    }
  }

  void animate() {
    if (animate1) {
      if (animate2) {
        if (animate3) {
          if (animate4) {
            if (!explode) {
              myImage = loadImage("invader" + flip + ".png");
              if (flip == 1)
                flip = 2;
              else
                flip = 1;
            }
            animate1 = false;
            animate2 = false;
            animate3 = false;
            animate4 = false;
          } else
            animate4 = true;
        } else
          animate3 = true;
      } else
        animate2 = true;
    } else
      animate1 = true;
  }
}
