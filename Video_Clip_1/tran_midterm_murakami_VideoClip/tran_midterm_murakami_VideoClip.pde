///modified by Adrion T. Kelley 2018


import processing.video.*;

Movie video;




//PImage img;
PImage img2;

void setup() {
  size(568, 320, P3D);
  video = new Movie(this, "1.mov");
  
  video.loop();
  video.play();
  
  
  
  
  //img = loadImage("murakami3.jpg");
  img2 = loadImage("2.jpg");
  imageMode(CENTER);
  noStroke();
  background(255);
  
  frameRate(120);
}

void draw() { 
  
  
  
video.read();
  video.loadPixels();


  int i = 0;
  while (i <= 25) {
    drawPoint();
    i = i +1;
  }
}

void drawPoint() {

  
  int x = int(random(video.width));
  int y = int(random(video.height));
  color pix = video.get(x, y);

  float value = brightness (pix);
  int i = round( map (value, 0, 255, 0, 700*700-1) );
  color c2 = img2.pixels[i];


  fill(c2, 128);
  rect(x, y, random(0,15), random(0,15));
}