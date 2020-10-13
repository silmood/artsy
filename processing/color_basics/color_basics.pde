// RGB Configuration
int red = 0;
int green = 0;
int blue = 0;

boolean redReverse = false;
boolean greenReverse = false;
boolean blueReverse = false;

// HSB Configuration
int hue = 0;
float saturation = 0;
float brightness = 0;
boolean hsbReverse = false;

int[] modes = {BLEND, ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN};
String[] modeLabels = {"BLEND", "ADD", "SUBTRACT", "DARKEST", "LIGHTEST", "DIFFERENCE", "EXCLUSION", "MULTIPLY", "SCREEN"};
int modeIndex = 0;

int diameter = 156;
float centerX;
float centerY;

void setup() {
  size(512, 512);
  noStroke();
  smooth();
  centerX = width / 2;
  centerY = height / 2;

  colorMode(HSB, 360, 100, 100);
}

void draw() {
  // background(red, green, blue);
  background(hue, saturation, brightness);

  blendMode(BLEND);
  fill(0);
  text(modeLabels[modeIndex], centerX, 30);

  blendMode(modes[modeIndex]);
  drawCircles();

  // calculateBackgroundRGB();
  calculateBackgroundHSB();
}

void mousePressed() {
  if(modeIndex < modes.length - 1) modeIndex++;
  else modeIndex = 0;
}

void drawCircles() {
  // fill(255 - red, 255 - green, 255 - blue, 150);
  fill(360 - hue, 100 - saturation , 100 - brightness, 150);
  ellipse(centerX, centerY, diameter, diameter);

  float aX = (diameter / 2) * cos(PI / 4) + centerX;
  float aY = (diameter / 2) * sin(PI / 4) + centerY;

  fill(abs(180 - hue), 100 - saturation , 100 - brightness, 150);
  ellipse(aX, aY, diameter, diameter);

  float bX = (diameter / 2) * cos((PI / 4) * 3) + centerX;
  float bY = (diameter / 2) * sin((PI / 4) * 3) + centerY;

  fill(abs(90 - hue), 100 - saturation , 100 - brightness, 150);
  ellipse(bX, bY, diameter, diameter);
}

void calculateBackgroundHSB() {
  hue = hue < 360 ? hue + 1 : 0;
  saturation = map(mouseY, 0, 512, 0, 100);
  brightness = map(mouseX, 0, 512, 0, 100);
}

void calculateBackgroundRGB() {
  red += redReverse ? -1 : 1;
  if(red % 2 == 0) green += greenReverse ? -1 : 1;
  if(red % 5 == 0) blue += blueReverse ? -1 : 1;

  if(red == 255) redReverse = true;
  else if (red == 0) redReverse = false;

  if(green == 255) greenReverse = true;
  else if (green == 0) greenReverse = false;

  if(blue == 255) blueReverse = true;
  else if (blue == 0) blueReverse = false;
}
