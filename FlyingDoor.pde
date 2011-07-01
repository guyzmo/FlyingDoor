/**
 *  @title:  Simple stupide door control system
 *  @author: Guyzmo <guyzmo at hackable-devices dot org>
 *  @see:    http://github.com/guyzmo/LeLoopRFID
 *  @see:    http://wiki.leloop.org/index.php/LeLoopRFID
 *  
 *  Based on LeLoopRFID
 */

#include <Ethernet.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 83, 30 };

const int PIN_RED=7;
const int PIN_DOOR=6;
const int PIN_SND=8;

Server server = Server(23);

void coin_beep() {
    tone(PIN_SND, 988);
    delay(80);
    tone(PIN_SND, 1319);
    delay(300);
    noTone(PIN_SND);
}

void mushroom_beep() {
    tone(PIN_SND, 165);
    delay(80);
    tone(PIN_SND, 196);
    delay(80);
    tone(PIN_SND, 329);
    delay(80);
    tone(PIN_SND, 262);
    delay(80);
    tone(PIN_SND, 277);
    delay(80);
    tone(PIN_SND, 392);
    delay(80);
    noTone(PIN_SND);
}

void set_red(){
    digitalWrite(PIN_RED,HIGH);
}
void reset_leds(){
    digitalWrite(PIN_RED,LOW);
}

void ether_setup()
{
  set_red();
  Serial.println("ether init...");
  Ethernet.begin(mac, ip);
  server.begin();
  
  delay(1000);
  reset_leds();
}

void open_door() {
    Serial.println("Door Opened");
    set_red();
    digitalWrite(PIN_DOOR, HIGH);
    coin_beep();
    delay(500);
    digitalWrite(PIN_DOOR, LOW);
    reset_leds();
}

void setup()
{
  pinMode(3,INPUT);
  digitalWrite(3,HIGH);

  pinMode(6,OUTPUT);
  pinMode(7,OUTPUT);
  pinMode(8,OUTPUT);

  Serial.begin(19200);

  noTone(PIN_SND);

  ether_setup();
  reset_leds();

  mushroom_beep();
  delay(500);
}

void loop()
{
    char c;
    Serial.println("1");
    Client client = server.available();
    if (client.connected()) {
        // read bytes from the incoming client and write them back
        // to any clients connected to the server:
        if (client.available())
            c = client.read();
            if (c == '1') {
                server.write("OPEN\n");
                Serial.println("2");
                open_door();
                server.write("CLOSE\n");
            }
    }
}

