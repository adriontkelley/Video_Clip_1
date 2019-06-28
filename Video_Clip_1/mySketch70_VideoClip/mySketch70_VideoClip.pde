///modified by Adrion T. Kelley 2018

import processing.video.*;

Movie video;



//PImage img;
int cellSize=8;
int cols, rows;

int count=10000;
Recta[] myRect;
boolean boxStop=false;

void setup() {
  size(568, 320, P3D);
  //img = loadImage("006.jpg");
  
   video = new Movie(this, "1.mov");
  
  video.loop();
  video.play();
  
  
  cols = height/cellSize;
  rows = width/ cellSize;
  noStroke();
  myRect = new Recta[count];
  for(int i=0; i<count; i++){
  	myRect[i] = new Recta(random(width), random(height), random(1, 5));
  }
}

void draw() {
  background(0);
  
  video.read();
  video.loadPixels();
  
  
  
	if(boxStop){
		for(int i=0; i<count; i++){
			myRect[i].stop();
		}	
	} else {
		for(int i=0; i<count; i++){
			myRect[i].update();
			myRect[i].show();
		}
	}
}

void keyPressed(){
	println("Pressed");
	boxStop=true;
}

class Recta{
	float _width;
	float rot;
	PVector pos;
	PVector speed;

	Recta(float tx, float ty, float wid){
		pos = new PVector(tx, ty);
		speed = new PVector(random(-.2,.2),random(-.2,.2));		
		_width = wid;
		rot=random(0,360);
	}
	void update(){
		pos.add(speed);
		if(pos.x<0||pos.x>width){
			pos.x*=-1;
		}
		if(pos.y<0||pos.y>height){
			pos.y*=-1;
		}
	}

	void show(){
  
  
		color c = video.get( floor(pos.x), floor(pos.y) );
		fill(c);
		pushMatrix();
		rectMode(CENTER);
		translate(pos.x, pos.y);
		rotate(radians(rot+frameCount));
		rect(0, 0, _width, _width);
		popMatrix();	
	}
	void stop(){
		pos.x=0;
		pos.y=0;
	}
}