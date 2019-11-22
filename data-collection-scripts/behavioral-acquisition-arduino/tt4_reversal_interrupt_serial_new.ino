
#define DebugSerial 0 /* Set to 0 for experiments, 1 only when debuging with serial terminal to see english messages */

#include <Arduino.h>

#include <SoftwareSerial.h>       /* for serial comm to soundboard */
#include <Adafruit_Soundboard.h>  /* for control of soundboard */


#include <Servo.h> 
Servo myservo;  // create servo object to control a servo 
// a maximum of eight servo objects can be created 
int pos = 0;    // variable to store the servo position 

///////////////////////////////////
// variables already defined //
///////////////////////////////////

int servoLowPos = 135;
int servoHighPos = 145;

const unsigned long rewardDeliveryDurationMsec = 90;

const int nLick1=3;
const int nLick2=5;

const int maxTrialNumber = 150;
const int maxRewardNumber=0;
unsigned long maxSessionDurationMsec = 3600000;

unsigned long toneDurationMsec          =  2000;
unsigned long afterToneDelayMsec        =  1;
unsigned long afterDecisionDelayMsec    = 1;
unsigned long reponsePeriodDurationMsec = 1000;
unsigned long consumptionPeriodMsec = 4000;
int toneOneFreq                         = 4000;
int toneTwoFreq                         = 8000;
unsigned long itiMinDurationMsec        = 6000;
unsigned long itiMaxDurationMsec        = 14000;
unsigned long lightDurationMsec         = 10000;

//////////////////////////////////////////////////////////
// DECLARATION OF STATEs AND EVENTS
//////////////////////////////////////////////////////////
#define stateITI                 1
#define stateToneOn              2
#define stateDelayAfterTone      3
#define stateResponsePeriod      4
#define stateDelayAfterDecision  5
#define stateLightOn             6
#define stateWaitingFirstLick    7
#define stateIRI                 8
#define stateExpDone             9



// 1: for Reward and 0 for Reward and Light
int trialType = 0;
int trialTypeSize = 300;
int trialTypeArray[300];

////////////////////////////////////////////////      
int ledVoltage_mv = 5000;


int protocol = 1;

////////////////////////////////////////
// variables used by the program only //
////////////////////////////////////////

//to establish a connection with Processing
int incomingByte;
boolean processingIsReady=false;

int i_loop = 0;
int nb_loop = 10;
//CODY!
int nInterrupts=0;
//Time Measurment
unsigned long currentTimeMsec = 0; // current time
unsigned long previousTimeMsec = 0; // current time
unsigned long SessionStartTime = 0;

unsigned long delay1 = 0;

// Arduino Digital Output-Pins
#define lickoPin      A0
#define servoPin      8
#define solenoidPin   10
#define ledMatrixPin  5
const byte interruptPin = 3;

#define evt_LICK  1
#define evt_EOD  2 //End Of Delay
#define evt_INTERRUPT  3 //End Of Delay


//JW 12/2018///////////////
/* software serial pins for soundboard control */
#define SFX_TX    7
#define SFX_RX    6
#define SFX_RST   4
/////////////////
SoftwareSerial ss = SoftwareSerial(SFX_TX, SFX_RX);
Adafruit_Soundboard sfx = Adafruit_Soundboard(&ss, NULL, SFX_RST);

int state = 0;
int event = 0;

boolean expDone=false;
boolean quenchingDone = false;
boolean already_licking=false;
boolean led_is_on=false;
boolean response_made=false;
boolean lick_first_lick_happened=false;
unsigned long lastLickTime=0;
int nLicksDuringDecision = 0;
int nDrops = 0;
int lightIntensityPWM = 0;

//////////////////////////////////////////////////////////
int nTrials  = 0;
int nRewards = 0;
int nLights = 0;
int consumptionLickCounter = 0;

