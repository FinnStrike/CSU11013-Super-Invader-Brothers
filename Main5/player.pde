class Player {
  int xpos;
  int ypos;
  int exno;
  PImage myImage;

  Player(int screen_y, PImage playerImage)
  {
    xpos = SCREENX/2;
    ypos = screen_y;
    exno = 1;
    myImage = playerImage;
  }
  void move(int x, int y) {
    if (!gameStart) {
      myImage = loadImage("player_front.png");
      xpos = x;
      ypos = y;
    } else if (points < NUMBER_OF_ALIENS) {
      myImage = loadImage("player_back.png");
      if (x>SCREENX-PLAYER_WIDTH) xpos = SCREENX-PLAYER_WIDTH;
      else {
        xpos = x;
        ypos = y;
      }
    }
  }
  void draw()
  {
    image(myImage, xpos, ypos);
  }
  void win() {
    if (points >= NUMBER_OF_ALIENS)
    {
      myImage = loadImage("player_front.png");
      gameWin = true;
    }
  }
  void explode() {
    myImage = loadImage("player_explode" + exno + ".png");
    if (exno < 5)
      exno++;
  }
}
