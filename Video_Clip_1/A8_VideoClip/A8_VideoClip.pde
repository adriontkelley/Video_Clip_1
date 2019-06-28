
///modified by Adrion T. Kelley 2018
import processing.video.*;

Movie video;


void setup() {
  size( 568, 320, P3D);
  //img = loadImage( "A8_1.png" );
  
  video = new Movie(this, "1.mov");
  
  video.loop();
  video.play();
  
  //background( 120 );
}



void draw() {
  //img.loadPixels();
  video.read();
  video.loadPixels();
  
  frameRate(120);
  
  
    for (int i = 0; i < 100; i++) {
      drawSquares();
    }
  /*
  if (keyPressed == true) {
    img = loadImage( "A8_2.png" );
  }
  else {
    img = loadImage( "A8_1.png" );
  }
  */
}


void drawSquares() {
  float x = random( width );
  float y = random( height );
  float z = random( 5, 12 );
  int loc = (int)x + (int)y * width;
  color kolor = video.pixels[loc];
  //noStroke();
  fill( kolor );
  rect( x, y, z, z );
}