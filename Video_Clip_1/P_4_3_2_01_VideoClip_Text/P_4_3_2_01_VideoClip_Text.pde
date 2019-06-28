///This sketch was modified by undergrad Adrion T. Kelley for University of Oregon Art & Technology (UOAT) 2017
///adrionk@uoregon.edu


////This sketch requires the video Processing library


// P_4_3_2_01.pde
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
 * pixel mapping. each pixel is translated into a new element (letter)
 * 
 * KEYS
 * 1                 : toogle font size mode (dynamic/static)
 * 2                 : toogle font color mode (color/b&w)
 * arrow up/down     : maximal fontsize +/-
 * arrow right/left  : minimal fontsize +/-
 * s                 : save png
 * p                 : save pdf
 */

import processing.pdf.*;
import java.util.Calendar;
import processing.video.*;

Movie video;

boolean savePDF = false;

String inputText = "REDRUM   ";
float fontSizeMax = 20;
float fontSizeMin = 10;
float spacing = 12; // line height
float kerning = 0.5; // between letters

boolean fontSizeStatic = false;
boolean blackAndWhite = false;

PFont font;
//PImage img;

void setup() {
  size(1280, 720, P3D);
  smooth(); 
  video = new Movie(this, "Jack Compressed.mov");
  
  video.loop();
  video.play();
  
  font = createFont("Times",10);
  
  //img = loadImage("pic.png");
  println(video.width+" x "+video.height);
}

void draw() {
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");
  
  frameRate(15);
 // image(video, -100, -100);
 
 
 video.read();
  video.loadPixels();

  background(0);
  textAlign(LEFT);
  //textAlign(LEFT,CENTER); //// also nice!

  float x = 0, y = 10;
  int counter = 0;

  while (y < height) {
    // translate position (display) to position (image)
    int imgX = (int) map(x, 0,width, 0,video.width);
    int imgY = (int) map(y, 0,height, 0,video.height);
    // get current color
    color c = video.pixels[imgY*video.width+imgX];
    int greyscale = round(red(c)*0.222 + green(c)*0.707 + blue(c)*0.071);

    pushMatrix();
    translate(x, y);

    if (fontSizeStatic) {
      textFont(font, fontSizeMax);
      if (blackAndWhite) fill(greyscale);
      else fill(c);
    } 
    else {
      // greyscale to fontsize
      float fontSize = map(greyscale, 0,255, fontSizeMax,fontSizeMin);
      fontSize = max(fontSize, 1);
      textFont(font, fontSize);
      if (blackAndWhite) fill(0);
      else fill(c);
    } 

    char letter = inputText.charAt(counter);
    text(letter, 0, 0);
    float letterWidth = textWidth(letter) + kerning;
    // for the next letter ... x + letter width
    x = x + letterWidth; // update x-coordinate
    popMatrix();

    // linebreaks
    if (x+letterWidth >= width) {
      x = 0;
      y = y + spacing; // add line height
    }

    counter++;
    if (counter > inputText.length()-1) counter = 0;
  }

  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}


void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
  if (key == 'p' || key == 'P') savePDF = true;
  // change render mode
  if (key == '1') fontSizeStatic = !fontSizeStatic;
  // change color stlye
  if (key == '2') blackAndWhite = !blackAndWhite;
  println("fontSizeMin: "+fontSizeMin+"  fontSizeMax: "+fontSizeMax+"   fontSizeStatic: "+fontSizeStatic+"   blackAndWhite: "+blackAndWhite);
}

void keyPressed() {
  // change fontSizeMax with arrowkeys up/down 
  if (keyCode == UP) fontSizeMax += 2;
  if (keyCode == DOWN) fontSizeMax -= 2; 
  // change fontSizeMin with arrowkeys left/right
  if (keyCode == RIGHT) fontSizeMin += 2;
  if (keyCode == LEFT) fontSizeMin -= 2; 

  //fontSizeMin = max(fontSizeMin, 2);
  //fontSizeMax = max(fontSizeMax, 2);
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}


/*
void movieEvent(Movie m) {
  m.read();
}

*/
