#include <Servo.h> 
Servo myservo;  // create servo object to control a servo 
// a maximum of eight servo objects can be created 
int pos = 0;    // variable to store the servo position 

///////////////////////////////////
// variables already defined //
///////////////////////////////////

int servoLowPos = 72;
int servoHighPos = 80;

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
const int stateITI                = 1;
const int stateToneOn             = 2;
const int stateDelayAfterTone     = 3;
const int stateResponsePeriod     = 4;
const int stateDelayAfterDecision = 5;
const int stateLightOn            = 6;
const int stateWaitingFirstLick   = 7;
const int stateIRI                = 8;
const int stateExpDone            = 9;



// 1: for Reward and 0 for Reward and Light
int trialType = 0;
int trialTypeSize = 300;
int trialTypeArray[300];

////////////////////////////////////////////////      
const int ledVoltage_mv = 5000;


const int protocol = 1;

////////////////////////////////////////
// variables used by the program only //
////////////////////////////////////////

//to establish a connection with Processing
int incomingByte;
boolean processingIsReady=false;

int i_loop = 0;
int nb_loop = 10;
//Time Measurment
unsigned long currentTimeMsec = 0; // current time
unsigned long previousTimeMsec = 0; // current time
unsigned long SessionStartTime = 0;

unsigned long delay1 = 0;

// Arduino Digital Output-Pins
const int lickoPin     = A0;
const int servoPin     = 8;
const int toneOnePin   = 6;
const int toneTwoPin   = 7;
const int solenoidPin  = 10;
const int ledMatrixPin = 5;

const int evt_LICK = 1;
const int evt_EOD = 2; //End Of Delay

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
const int TTL_EVT_PROGRAM_VERSION          = 1;
const int TTL_EVT_MAX_TRIAL_NUMBER         = 2;
const int TTL_EVT_MAX_REWARD_NUMBER        = 3;
const int TTL_EVT_MAX_SESSION_DURATION     = 4;
const int TTL_EVT_EXPERIMENT_START         = 5;
const int TTL_EVT_EXPERIMENT_STOP          = 6;
const int TTL_EVT_TRIAL_START              = 7;
const int TTL_EVT_TRIAL_STOP               = 8;
const int TTL_EVT_ITI_ON                   = 9;
const int TTL_EVT_ITI_OFF                  = 10;
const int TTL_EVT_ITI_MIN                  = 11;
const int TTL_EVT_ITI_MAX                  = 12;
const int TTL_EVT_LICK                     = 13;
const int TTL_EVT_SOLENOID_ON              = 14;
const int TTL_EVT_SOLENOID_DURATION        = 15;
const int TTL_EVT_SOLENOID_OFF             = 16;
const int TTL_EVT_LED_ON                   = 17;
const int TTL_EVT_LED_PWM                  = 18;
const int TTL_EVT_LED_DURATION             = 19;
const int TTL_EVT_LED_OFF                  = 20;
const int TTL_EVT_TONE1_ON                 = 21;
const int TTL_EVT_TONE1_FREQ               = 22;
const int TTL_EVT_TONE1_DURATION           = 23;
const int TTL_EVT_TONE1_OFF                = 24;
const int TTL_EVT_TONE2_ON                 = 25;
const int TTL_EVT_TONE2_FREQ               = 26;
const int TTL_EVT_TONE2_DURATION           = 27;
const int TTL_EVT_TONE2_OFF                = 28;
const int TTL_EVT_STATE                    = 29;
const int TTL_EVT_EVENT                    = 30;
const int TTL_EVT_CORRECT_REPONSE          = 31;
const int TTL_EVT_INCORRECT_RESPONSE       = 32;
const int TTL_EVT_OMISSION                 = 33;
const int TTL_EVT_ITI_DURATION             = 34;
const int TTL_EVT_EOD                      = 35;
const int TTL_EVT_STIM_TYPE                = 36;
const int TTL_EVT_STIM_ON                  = 37;
const int TTL_EVT_STIM_DURATION            = 38;
const int TTL_EVT_STIM_OFF                 = 39;
const int TTL_EVT_BLOCK_SIZE               = 40;
const int TTL_EVT_THRESHOLD                = 41;
const int TTL_EVT_LIGHT_INTENSITY_START    = 42;
const int TTL_EVT_LIGHT_INTENSITY_STEP     = 43;
const int TTL_EVT_NOLIGHT_NTRIALS          = 44;

const int TTL_EVT_MEGA_STATE               = 45;
const int TTL_EVT_SLOW_SEARCH_STEP         = 46;
const int TTL_EVT_FAST_SEARCH_STEP         = 47;
const int TTL_EVT_BASELINE_THRESHOLD       = 48;
const int TTL_EVT_SLOW_SEARCH_THRESHOLD    = 49;
const int TTL_EVT_FAST_SEARCH_THRESHOLD    = 50;
const int TTL_EVT_BASELINE_SIZE            = 51;
const int TTL_EVT_SLOW_SEARCH_SIZE         = 52;
const int TTL_EVT_FAST_SEARCH_SIZE         = 53;
const int TTL_EVT_SLOW_SEARCH_STARTING_POINT = 54;
const int TTL_EVT_NSUCC_TEST = 55;

