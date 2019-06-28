// Converts the image from gray scale into binary and then finds the contour around each binary blob.
// Internal and external contours of each blob are drawn a different color.


///modified by Adrion T. Kelley 2018

import boofcv.processing.*;
import boofcv.struct.image.*;
import processing.video.*;

Movie video;

PImage input;
PImage imgContour;
PImage imgBlobs;

void setup(){
  
  size(568, 320, P3D);
  
  
  video = new Movie(this, "1.mov");
  
  video.loop();
  video.play();

  // img which will be sent to detection (a smaller copy of the cam frame);
  input = new PImage(568,320);
  //frameRate(10);
  

 

  //surface.setSize(input.width, input.height);
}

void draw() {
  background(0);
  
  video.read();
  video.loadPixels();
  
  
  
  

    //image(cam,-1000,-1000,width,height);
    input.copy(video, 0, 0, video.width, video.height, 
        0, 0, input.width, input.height);
        
        
         // Convert the image into a simplified BoofCV data type
  SimpleGray gray = Boof.gray(input,ImageDataType.F32);

  // Threshold the image using its mean value
  double threshold = gray.mean();

  // find blobs and contour of the particles
  ResultsBlob results = gray.threshold(threshold,true).erode8(1).contour();

  // Visualize the results
  imgContour = results.getContours().visualize();
  imgBlobs = results.getLabeledImage().visualize();
  
  
  //surface.setSize(input.width, input.height);
  
  if( mousePressed ) {
    image(imgBlobs, 0, 0);
  } else {
    image(imgContour, 0, 0);
  }
  //saveFrame("output/Art_####.png");
  
}