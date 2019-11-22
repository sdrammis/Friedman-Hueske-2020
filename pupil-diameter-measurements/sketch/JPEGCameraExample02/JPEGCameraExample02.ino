/****************************************************************************************************
* Inclusione librerie                                                                               *
****************************************************************************************************/
#include <JPEGCamera.h>
#include "SoftwareSerial.h"
#include <SD.h>

// Chunk size per salvataggio immagine
#define CHUNK_SIZE    64

/****************************************************************************************************
* Definizione pin I/O Arduino                                                                       *
****************************************************************************************************/
// Led scheda Arduino
const int pinBoardLed = 13;
// Pin Arduino Chip Select SD
const int pinSDChipSelect = 4;
// Sensore PIR scheda Arduino
const int pinPIRSensor = 5;

/****************************************************************************************************
* Variabili programma                                                                               *
****************************************************************************************************/

// Oggetto JPEG Camera
JPEGCamera jpegCamera;

// JPEG file
File jpegFile;
// Contatore directory
int dirCount = 0;
// Contatore immagine
byte fileCount = 1;

boolean flagSensorePIR = false;

/****************************************************************************************************
* Codice programma                                                                                  *
****************************************************************************************************/

// Inizializzazione Scheda
void setup() {
  // Inizializzo I/O
  pinMode(pinBoardLed, OUTPUT);
  pinMode(pinSDChipSelect, OUTPUT);  
  pinMode(pinPIRSensor, INPUT);  
  // Accendo led Arduino
  digitalWrite(pinBoardLed, HIGH);
  
  // Inizializzo JPEG Camera
  jpegCamera.begin();

  // Init SD
  pinMode(10, OUTPUT);
  if (!SD.begin(pinSDChipSelect)) {
    // Lampeggio led Arduino
    for (;;) {
      digitalWrite(pinBoardLed, HIGH);
      delay(500);
      digitalWrite(pinBoardLed, LOW);
      delay(500);
    }
  }
  
  // Identifico prima directory libera
  for (;;) {
    char dirName[7] = "DIR000";
    dirName[3] = ((dirCount / 100) + 0x30);
    dirName[4] = (((dirCount % 100) / 10) + 0x30);
    dirName[5] = ((dirCount % 10) + 0x30);
    // Se directory non esiste
    if (SD.exists(dirName) == false)
      break;

    // Prossima directory
    dirCount++;
  }

  // Spengo led Arduino
  digitalWrite(pinBoardLed, LOW);
}    // Chiusura funzione setup

// Programma Principale
void loop() {
  boolean isEnd = false;
  uint16_t address = 0x0000;
  uint16_t chunkSize = CHUNK_SIZE;
  byte body[CHUNK_SIZE];
  
  // Imposto dimensione immagine
  jpegCamera.setImageSize(jpegCamera.ImageSize320x280);  
  // Reset JPEG Camera
  jpegCamera.reset();  

  // Scatto immagine
  jpegCamera.takePicture();

  // Identifico prima directory libera
  char dirName[7] = "DIR000";
  dirName[3] = ((dirCount / 100) + 0x30);
  dirName[4] = (((dirCount % 100) / 10) + 0x30);
  dirName[5] = ((dirCount % 10) + 0x30);
  // Se directory non esiste
  if (SD.exists(dirName) == false)
    // Creo directory
    SD.mkdir(dirName);

  // Identifico nome file
  char pathComplete[22] = "DIR000/image00.jpg";  
  pathComplete[3] = ((dirCount / 100) + 0x30);
  pathComplete[4] = (((dirCount % 100) / 10) + 0x30);
  pathComplete[5] = ((dirCount % 10) + 0x30);
  pathComplete[12] = ((fileCount / 10) + 0x30);
  pathComplete[13] = ((fileCount % 10) + 0x30);
  
  // Apro file
  jpegFile = SD.open(pathComplete, FILE_WRITE);

  // Leggo/salvo i dati immagine
  isEnd = false;
  while(isEnd == false) {
    jpegCamera.readJpegFileContent(address, chunkSize, body, &isEnd);
    address += chunkSize;
    // Salvo i dati sul file
    jpegFile.write(body, chunkSize);

    // Se sensore PIR non rilevato
    if (flagSensorePIR == false) {
      // Se sensore PIR attivo
      if (digitalRead(pinPIRSensor) == HIGH) {
        // Prossimo file è il 6 (verrà incrementato in seguito)
        fileCount = 5;
        flagSensorePIR = true;
      }
    }
  }
  
  // Chiudo file
  jpegFile.close();
  // Fermo immagine
  jpegCamera.stopTakingPictures();
  // Attesa
  delay(100);

  // Se sensore PIR non rilevato
  if (flagSensorePIR == false) {
    // Se sensore PIR attivo
    if (digitalRead(pinPIRSensor) == HIGH) {
      // Prossimo file è il 6
      fileCount = 6;
      flagSensorePIR = true;      
    }
    // Se sensore PIR non attivo
    else {
      // Prossimo file number
      if (fileCount == 5)
        fileCount = 1;
      else
        fileCount++;
    }
  }
  // Se sensore PIR rilevato
  else {
    // Se salvati 5 file
    if (fileCount == 10) {
      // Resetto file
      fileCount = 1;
      // Prossima directory
      dirCount++;
      // Indico reset PIR
      flagSensorePIR = false;
    }
    else
      fileCount++;
  }
}    // Chiusura funzione loop