//-------------------------------------------
//TTL EVENT TYPE //SERIAL CODE FOR PROCESSING
//-------------------------------------------
//-------------------------------------------
//TTL EVENT TYPE //SERIAL CODE FOR PROCESSING
//-------------------------------------------
#define TTL_EVT_PROGRAM_VERSION           1
#define TTL_EVT_MAX_TRIAL_NUMBER          2
#define TTL_EVT_MAX_REWARD_NUMBER         3
#define TTL_EVT_MAX_SESSION_DURATION      4
#define TTL_EVT_EXPERIMENT_START          5
#define TTL_EVT_EXPERIMENT_STOP           6
#define TTL_EVT_TRIAL_START               7
#define TTL_EVT_TRIAL_STOP                8
#define TTL_EVT_ITI_ON                    9
#define TTL_EVT_ITI_OFF                   10
#define TTL_EVT_ITI_MIN                   11
#define TTL_EVT_ITI_MAX                   12
#define TTL_EVT_LICK                      13
#define TTL_EVT_SOLENOID_ON               14
#define TTL_EVT_SOLENOID_DURATION         15
#define TTL_EVT_SOLENOID_OFF              16
#define TTL_EVT_LED_ON                    17
#define TTL_EVT_LED_PWM                   18
#define TTL_EVT_LED_DURATION              19
#define TTL_EVT_LED_OFF                   20
#define TTL_EVT_TONE01_ON                  21
#define TTL_EVT_TONE01_FREQ                22
#define TTL_EVT_TONE01_DURATION            23
#define TTL_EVT_TONE01_OFF                 24
#define TTL_EVT_TONE02_ON                  25
#define TTL_EVT_TONE02_FREQ                26
#define TTL_EVT_TONE02_DURATION            27
#define TTL_EVT_TONE02_OFF                 28
#define TTL_EVT_STATE                     29
#define TTL_EVT_EVENT                     30
#define TTL_EVT_CORRECT_REPONSE           31
#define TTL_EVT_INCORRECT_RESPONSE        32
#define TTL_EVT_OMISSION                  33
#define TTL_EVT_ITI_DURATION              34
#define TTL_EVT_EOD                       35
#define TTL_EVT_STIM_TYPE                 36
#define TTL_EVT_STIM_ON                   37
#define TTL_EVT_STIM_DURATION             38
#define TTL_EVT_STIM_OFF                  39
#define TTL_EVT_BLOCK_SIZE                40
#define TTL_EVT_THRESHOLD                 41
#define TTL_EVT_LIGHT_INTENSITY_START     42
#define TTL_EVT_LIGHT_INTENSITY_STEP      43
#define TTL_EVT_NOLIGHT_NTRIALS           44

#define TTL_EVT_MEGA_STATE                45
#define TTL_EVT_SLOW_SEARCH_STEP          46
#define TTL_EVT_FAST_SEARCH_STEP          47
#define TTL_EVT_BASELINE_THRESHOLD        48
#define TTL_EVT_SLOW_SEARCH_THRESHOLD     49
#define TTL_EVT_FAST_SEARCH_THRESHOLD     50
#define TTL_EVT_BASELINE_SIZE             51
#define TTL_EVT_SLOW_SEARCH_SIZE          52
#define TTL_EVT_FAST_SEARCH_SIZE          53
#define TTL_EVT_SLOW_SEARCH_STARTING_POINT  54
#define TTL_EVT_NSUCC_TEST  55

#define TTL_EVT_LED_VOLTAGE_MV  56
#define TTL_EVT_OFFER_ACCEPTED  57
#define TTL_EVT_OFFER_REJECTED  58
#define TTL_EVT_AFTERTONEDELAYMSEC  59
#define TTL_EVT_RESPONSEDURATIONMSEC  60

#define TTL_EVT_DELAYBEFORETONEMSEC  61
#define TTL_EVT_DELAYAFTEROFFERMSEC  62

#define TTL_EVT_SERVOPOSITION  63

#define TTL_EVT_AFTERDECISIONDELAYMSEC  64
#define TTL_EVT_CONSUMPTIONPERIODMSEC   65;
#define TTL_EVT_CONSUMPTIONLICKNUMBER   66
#define TTL_EVT_TRIALTYPE               67
#define TTL_EVT_MAXWAITFORFIRSTLICKMSEC  68

#define TTL_EVT_QUENCHINGPERIODMSEC   69
#define TTL_EVT_QUENCHINGLICKNUMBER   70
#define TTL_EVT_REST_ON   71
#define TTL_EVT_QUENCHING_ON   72
#define TTL_BLOCK_NUMBER  73
#define TTL_CURRENT_BLOCK_NUMBER  74

