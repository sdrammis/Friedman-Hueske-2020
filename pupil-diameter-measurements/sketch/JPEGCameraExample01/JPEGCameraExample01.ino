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
const int pinSDChipSelect = 8;

/****************************************************************************************************
* Variabili programma                                                                               *
****************************************************************************************************/

// Oggetto JPEG Camera
JPEGCamera jpegCamera;

// JPEG file
File jpegFile;
// Contatore immagine
byte i = 0;

/****************************************************************************************************
* Codice programma                                                                                  *
****************************************************************************************************/

// Inizializzazione Scheda
void setup() {
  // Inizializzo I/O
  pinMode(pinBoardLed, OUTPUT);
  pinMode(pinSDChipSelect, OUTPUT);
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

  // Identifico nome file  
  char fileName[12] = "image00.jpg";
  fileName[5] = ((i / 10) + 0x30);
  fileName[6] = ((i % 10) + 0x30);
  
  // Apro file
  jpegFile = SD.open(fileName, FILE_WRITE);

  // Leggo/salvo i dati immagine
  isEnd = false;
  while(isEnd == false) {
    jpegCamera.readJpegFileContent(address, chunkSize, body, &isEnd);
    address += chunkSize;
    // Salvo i dati sul file
    jpegFile.write(body, chunkSize);
  }
  
  // Chiudo file
  jpegFile.close();
  // Fermo immagine
  jpegCamera.stopTakingPictures();
  // Attesa
  delay(1000);
  
  // Prossimo file
  i = ((i + 1) % 100);
}    // Chiusura funzione loop
