///This sketch was modified by undergrad Adrion T. Kelley for University of Oregon Art & Technology (UOAT) 2017
///adrionk@uoregon.edu


////This sketch requires the opencv_processing and video Processing libraries



import gab.opencv.*;
import processing.video.*;


Movie video;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

void setup() {
   size(568, 320, P3D);
  video = new Movie(this, "1.mov");
  
  opencv = new OpenCV(this, 568, 320);
  
  video.loop();
  video.play();
  
  frameRate(30);

  

  
}

void draw() {
  //scale(0.5);
  //movie.speed(1);
  
  contours = opencv.findContours();
  opencv.loadImage(video);
  opencv.gray();
  opencv.threshold(70);
  image(opencv.getOutput(), 0, 0);
  
  noFill();
  strokeWeight(3);
  
  for (Contour contour : contours) {
    stroke(0, 255, 0);
    contour.draw();
    
     stroke(255, 0, 0);
    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();
  }
  
}


void movieEvent(Movie m) {
  m.read();
}