#define TTL_CUE_LIGHT_INTENSITY_1    75
#define TTL_CUE_LIGHT_INTENSITY_2    76
#define TTL_OFFER_LIGHT_INTENSITY_1  77
#define TTL_OFFER_LIGHT_INTENSITY_2  78
#define TTL_CUE_LIGHT_DURATION_1     79
#define TTL_CUE_LIGHT_DURATION_2     80
#define TTL_OFFER_LIGHT_DURATION_1   81
#define TTL_OFFER_LIGHT_DURATION_2   82

#define TTL_EVT_OPTO_ON                    83
#define TTL_EVT_OPTO_OFF                  84
#define TTL_EVT_OPTO_POWER                 85
#define TTL_EVT_OPTO_WAVELENGTH            86

#define TTL_EVT_REWARD_DURATION_1   87
#define TTL_EVT_REWARD_DURATION_2   88

#define TTL_EVT_NLICK_TOT   89
#define TTL_EVT_NLICK_CURRENT   90

#define TTL_EVT_NLICK_DURING_DECISION     91
#define TTL_EVT_NDROPS                    92

#define TTL_EVT_TONE3_ON                  93
#define TTL_EVT_TONE3_FREQ                94
#define TTL_EVT_TONE3_DURATION            95
#define TTL_EVT_TONE3_OFF                 96


#define TTL_EVT_OFFER1_REW                97
#define TTL_EVT_OFFER1_LIGHT              98
#define TTL_EVT_OFFER2_REW                99
#define TTL_EVT_OFFER2_LIGHT              100
#define TTL_EVT_OFFER3_REW                101
#define TTL_EVT_OFFER3_LIGHT              102

#define TTL_EVT_INTERRUPT                 103

#define TTL_EVT_MORPH05_ON                    104 
#define TTL_EVT_MORPH25_ON                    105 
#define TTL_EVT_MORPH35_ON              1const 06 
#define TTL_EVT_MORPH65_ON              107 
#define TTL_EVT_MORPH75_ON              108 
#define TTL_EVT_MORPH95_ON              109 
#define TTL_EVT_MORPH05_FREQ            110 
#define TTL_EVT_MORPH25_FREQ            111 
#define TTL_EVT_MORPH35_FREQ            112 
#define TTL_EVT_MORPH65_FREQ            113 
#define TTL_EVT_MORPH75_FREQ            114 
#define TTL_EVT_MORPH95_FREQ            115 
#define TTL_EVT_MORPH05_OFF             116 
#define TTL_EVT_MORPH25_OFF             117 
#define TTL_EVT_MORPH35_OFF             118 
#define TTL_EVT_MORPH65_OFF           119 
#define TTL_EVT_MORPH75_OFF           120 
#define TTL_EVT_MORPH95_OFF           121 
#define TTL_EVT_OFFER4_REW            122 
#define TTL_EVT_OFFER4_LIGHT          123 
#define TTL_EVT_OFFER5_REW            124 
#define TTL_EVT_OFFER5_LIGHT          125 
#define TTL_EVT_OFFER6_REW            126 
#define TTL_EVT_OFFER6_LIGHT          127 
#define TTL_EVT_MORPH00_ON            128 
#define TTL_EVT_MORPH00_FREQ          129 
//#define TTL_EVT_MORPH00_DURATION       130 
#define TTL_EVT_MORPH00_OFF           131 
#define TTL_EVT_MORPH100_ON            132 
#define TTL_EVT_MORPH100_FREQ          133 
//#define TTL_EVT_MORPH100_DURATION       134 
#define TTL_EVT_MORPH100_OFF           135 
#define TTL_EVT_DET0420_ON            136 
#define TTL_EVT_DET0440_ON            137 
#define TTL_EVT_DET0460_ON            138 
#define TTL_EVT_DET0480_ON            139 
#define TTL_EVT_DET0820_ON            140 
#define TTL_EVT_DET0840_ON            141 
#define TTL_EVT_DET0860_ON            142 
#define TTL_EVT_DET0880_ON            143 
#define TTL_EVT_DET1220_ON            144 
#define TTL_EVT_DET1240_ON            145 
#define TTL_EVT_DET1260_ON            146 
#define TTL_EVT_DET1280_ON          147 


