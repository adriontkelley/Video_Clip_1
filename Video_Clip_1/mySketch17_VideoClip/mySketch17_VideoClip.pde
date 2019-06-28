///modified by Adrion T. Kelley 2018


import processing.video.*;


Movie video;




//PImage img;
  
int vSpace = 20;
int hSpace = 20;

float amplitudeHeight = vSpace/2;
float precision = hSpace/15;

void setup() {
  size(568, 320, P2D); 
  //img = loadImage("1.jpeg");
  video = new Movie(this, "1.mov");
  
  video.loop();
  video.play();
  
  
  
  
} 

void draw() {
  background(0);  
  
  video.read();
  video.loadPixels();
  
  
  noFill();
  stroke(255);
  
  
  float frequency = -frameCount;
  for (int y = vSpace; y < height-vSpace*.5; y+=vSpace) {
    beginShape();
    int x = 0;
    float prevAmplitude = 0;
    while (x < width) {
      float colorIntensity = video.get(int(x), int(y)) >> 16 & 0xFF;
      float amplitude = map(colorIntensity, 0, 255, 1, 0);
      for(int i=0; i<hSpace; i+=precision){
        float curAmpitude = lerp(prevAmplitude, amplitude, i/hSpace);
        x+=precision;
        frequency += curAmpitude;
      	vertex(x, y+ sin(frequency)*curAmpitude*amplitudeHeight);
      }
      prevAmplitude = amplitude;
    }
    endShape();
  }
}