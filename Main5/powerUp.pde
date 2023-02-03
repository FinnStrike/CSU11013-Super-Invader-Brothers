class PowerUp {
  float x;
  float y;
  float dy;
  int flip;
  boolean remove;
  PImage myImage;
  String type;

  PowerUp(float xpos, float ypos, String powerUpType, PImage image) {
    x = xpos;
    y = ypos;
    dy = 2;
    flip = 1;
    remove = false;
    type = powerUpType;
    myImage = image;
  }
  void move() {
    y = y+dy;
    if (y > SCREENY)
      remove = true;
  }
  void draw() {
    if (remove == false) {
      if (points < NUMBER_OF_ALIENS) {
        if (type == "P_Mul")
          image(myImage, x, y);
        else if (type == "P_Big")
          image(myImage, x, y);
        else if (type == "P_Speed")
          image(myImage, x, y);
      }
    }
  }
  void collidePowerUps(Bullet bullet) {
    if (y <= bullet.y+BulletHeight &&
      y+myImage.height >= bullet.y &&
      x <= bullet.x+BulletWidth &&
      x+myImage.width >= bullet.x) {
      remove = true;
      addPowerUp();
    }
  }
  void addPowerUp() {
    if (type == "P_Mul" && !effect3Added) {
      BulletLimit *= 2;
      effect3Added = true;
      println("PowerUp! Amunition doubled!");
      Upgrade.play();
    } else if (type == "P_Big" && !effect2Added) {
      BulletType = "bigFireball";
      BulletHeight *= 2;
      BulletWidth *= 2;
      effect2Added = true;
      println("PowerUp! Size doubled!");
      Upgrade.play();
    } else if (type == "P_Speed" && !effect1Added) {
      BulletSpeed *= 2;
      effect1Added = true;
      println("PowerUp! Speed doubled!");
      Upgrade.play();
    }
  }
}