void setup() {



  //Defines Inputs and Outputs
  pinMode(solenoidPin, OUTPUT);
  digitalWrite(solenoidPin, LOW);
  pinMode(ledMatrixPin, OUTPUT);
  digitalWrite(ledMatrixPin, LOW);
  pinMode(interruptPin, INPUT_PULLUP);
  attachInterrupt(1, detect_interrupt_event, RISING);
  
/* JW unused audio hardware pins - we now use software control
//  pinMode(toneOnePin, OUTPUT);
//  digitalWrite(toneOnePin, HIGH);
//  pinMode(toneTwoPin, OUTPUT);
//  digitalWrite(toneTwoPin, HIGH);
//  pinMode(ledMatrixPin, OUTPUT);
//  digitalWrite(ledMatrixPin, LOW);
//  pinMode(interruptPin, INPUT_PULLUP);
//  attachInterrupt(1, detect_interrupt_event, RISING);
*/

  randomSeed(analogRead(1));

  myservo.attach(8);  // attaches the servo on pin 8 to the servo object 
  myservo.write(servoHighPos);

  initTrialTypeArray();
  populateTrialTypeArray();

  Serial.begin(115200);          //  creates serial communication at 115200 bauds
  EstablishContact();

  event = 0;
  waitForCameraTrigger();
  event = 0;
  
  currentTimeMsec = millis();
  SessionStartTime = currentTimeMsec;
  i_loop = 0;

  // send parameters
  SendData(currentTimeMsec, TTL_EVT_PROGRAM_VERSION, protocol);
  SendData(currentTimeMsec, TTL_EVT_EXPERIMENT_START, 0);
  SendData(currentTimeMsec, TTL_EVT_ITI_MIN, itiMinDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_ITI_MAX, itiMaxDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_SOLENOID_DURATION, rewardDeliveryDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_MAX_TRIAL_NUMBER, maxTrialNumber);
  SendData(currentTimeMsec, TTL_EVT_MAX_REWARD_NUMBER, maxRewardNumber);
  SendData(currentTimeMsec, TTL_EVT_MAX_SESSION_DURATION, (int)(maxSessionDurationMsec/1000));
  SendData(currentTimeMsec, TTL_EVT_TONE01_DURATION, toneDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_TONE01_FREQ, toneOneFreq);
  SendData(currentTimeMsec, TTL_EVT_TONE02_DURATION, toneDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_TONE02_FREQ, toneTwoFreq);
  SendData(currentTimeMsec, TTL_EVT_LED_VOLTAGE_MV, ledVoltage_mv);

  SendData(currentTimeMsec, TTL_EVT_AFTERTONEDELAYMSEC, (int)afterToneDelayMsec);
  SendData(currentTimeMsec, TTL_EVT_RESPONSEDURATIONMSEC, (int)reponsePeriodDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_AFTERDECISIONDELAYMSEC, (int)afterDecisionDelayMsec);

  delay1 = random(itiMinDurationMsec,itiMaxDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_ITI_ON, 0);
  SendData(currentTimeMsec, TTL_EVT_ITI_DURATION, delay1);
  delay1 = currentTimeMsec + delay1;
  state = stateITI; 
  SendData(currentTimeMsec, TTL_EVT_STATE, state);

  SendData(currentTimeMsec, TTL_EVT_SERVOPOSITION, servoLowPos);
  myservo.write(servoLowPos);
  
  /*serial soundboard setup*/
  // softwareserial at 9600 baud
  ss.begin(9600);
  if (!sfx.reset()) {
    if(DebugSerial) Serial.println("SFX board Not found");
    while (1);
  }
  if(DebugSerial) {
    Serial.println("SFX board found");
    uint8_t files = sfx.listFiles();
    Serial.println("File Listing");
    Serial.println("========================");
    Serial.println();
    Serial.print("Found "); Serial.print(files); Serial.println(" Files");
    for (uint8_t f=0; f<files; f++) {
      Serial.print(f); 
      Serial.print("\tname: "); Serial.print(sfx.fileName(f));
      Serial.print("\tsize: "); Serial.println(sfx.fileSize(f));
    }
    Serial.println("========================"); }

}


