#include <Servo.h> 

String inByt;
int LED_INFO = A5;
int LED_A0 = A0;
int LED_A1 = A1;
int LED_BUITLIN = 13;

const int echo = 7;     // chân echo của HC-SR04
const int trig = 8;     // chân trig của HC-SR04

Servo myservo;
int pos = 0;

void setup() {
  pinMode(LED_INFO, OUTPUT);
  pinMode(LED_A0, OUTPUT);
  pinMode(LED_A1, OUTPUT);
  pinMode(LED_BUITLIN, OUTPUT);
  myservo.attach(9);
  pinMode(trig,OUTPUT);   // chân trig sẽ phát tín hiệu
  pinMode(echo,INPUT);    // chân echo sẽ nhận tín hiệu
  Serial.begin(9600);
  Serial.setTimeout(10);
}

void loop() {
  digitalWrite(LED_A0, HIGH);

  unsigned long duration; // biến đo thời gian
  int distance;           // biến lưu khoảng cách
  
  digitalWrite(trig, 0);   // tắt chân trig
  delayMicroseconds(2);
  digitalWrite(trig, 1);   // phát xung từ chân trig
  delayMicroseconds(5);    // xung có độ dài 5 microSeconds
  digitalWrite(trig, 0);   // tắt chân trig
  
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
      digitalWrite(LED_A1, HIGH);
      delay(5000);
      digitalWrite(LED_A1, HIGH);
    }
}