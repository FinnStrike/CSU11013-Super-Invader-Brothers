class Shield {
  int x;
  int y;
  boolean destroyed;
  PImage myImage;

  Shield(int xpos, int ypos, PImage shieldImage)
  {
    x = xpos;
    y = ypos;
    destroyed = false;
    myImage = shieldImage;
  }
  void draw()
  {
    image(myImage, x, y);
  }
  void damage() {
    myImage = loadImage("Shield2.png");
  }
}
