///This sketch was modified by undergrad Adrion T. Kelley for University of Oregon Art & Technology (UOAT) 2017
///adrionk@uoregon.edu



////This sketch requires the video Processing library






// P_4_3_1_02.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * pixel mapping. each pixel is translated into a new element (svg file).
 * take care to sort the svg file according to their greyscale value.
 * see also "_4_3_1_02_analyse_svg_grayscale.pde" 
 * 
 * KEYS
 * s                   : save png
 * p                   : save pdf
 */
 
import processing.pdf.*;
import java.util.Calendar;
import processing.video.*;

Movie video;

boolean savePDF = false;

PShape[] shapes;
int shapeCount = 0;

//PImage img;

void setup() {
  size(1280, 720); 
  smooth();
  video = new Movie(this, "Scarecrow Compressed.mov");
  
  video.loop();
  video.play();
  
  println(video.width+" x "+video.height);
  
  //img = loadImage("pic.png");
  //println(img.width+" x "+img.height);

  // ------ load shapes ------
  // replace this location with a folder on your machine or use selectFolder()
  //File dir = new File(selectFolder("choose a folder with svg files ..."));
  File dir = new File(sketchPath(""),"data");
  if (dir.isDirectory()) {
    String[] contents = dir.list();
    shapes = new PShape[contents.length]; 
    for (int i = 0 ; i < contents.length; i++) {
      // skip hidden files and folders starting with a dot, load .svg files only
      if (contents[i].charAt(0) == '.') continue;
      else if (contents[i].toLowerCase().endsWith(".svg")) {
        File childFile = new File(dir, contents[i]);
        println(childFile.getPath());        
        shapes[shapeCount] = loadShape(childFile.getPath());
        shapeCount++;             
      }
    }
  }
  
  println(shapeCount);
}

void draw() {
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");
  background(255);
  
  frameRate(24);
  image(video, -1000, -1000);
  
  //video.read();
  //video.loadPixels();

  float mouseXFactor = map(mouseX, 0,width, 0.05,1);
  float mouseYFactor = map(mouseY, 0,height, 0.05,1);

  for (int gridX = 0; gridX < video.width; gridX++) {
    for (int gridY = 0; gridY < video.height; gridY++) {
      // grid position + tile size
      float tileWidth = width / (float)video.width;
      float tileHeight = height / (float)video.height;
      float posX = tileWidth*gridX;
      float posY = tileHeight*gridY;

      // get current color
      color c = video.pixels[gridY*video.width+gridX];
      // greyscale conversion
      int greyscale = round(red(c)*0.222+green(c)*0.707+blue(c)*0.071);

      int gradientToIndex = round(map(greyscale, 0,255, 0,shapeCount-1));
      shape(shapes[gradientToIndex], posX,posY, tileWidth,tileHeight);
    }
  }

  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}

void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
  if (key == 'p' || key == 'P') savePDF = true;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}



void movieEvent(Movie m) {
  m.read();
}