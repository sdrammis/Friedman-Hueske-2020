#define Cam1Pin 2
#define LED1Pin 3 // (baseline 405)
#define LED2Pin 4 // LED2 (470)
#define FrameTriggerbox4Pin 8// 
#define FrameTriggerbox5Pin 9//
#define FrameTriggerbox6Pin 10// 
#define FrameTriggerbox7Pin 11// 
#define FrameTriggerbox8Pin 12// 

const int frame_duration_ms = 53;
const int inter_frame_duration_ms = 13;
const int frameTriggerDelay_us = 1;

void setup() {
  // put your setup code here, to run once:
  pinMode(Cam1Pin, OUTPUT);
  digitalWrite(Cam1Pin, LOW);

  pinMode(LED1Pin, OUTPUT);
  digitalWrite(LED1Pin, LOW);

  pinMode(LED2Pin, OUTPUT);
  digitalWrite(LED2Pin, LOW);

  pinMode(FrameTriggerbox4Pin, OUTPUT);
  digitalWrite(FrameTriggerbox4Pin, LOW);

  pinMode(FrameTriggerbox5Pin, OUTPUT);
  digitalWrite(FrameTriggerbox5Pin, LOW);

  pinMode(FrameTriggerbox6Pin, OUTPUT);
  digitalWrite(FrameTriggerbox6Pin, LOW);

  pinMode(FrameTriggerbox7Pin, OUTPUT);
  digitalWrite(FrameTriggerbox7Pin, LOW);

  pinMode(FrameTriggerbox8Pin, OUTPUT);
  digitalWrite(FrameTriggerbox8Pin, LOW);

  //  //for test only
  //    pinMode(13, OUTPUT);
  //  digitalWrite(13, LOW);


  delay(10000);
}

void loop() {
  // put your main code here, to run repeatedly:
   for (int i = 0; i < 274; i++) {
//  for (int i = 0; i < 100; i++) {
    //  digitalWrite(13, HIGH);
    //  delay(1000);
    //    digitalWrite(13, LOW);


    digitalWrite(FrameTriggerbox4Pin, HIGH);
    digitalWrite(FrameTriggerbox5Pin, HIGH);
    delayMicroseconds(frameTriggerDelay_us);
    digitalWrite(FrameTriggerbox4Pin, LOW);
    digitalWrite(FrameTriggerbox5Pin, LOW);
    
    digitalWrite(FrameTriggerbox6Pin, HIGH);
    digitalWrite(FrameTriggerbox7Pin, HIGH);
    delayMicroseconds(frameTriggerDelay_us);
    digitalWrite(FrameTriggerbox6Pin, LOW);
    digitalWrite(FrameTriggerbox7Pin, LOW);
//    
    digitalWrite(FrameTriggerbox8Pin, HIGH);
    delayMicroseconds(frameTriggerDelay_us);
    digitalWrite(FrameTriggerbox8Pin, LOW);



    for (int j = 0; j < 100; j++) {

//      analogWrite(LED1Pin,160);
      digitalWrite(LED1Pin, HIGH);
      digitalWrite(Cam1Pin, HIGH);
      delay(frame_duration_ms);
      digitalWrite(Cam1Pin, LOW);
      digitalWrite(LED1Pin, LOW);
      delay(inter_frame_duration_ms);

//      analogWrite(LED2Pin,160);
      digitalWrite(LED2Pin, HIGH);
      digitalWrite(Cam1Pin, HIGH);
      delay(frame_duration_ms);
      digitalWrite(Cam1Pin, LOW);
      digitalWrite(LED2Pin, LOW);
      delay(inter_frame_duration_ms);
    }

  }

  delay(3600000);




}
