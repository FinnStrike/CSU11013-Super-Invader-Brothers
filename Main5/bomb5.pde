class Bomb {
  float x;
  float y;
  float dy;
  PImage myImage;

  Bomb(float xpos, float ypos, PImage image) {
    x = xpos;
    y = ypos;
    dy = 2;
    myImage = image;
  }
  void move() {
    y = y + dy;
  }
  void draw() {
    if (points < NUMBER_OF_ALIENS)
      image(myImage, x, y);
  }
  boolean collideBomb(Player player) {
    if (y <= player.ypos+PLAYER_HEIGHT &&
      y+myImage.height >= player.ypos &&
      x <= player.xpos+PLAYER_WIDTH &&
      x+myImage.width >= player.xpos) {
      return true;
    } else return false;
  }
  boolean offScreen() {
    if (y > SCREENY)
      return true;
    else return false;
  }
}