void loop()
{
  currentTimeMsec = millis()-SessionStartTime;
  //////////////////////////////////////////////////////////////////////////////////////////
  if (event == evt_INTERRUPT)
  {
    nInterrupts++;
    SendData(currentTimeMsec,TTL_EVT_INTERRUPT,nInterrupts); 
  }
  event = 0;
  //////////////////////////////////////////////////////////////////////////////////////////
  if (event == 0)
  {
    detect_EOD();
  }
  //////////////////////////////////////////////////////////////////////////////////////////
  if (event == 0)
  {  
    detect_LICK();    
  }  
  //////////////////////////////////////////////////////////////////////////////////////////   

  switch (state)
  {
  case stateITI :
    switch (event)
    {
    case evt_EOD :
      SendData(currentTimeMsec, TTL_EVT_ITI_OFF, delay1);     
      expDone = checkIfExpDone();
      if(expDone)
      {
        state=stateExpDone;
        SendData(currentTimeMsec, TTL_EVT_STATE, state);
        SendData(currentTimeMsec, TTL_EVT_EXPERIMENT_STOP, 0);
      }
      else
      {
        if (state<stateExpDone)    
        {
          nTrials++;
          SendData(currentTimeMsec, TTL_EVT_TRIAL_START, nTrials); 
          trialType=trialTypeArray[nTrials-1];                 
          SendData(currentTimeMsec, TTL_EVT_TRIALTYPE, trialType); 

          if (trialType==0)
          {        
//            SendData(currentTimeMsec, TTL_EVT_TONE2_ON, 0);                  
//            digitalWrite(toneTwoPin, LOW);
              SendData(currentTimeMsec, TTL_EVT_TONE02_ON, 0);
              if(DebugSerial) Serial.println("!!!!!!!!!!!!!TONE02 On");
              myservo.detach(); 
              for (int i = 0; i<4; i++) 
              {
                sfx.playTrack("TONE02  WAV");
              } 
              myservo.attach(8);  
          }
          else
          {          
//            SendData(currentTimeMsec, TTL_EVT_TONE1_ON, 0);                  
//            digitalWrite(toneOnePin, LOW);
            SendData(currentTimeMsec, TTL_EVT_TONE01_ON, 0);
            if(DebugSerial) Serial.println("!!!!!!!!!!!!!TONE01 On");
            myservo.detach(); 
              for (int i = 0; i<4; i++) 
              {
                sfx.playTrack("TONE01  WAV");
              } 
              myservo.attach(8);  
          }          
          delay1 = toneDurationMsec + currentTimeMsec; 
          state=stateToneOn;
          SendData(currentTimeMsec, TTL_EVT_STATE, state);
        }
      }
      break;
    }
    break; 

  case stateToneOn:
    switch (event)
    {
    case evt_EOD : 
      if(DebugSerial) Serial.println("!!!!!!!!!!!!!!!!!Tone Off");
      /*
      uint32_t current, total;
      if (! sfx.trackTime(&current, &total) ) {
        Serial.println("Failed to query");
        Serial.print(current); Serial.println(" seconds");
        //if (! sfx.stop() ) Serial.println("Failed to stop");

      }
      */
      /*   
      if (trialType==0)
      {       
        SendData(currentTimeMsec, TTL_EVT_TONE1_OFF, 0);                  
        digitalWrite(toneOnePin, HIGH);  
      }
      else
      {       
        SendData(currentTimeMsec, TTL_EVT_TONE2_OFF, 0);                  
        digitalWrite(toneTwoPin, HIGH);  
      }   
      */ 
      
      state = stateDelayAfterTone;
      delay1 = currentTimeMsec + afterToneDelayMsec;
      SendData(currentTimeMsec, TTL_EVT_STATE, state);
      break;
    }
    break;

  case stateDelayAfterTone:
    switch (event)
    {
    case evt_EOD : 
      state = stateResponsePeriod;
      nLicksDuringDecision=0;
      delay1 = reponsePeriodDurationMsec;
      delay1 = delay1 + currentTimeMsec;
      SendData(currentTimeMsec, TTL_EVT_STATE, state);
      SendData(currentTimeMsec, TTL_EVT_SERVOPOSITION, servoHighPos);
      myservo.write(servoHighPos);
      response_made=false;
      break;
    }
    break;    

  case stateResponsePeriod:
    switch (event)
    {
    case evt_EOD :
      SendData(currentTimeMsec, TTL_EVT_NLICK_DURING_DECISION, nLicksDuringDecision);
      if (trialType==0)
      {
          nDrops=getDropNumber(nLicksDuringDecision,nLick1,nLick2);
      }
      else
      {
         lightIntensityPWM=getLightIntensity(nLicksDuringDecision,nLick1,nLick2); 
      }    
      SendData(currentTimeMsec, TTL_EVT_SERVOPOSITION, servoLowPos);
      myservo.write(servoLowPos);         
      delay1 = currentTimeMsec + afterDecisionDelayMsec;        
      state = stateDelayAfterDecision; 
      SendData(currentTimeMsec, TTL_EVT_STATE, state);
      break;  

    case evt_LICK :
      nLicksDuringDecision++;           
      break; 
    } 
    break;

  case stateDelayAfterDecision:
    switch (event)
    {
    case evt_EOD :
      SendData(currentTimeMsec, TTL_EVT_SERVOPOSITION, servoHighPos);
      myservo.write(servoHighPos);
      if (trialType==0)
      {        
        SendData(currentTimeMsec, TTL_EVT_NDROPS, nDrops); 
        SendData(currentTimeMsec,  TTL_EVT_SOLENOID_ON, 0); 
        digitalWrite(solenoidPin, HIGH);
        delay(rewardDeliveryDurationMsec);
        digitalWrite(solenoidPin, LOW);
        SendData(currentTimeMsec,  TTL_EVT_SOLENOID_OFF, 0);   
        nDrops--;
        state = stateWaitingFirstLick; 
        SendData(currentTimeMsec, TTL_EVT_STATE, state);
      }
      else
      {       
        SendData(currentTimeMsec, TTL_EVT_LED_ON, 0);   
        SendData(currentTimeMsec, TTL_EVT_LED_PWM, lightIntensityPWM);  
        SendData(currentTimeMsec, TTL_EVT_LED_DURATION, (int)lightDurationMsec);  
        analogWrite(ledMatrixPin,lightIntensityPWM);
        delay1 = lightDurationMsec + currentTimeMsec; 
        state = stateLightOn; 
        SendData(currentTimeMsec, TTL_EVT_STATE, state);        
      }
      nLicksDuringDecision=0;
      break; 
    }
    break;

  case stateLightOn:
    switch (event)
    {      
    case evt_EOD :
      analogWrite(ledMatrixPin,0);
      SendData(currentTimeMsec, TTL_EVT_LED_OFF, 0);  
      SendData(currentTimeMsec, TTL_EVT_SERVOPOSITION, servoLowPos);
      myservo.write(servoLowPos); 
      delay1 = random(itiMinDurationMsec,itiMaxDurationMsec);
      SendData(currentTimeMsec, TTL_EVT_ITI_ON, 0);
      SendData(currentTimeMsec, TTL_EVT_ITI_DURATION, delay1);
      delay1 = currentTimeMsec + delay1;
      state = stateITI; 
      SendData(currentTimeMsec, TTL_EVT_STATE, state);      
      break;    
    }
    break;

  case stateWaitingFirstLick:
    switch (event)
    {      
    case evt_LICK :    
      delay1 = consumptionPeriodMsec + currentTimeMsec;  
      state = stateIRI; 
      SendData(currentTimeMsec, TTL_EVT_STATE, state); 
      break;

    }
    break;

  case stateIRI:
    switch (event)
    {      
    case evt_EOD :
      if (nDrops>0) 
      {
        SendData(currentTimeMsec,  TTL_EVT_SOLENOID_ON, 0); 
        digitalWrite(solenoidPin, HIGH);
        delay(rewardDeliveryDurationMsec);
        digitalWrite(solenoidPin, LOW);
        SendData(currentTimeMsec,  TTL_EVT_SOLENOID_OFF, 0); 
        nDrops--;
        state = stateWaitingFirstLick; 
        SendData(currentTimeMsec, TTL_EVT_STATE, state);
      }
      else
      {
        SendData(currentTimeMsec, TTL_EVT_SERVOPOSITION, servoLowPos);
        myservo.write(servoLowPos); 
        delay1 = random(itiMinDurationMsec,itiMaxDurationMsec);
        SendData(currentTimeMsec, TTL_EVT_ITI_ON, 0);
        SendData(currentTimeMsec, TTL_EVT_ITI_DURATION, delay1);
        delay1 = currentTimeMsec + delay1;
        state = stateITI; 
        SendData(currentTimeMsec, TTL_EVT_STATE, state);
      }        
      break;
    }
    break;    

  case stateExpDone:  // 10: End of experiment
    delay(3600000);
    break;
  }

  //////////////////

  previousTimeMsec = currentTimeMsec;

  i_loop++; 
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// aditional functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void EstablishContact() {
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB
  }

  while (!processingIsReady){
    if (Serial.available() > 0) {
      incomingByte = Serial.read();
      Serial.println("Let's Go!");
      processingIsReady=true;                
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
boolean checkIfExpDone()
{
  boolean retVal=false;

  if(maxTrialNumber>0)
  {
    if(nTrials>=maxTrialNumber)
    {
      retVal=true;
    }
  }
  if(maxRewardNumber>0)
  {
    if(nRewards>=maxRewardNumber)
    {
      retVal=true;
    }
  }
  if(maxSessionDurationMsec>0)
  {
    if(currentTimeMsec>=(maxSessionDurationMsec+SessionStartTime))
    {
      retVal=true;
    }
  }

  return retVal;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// To send behavioral data using the usb port
// this data will be received by procesggin (or java) and printed in a file
// the format of the sent data is always time (msec), tabulation, code describing the value,
// tabulation  the value itself
void SendData(unsigned long time_, int code_, int val_)
{
  Serial.print(time_);delayMicroseconds(10); 
  Serial.print("\t");delayMicroseconds(10); 
  Serial.print(code_);delayMicroseconds(10);  
  Serial.print("\t");delayMicroseconds(10);  
  Serial.println(val_);delayMicroseconds(10); 
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void detect_EOD()
{
  if (delay1)
  {
    if (currentTimeMsec >= delay1)
    {
      delay1 = 0;
      event = evt_EOD;     
      SendData(currentTimeMsec, TTL_EVT_EOD, evt_EOD);
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//void detect_LICK()
//{
//  int v = analogRead(lickoPin); 
//  if(v>500)
//  {
//    if (already_licking==false)
//    {
//      if (currentTimeMsec>(lastLickTime+5))
//      {
//        event = evt_LICK;        
//        SendData(currentTimeMsec, TTL_EVT_LICK, v); 
//        lastLickTime=currentTimeMsec;
//      }
//    }
//    already_licking=true;
//  }
//  if(v<400)
//  {
//    already_licking=false;
//  }
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void detect_LICK()
{
  int v = analogRead(lickoPin); 
  if(v>500)
  {
    if (already_licking==false)
    {
      if (currentTimeMsec>(lastLickTime+5))
      {
        if(DebugSerial) Serial.println("LICK DETECTED");
        event = evt_LICK;        
        SendData(currentTimeMsec, TTL_EVT_LICK, v); 
        lastLickTime=currentTimeMsec;
      }
    }
    already_licking=true;
  }
  if(v<400)
  {
    already_licking=false;
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void populateTrialTypeArray()
{
  int i;
  for (i = 0; i < trialTypeSize; i++) {
    trialTypeArray[i]=random(2);
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void initTrialTypeArray()
{
  int i;
  for (i = 0; i < trialTypeSize; i++) {
    trialTypeArray[i]=0;
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void printTrialTypeArray()
{
  int i;
  for (i = 0; i < trialTypeSize; i++) {
    Serial.print(F("tt["));
    Serial.print(i);
    Serial.print(F("]="));
    Serial.println(trialTypeArray[i]);
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int getDropNumber(int nLicksDuringDecision_,int nLick1_,int nLick2_)
{
  int nDrops_=0;
  if (nLicksDuringDecision_ < nLick1_)
  {
    nDrops_=1;
  }
  else  
  {      
    if (nLicksDuringDecision_ < nLick2_)
    {
      nDrops_=3;
    }
    else
    {
      nDrops_=6;
    }
  } 
  return(nDrops_);  
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int getLightIntensity(int nLicksDuringDecision_,int nLick1_,int nLick2_)
{
  int lightIntensity_=0;
  if (nLicksDuringDecision_ < nLick1_)
  {
    lightIntensity_=1;//9 lux          10lux target
  }
  else  
  {      
    if (nLicksDuringDecision_ < nLick2_)
    {
      lightIntensity_=14;//61 lux      60lux target
    }
    else
    {
      lightIntensity_=98;//401 lux    400lux target
    }
  } 
  return(lightIntensity_);  
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void detect_interrupt_event()
{  
      event = evt_INTERRUPT;     
}

///////////////////////////////////////////
void waitForCameraTrigger()
{
  boolean cameraOff=true;  
      while (cameraOff) {               
        delay(1);
        if(event==evt_INTERRUPT)
        {  
            nInterrupts++;            
            
            if(nInterrupts==1)
            {       
              cameraOff=false;          
              SendData(0,TTL_EVT_INTERRUPT,nInterrupts);       
            }
            event=0;
            delay(10);
        }                 
    } 
}







