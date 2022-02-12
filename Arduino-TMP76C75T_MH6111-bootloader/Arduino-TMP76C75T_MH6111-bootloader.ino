/*
  Using SoftwareSerial to send code over serial and execute on TMP76C75T/MH6111
  Jane Hacker 9 Feb, 2022

  Output over serial line:
    ReAdY!
    READY captured

    JANE HACKER 2022 <3
    DONE
*/

#define RST_PIN 9

unsigned char readyChk[5] = {0, 0, 0, 0, 0};
uint8_t rCIndex = 0;
unsigned char readyBytes[5] = {'R', 'E', 'A', 'D', 'Y'};
bool isReady = false;

void setup() {
  pinMode(RST_PIN, OUTPUT);
  digitalWrite(RST_PIN, LOW);

  // Open serial communications and wait for port to open:
  Serial.begin(230400);

  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  Serial.println("ReAdY!");

  Serial1.begin(488);

  resetMpu();
}

//Waits for "READY" over rx then dumps code over tx
void loop() {
  if (Serial1.available()) {
    char readByte = Serial1.read();

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

    if(isReady) {
      String str = String((uint8_t)readByte, HEX);
      
      if(1 == str.length()) {
        str = "0" + str;
      }
      
      //Serial.println("0x" + str);
      Serial.println("0x" + str + "(" + readByte + ")");
    }
  }
}

//Writes the code to serial to be stored in RAM to be run
void writeCode() {
  char data[44] = {
0x86,
0x01,
0xBD,
0x80,
0x54,
0xCC,
0xFE,
0x50,
0xDD,
0x40,
0xCC,
0x00,
0x00,
0xCD,
0xCE,
0x00,
0x00,
0xCE,
0x00,
0x40,
0xCD,
0x08,
0x13,
0x00,
0x40,
0x07,
0xBD,
0x80,
0x54,
0x08,
0x08,
0xCD,
0x8C,
0x00,
0x05,
0x25,
0xEF,
0x86,
0x01,
0xBD,
0x80,
0x54,
0x39,

0xFF
  };

  delay(10);

  int i = 0;

  while(i < 44) {
    delay(10);
    Serial1.write(data[i]);
    
    if(0xFF == data[i]) {
      break;
    }

    i++;
  }
}

void resetMpu() {
  digitalWrite(RST_PIN, LOW);
  delay(10);  //Hold RST LOW for 100ms
  digitalWrite(RST_PIN, HIGH);
}
