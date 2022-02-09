/*
  Using SoftwareSerial to send code over serial and execute on TMP76C75T/MH6111
  Jane Hacker 9 Feb, 2022

  Output over serial line:
    ReAdY!
    READY captured

    JANE HACKER 2022 <3
    DONE
*/
#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11); // RX, TX

unsigned char readyChk[5] = {0, 0, 0, 0, 0};
uint8_t rCIndex = 0;
unsigned char readyBytes[5] = {'R', 'E', 'A', 'D', 'Y'};
bool isReady = false;

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(57600);

  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  Serial.println("ReAdY!");

  mySerial.begin(15625); //"Weird"  76C75T speed
}

//Waits for "READY" over rx then dumps code over tx
void loop() {
  if (mySerial.available()) {
    char readByte = mySerial.read();

    if(isReady) {
      String str = String((uint8_t)readByte, HEX);
      Serial.println("0x" + str + "(" + readByte + ")");
    }

    if(!isReady) {
      readyChk[rCIndex] = readByte;
      rCIndex++;

      if(5 == rCIndex) {
        if(0 == memcmp(readyChk, readyBytes, 5)) {
          Serial.println("READY captured");
          isReady = true;
          writeCode();
        }
      }
    }
  }
}

//Writes the code to serial to be stored in RAM to be run
void writeCode() {
  char data[17] = {
    0xCC,
    0x00, //divisor hi
    0x00, //divisor lo
    0x15,
    0x00, //dividen
    0xBD,
    0x80,
    0x54,
    0x17,
    0xBD,
    0x80,
    0x54,
    0x07,
    0xBD,
    0x80,
    0x54,
    0xF0
  };

  delay(10);

  for(int i = 0; i < 17; i++) {
    delay(10);
    mySerial.write(data[i]);
  }
}
