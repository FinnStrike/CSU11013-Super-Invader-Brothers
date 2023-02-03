class Bullet {
  float x;
  float y;
  float dx;
  float dy;
  int flip;
  boolean animate1, animate2, animate3, animate4, animate5, animate6;
  PImage myImage;

  Bullet(Player player, PImage bulletImage) {
    x = player.xpos + 10 + (BulletType == "fireball" ? 5 : 0);
    y = player.ypos;
    dy = BulletSpeed;
    flip = 1;
    animate1 = false;
    animate2 = false;
    animate3 = false;
    animate4 = false;
    animate5 = false;
    animate6 = false;
    myImage = bulletImage;
  }
  void move() {
    y = y-dy;
  }
  void draw() {
    if (points < NUMBER_OF_ALIENS)
      image(myImage, x, y);
  }
  void collideAliens(Alien array[]) {
    for (int i=0; i<array.length; i++) {
      if (y <= array[i].y+ALIEN_HEIGHT &&
        y+BulletHeight >= array[i].y &&
        x <= array[i].x+ALIEN_WIDTH &&
        x+BulletWidth >= array[i].x) {
        array[i].explode = true;
      }
    }
  }
  void animate() {
    if (animate1) {
      if (animate2) {
        if (animate3) {
          if (animate4) {
            if (animate5) {
              if (animate6) {
                myImage = loadImage(BulletType + flip + ".png");
                if (flip == 1)
                  flip = 2;
                else if (flip == 2)
                  flip = 3;
                else
                  flip = 1;
                animate1 = false;
                animate2 = false;
                animate3 = false;
                animate4 = false;
              } else
                animate6 = true;
            } else
              animate5 = true;
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