const int TTL_EVT_LED_VOLTAGE_MV = 56;
const int TTL_EVT_OFFER_ACCEPTED = 57;
const int TTL_EVT_OFFER_REJECTED = 58;
const int TTL_EVT_AFTERTONEDELAYMSEC = 59;
const int TTL_EVT_RESPONSEDURATIONMSEC = 60;

const int TTL_EVT_DELAYBEFORETONEMSEC = 61;
const int TTL_EVT_DELAYAFTEROFFERMSEC = 62;

const int TTL_EVT_SERVOPOSITION = 63;

const int TTL_EVT_AFTERDECISIONDELAYMSEC = 64;
const int TTL_EVT_CONSUMPTIONPERIODMSEC  = 65;
const int TTL_EVT_CONSUMPTIONLICKNUMBER  = 66;
const int TTL_EVT_TRIALTYPE              = 67;
const int TTL_EVT_MAXWAITFORFIRSTLICKMSEC = 68;

const int TTL_EVT_QUENCHINGPERIODMSEC  = 69;
const int TTL_EVT_QUENCHINGLICKNUMBER  = 70;
const int TTL_EVT_REST_ON  = 71;
const int TTL_EVT_QUENCHING_ON  = 72;
const int TTL_BLOCK_NUMBER = 73;
const int TTL_CURRENT_BLOCK_NUMBER = 74;

const int TTL_CUE_LIGHT_INTENSITY_1   = 75;
const int TTL_CUE_LIGHT_INTENSITY_2   = 76;
const int TTL_OFFER_LIGHT_INTENSITY_1 = 77;
const int TTL_OFFER_LIGHT_INTENSITY_2 = 78;
const int TTL_CUE_LIGHT_DURATION_1    = 79;
const int TTL_CUE_LIGHT_DURATION_2    = 80;
const int TTL_OFFER_LIGHT_DURATION_1  = 81;
const int TTL_OFFER_LIGHT_DURATION_2  = 82;

const int TTL_EVT_OPTO_ON                  =  83;
const int TTL_EVT_OPTO_OFF                 = 84;
const int TTL_EVT_OPTO_POWER               =  85;
const int TTL_EVT_OPTO_WAVELENGTH          =  86;

const int TTL_EVT_REWARD_DURATION_1  = 87;
const int TTL_EVT_REWARD_DURATION_2  = 88;

const int TTL_EVT_NLICK_TOT  = 89;
const int TTL_EVT_NLICK_CURRENT  = 90;

const int TTL_EVT_NLICK_DURING_DECISION    = 91;
const int TTL_EVT_NDROPS                   = 92;



void setup() {



  //Defines Inputs and Outputs
  pinMode(solenoidPin, OUTPUT);
  digitalWrite(solenoidPin, LOW);
  pinMode(toneOnePin, OUTPUT);
  digitalWrite(toneOnePin, HIGH);
  pinMode(toneTwoPin, OUTPUT);
  digitalWrite(toneTwoPin, HIGH);
  pinMode(ledMatrixPin, OUTPUT);
  digitalWrite(ledMatrixPin, LOW);


  randomSeed(analogRead(1));

  myservo.attach(8);  // attaches the servo on pin 8 to the servo object 
  myservo.write(servoHighPos);

  initTrialTypeArray();
  populateTrialTypeArray();

  Serial.begin(115200);          //  creates serial communication at 115200 bauds
  EstablishContact();

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
  SendData(currentTimeMsec, TTL_EVT_TONE1_DURATION, toneDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_TONE1_FREQ, toneOneFreq);
  SendData(currentTimeMsec, TTL_EVT_TONE2_DURATION, toneDurationMsec);
  SendData(currentTimeMsec, TTL_EVT_TONE2_FREQ, toneTwoFreq);
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

}


void loop()
{
  currentTimeMsec = millis();
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

          if (trialType==1)
          {        
            SendData(currentTimeMsec, TTL_EVT_TONE1_ON, 0);                  
            digitalWrite(toneOnePin, LOW);
          }
          else
          {          
            SendData(currentTimeMsec, TTL_EVT_TONE2_ON, 0);                  
            digitalWrite(toneTwoPin, LOW);
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
      if (trialType==1)
      {       
        SendData(currentTimeMsec, TTL_EVT_TONE1_OFF, 0);                  
        digitalWrite(toneOnePin, HIGH);  
      }
      else
      {       
        SendData(currentTimeMsec, TTL_EVT_TONE2_OFF, 0);                  
        digitalWrite(toneTwoPin, HIGH);  
      }   
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
void detect_LICK()
{
  int v = analogRead(lickoPin); 
  if(v>500)
  {
    if (already_licking==false)
    {
      if (currentTimeMsec>(lastLickTime+5))
      {
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
    lightIntensity_=10;//10 lux
  }
  else  
  {      
    if (nLicksDuringDecision_ < nLick2_)
    {
      lightIntensity_=60;//60 lux
    }
    else
    {
      lightIntensity_=200;//200lux
    }
  } 
  return(lightIntensity_);  
}





