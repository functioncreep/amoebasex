import controlP5.*;
import oscP5.*;
import netP5.*;

ControlP5 cp5;
OscP5 oscP5;
NetAddress amoebaTwo;

String input = "";
String[] history = new String[50];

void setup() {
  size(500, 500);
  
  PFont font = createFont("courier", 20);
  
  // fill history with empty strings
  for (int i = 0; i < history.length; i++) {
    history[i] = "";
  }
  
  cp5 = new ControlP5(this);
  int inputWidth = width;
  int inputHeight = 40;
  
  cp5.addTextfield("input")
     .setPosition(0, height - inputHeight)
     .setSize(inputWidth, inputHeight)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,255))
     ;
     
  textFont(font);
  
  //OSC stuff:
  // start oscP5, listening on 12000
  oscP5 = new OscP5(this,12000);
  
  // address to send messages to
  amoebaTwo = new NetAddress("127.0.0.1", 7771);
}

void draw() {
  background(160);
  
  // starting x and y pos for text
  int posX = 5; 
  int posY = 25;
  
  // loop thru items and draw
  for (int i = 0; i < history.length; i++) {
    text(history[i], posX, posY);
    //println(history[i]);
    posY += 30;
  }
}

void shiftText(String _input) {
  String[] inBuf = new String[history.length];  // buffer to copy array into
  
  // copy history into buffer
  arrayCopy(history, inBuf);
  
  // right shift history by one
  for (int i = 0; i < history.length - 1; i++) {
    history[i + 1] = inBuf[i];
  }
  
  // add input to first object in history
  history[0] = _input;
}

// event handler... make specific to "input"?
void controlEvent(ControlEvent event) {
  if (event.isFrom(cp5.getController("input"))) {
    shiftText(input);
    
    // OSC message construction:
    OscMessage plasmid = new OscMessage("/pillae");
    plasmid.add(input);
    
    // send message:
    oscP5.send(plasmid, amoebaTwo);
  }
}