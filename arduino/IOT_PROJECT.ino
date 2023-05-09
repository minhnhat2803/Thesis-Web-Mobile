#include <Servo.h> 

String getSignal;
int LED_INFO = A0;
int LED_BUITLIN = 13;

Servo myservo;
int pos = 0;

void setup() {
  pinMode(LED_INFO, OUTPUT);
  pinMode(LED_BUITLIN, OUTPUT);
  myservo.attach(9);
  Serial.begin(9600);
  Serial.setTimeout(10);
}

void loop() {}

void serialEvent() {
  getSignal = Serial.readStringUntil('\n');

  if (getSignal == "true") {
    digitalWrite(LED_INFO, HIGH);
    digitalWrite(LED_BUILTIN, HIGH);
    for(pos = 91; pos>=1; pos-=1) {                                
      myservo.write(pos);              
      delay(15);                       
    } 
    delay(3500);
    for(pos = 0; pos < 91; pos += 1) {                                 
      myservo.write(pos);              
      delay(5);                       
    } 
    digitalWrite(LED_INFO, LOW);
    delay(2500);
  }
}


