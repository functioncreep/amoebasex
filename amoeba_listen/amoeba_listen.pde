// TODO: add user name input
// TODO: add node "handshake" function?
// TODO: fix text-draw doubling issue

import controlP5.*;
import oscP5.*;
import netP5.*;

ControlP5 cp5;
OscP5 oscP5;
NetAddress amoebaTwo;

String input = "";
String myName = null;
ArrayList<History> history =  new ArrayList<History>();

void setup() {
  size(500, 500);

  PFont font = createFont("courier", 20);

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

  // address to send messages to
  amoebaTwo = new NetAddress("127.0.0.1", 7771);

  // "plug" pillae message into function
  oscP5.plug(this, "pillae", "/pillae");
}

void draw() {
  background(160);

  // starting x and y pos for text
  int posX = 5;
  int posY = 25;

  if (myName == null) {
    text("Enter your name:", posX, width - 55);
  } else {
    // loop thru items and draw
    for (History entry : history) {
      if (entry.self == true) {
        textAlign(LEFT);
        fill(255, 255, 255);
        text(entry.text, posX, posY);
        // println(entry.text + " " + entry.self);
      } else if (entry.self == false) {
        textAlign(RIGHT);
        fill(0, 0, 0);
        text(entry.text, width - posX, posY);
        // println(entry.text + " " + entry.self);
      }

      // text(history[i], posX, posY);
      //println(history[i]);
      posY += 30;
    }
  }
}

void addText(String _input, boolean _self) {
  history.add(0, new History(_input, _self));

  if (history.size() >= 50) {
    history.remove(49);
  }
}

// event handler... make specific to "input"?
void controlEvent(ControlEvent _event) {
  if (_event.isFrom(cp5.getController("input"))) {
    // if username hasn't been set, set
    if (myName == null) {
      myName = input;
    } else {
      addText(input, true);
      // OSC message construction:
      OscMessage plasmid = new OscMessage("/pillae");
      // attach username then message content
      plasmid.add(myName);
      plasmid.add(input);
      // send message:
      oscP5.send(plasmid, amoebaTwo);
    }
  }
}

// pillae function
public void pillae(String _user, String _plasmid) {
  // check if received message comes from self (there must be a better way to implement...)
  if (_user.equals(myName)) {
    println("me: " + _plasmid);
  } else {
    println(_user + ": " + _plasmid);
    addText(_plasmid, false);
  }
}

// OSC event handler
void oscEvent(OscMessage _message) {
  // print the address pattern and the typetag of the received OscMessage
  //print("### received an osc message.");
  //print(" addrpattern: " + _message.addrPattern());
  //println(" contents: " + _message.typetag());
}

class History
{
  public String text;
  public boolean self;

  public History(String _text, boolean _self) {
    text = _text;
    self = _self;
  }

  // testing
  public void dump() {
    println("text: " + text);
    println("self?: " + self);
  }
}
