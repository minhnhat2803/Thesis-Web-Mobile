#include <Servo.h> 

String inByt;
int LED_INFO = A0;
int LED_BUITLIN = 13;

const int echo = 7;     // pin echo
const int trig = 8;     // pin trig

Servo myservo;
int pos = 0;

void setup() {
  pinMode(LED_INFO, OUTPUT);
  pinMode(LED_BUITLIN, OUTPUT);
  myservo.attach(9);
  pinMode(trig,OUTPUT);   
  pinMode(echo,INPUT);    
  Serial.begin(9600);
  Serial.setTimeout(10);
}

void loop() {
    unsigned long duration; 
    int distance;           
    
    digitalWrite(trig, 0);   
    delayMicroseconds(2);
    digitalWrite(trig, 1);   
    delayMicroseconds(5);    
    digitalWrite(trig, 0);   
    
    duration = pulseIn(echo,HIGH);  
    distance = int(duration/2/29.412);
    
    Serial.println(distance);
    delay(20000);
}

void serialEvent() {
    inByt = Serial.readStringUntil('\n');
    if (inByt == "true") {
      digitalWrite(LED_BUILTIN, HIGH);
      digitalWrite(LED_INFO, HIGH);
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