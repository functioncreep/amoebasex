import controlP5.*;
import oscP5.*;
import netP5.*;

ControlP5 cp5;
OscP5 oscP5;
NetAddress amoebaOne;

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
  
  // OSC stuff:
  
  // start OscP5 listening on port 7771
  oscP5 = new OscP5(this, 7771);
  
  // "plug" pillae message into function
  oscP5.plug(this, "pillae", "/pillae");
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

// pillae function
public void pillae(String _plasmid) {
  println("Amoeba One would like to conjugate. Do you consent? (plasmid: " + _plasmid + ")");
}

// event handler... make specific to "input"?
void controlEvent(ControlEvent _event) {
  if (_event.isFrom(cp5.getController("input"))) {
    shiftText(input);
  }
}

// OSC event handler
void oscEvent(OscMessage _message) {
  // print the address pattern and the typetag of the received OscMessage
  //print("### received an osc message.");
  //print(" addrpattern: " + _message.addrPattern());
  //println(" contents: " + _message.typetag());
}