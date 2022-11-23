//=====================================================Library===========================================================
#include <hidboot.h>
#include <hiduniversal.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <Keypad.h>
#include <AccelStepper.h>
#include <MultiStepper.h>
//=========================================================================================================================

//====================================================Pembuatan Class======================================================
class KbdRptParser : public KeyboardReportParser
{
    void PrintKey(uint8_t mod, uint8_t key);

  protected:
    void OnControlKeysChanged(uint8_t before, uint8_t after);

    void OnKeyDown  (uint8_t mod, uint8_t key);
    void OnKeyUp  (uint8_t mod, uint8_t key);
    void OnKeyPressed(uint8_t key);
};

void KbdRptParser::PrintKey(uint8_t m, uint8_t key)
{
  MODIFIERKEYS mod;
  *((uint8_t*)&mod) = m;
}

void KbdRptParser::OnKeyDown(uint8_t mod, uint8_t key)
{
  PrintKey(mod, key);
  uint8_t c = OemToAscii(mod, key);

  if (c)
    OnKeyPressed(c);
}

void KbdRptParser::OnControlKeysChanged(uint8_t before, uint8_t after) {

  MODIFIERKEYS beforeMod;
  *((uint8_t*)&beforeMod) = before;

  MODIFIERKEYS afterMod;
  *((uint8_t*)&afterMod) = after;
}

void KbdRptParser::OnKeyUp(uint8_t mod, uint8_t key)
{
  //Serial.print("UP ");
  //PrintKey(mod, key);
}
//=========================================================================================================================

//===================================================Deklarasi Variabel Global=============================================
String DataBarcode, BRCD;
bool x = false;
double harga_belanja_maksimal,total_belanja,sisa_uang;
const byte jumlahBaris = 4;
const byte jumlahKolom = 4;
String Nama[] = {"Sunlight", "Wardah Sampo", "Dettol", "Pepsodent", "Totole"};
String Barcode[] = {"8999999390198", "8993137698436", "8993560025274", "8999999710873", "6922130105100"};
long Harga[] = {26000, 25500, 10000, 14000, 10000};
//=========================================================================================================================


//===================================================Pembuatan Objek=======================================================
USB Usb;
HIDUniversal Hid(&Usb);
KbdRptParser Prs;
LiquidCrystal_I2C lcd(0x27, 20, 4);
char petaTombol[jumlahBaris] [jumlahKolom] =
{
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'},
};
byte pinBaris[jumlahBaris] = {28,26,24,22};
byte pinKolom[jumlahKolom] = {36,34,32,30};
Keypad tombol = Keypad(makeKeymap(petaTombol), pinBaris, pinKolom, jumlahBaris, jumlahKolom);
AccelStepper stepper(AccelStepper::FULL4WIRE, 38, 40, 42, 44);
//=========================================================================================================================

void setup() {
  lcd.init();
  lcd.backlight();
  Serial.begin( 115200 );
  Serial1.begin(115200);
  pinMode(46, INPUT_PULLUP);
  pinMode(26,OUTPUT);
  if (Usb.Init() == -1)
    Serial.println("OSC did not start.");
  delay( 200 );
  Hid.SetReportParser(0, &Prs);
  stepper.setMaxSpeed(500);
  stepper.setAcceleration(2000);
  stepper.setSpeed(-500);
  while (digitalRead(46)) {
    stepper.runSpeed();
    Serial.println("LOOP");
  }
  stepper.setCurrentPosition(0);
  inisial_belanja();
}

void loop() {
  TungguScan();
  Display_Goods();
}

//==================================================Void Membaca Barcode=================================================
void KbdRptParser::OnKeyPressed(uint8_t key)
{
  //Serial.print((char)key);
  if (key == 0x0D) {
    x = true;
  } else {
    DataBarcode += (char)key;
  }
}

//=====================================================Library===========================================================
#include <hidboot.h>
#include <hiduniversal.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <Keypad.h>
#include <AccelStepper.h>
#include <MultiStepper.h>
//=========================================================================================================================

//====================================================Pembuatan Class======================================================
class KbdRptParser : public KeyboardReportParser
{
    void PrintKey(uint8_t mod, uint8_t key);

  protected:
    void OnControlKeysChanged(uint8_t before, uint8_t after);

    void OnKeyDown  (uint8_t mod, uint8_t key);
    void OnKeyUp  (uint8_t mod, uint8_t key);
    void OnKeyPressed(uint8_t key);
};

void KbdRptParser::PrintKey(uint8_t m, uint8_t key)
{
  MODIFIERKEYS mod;
  *((uint8_t*)&mod) = m;
}

void KbdRptParser::OnKeyDown(uint8_t mod, uint8_t key)
{
  PrintKey(mod, key);
  uint8_t c = OemToAscii(mod, key);

  if (c)
    OnKeyPressed(c);
}

void KbdRptParser::OnControlKeysChanged(uint8_t before, uint8_t after) {

  MODIFIERKEYS beforeMod;
  *((uint8_t*)&beforeMod) = before;

  MODIFIERKEYS afterMod;
  *((uint8_t*)&afterMod) = after;
}

void KbdRptParser::OnKeyUp(uint8_t mod, uint8_t key)
{
  //Serial.print("UP ");
  //PrintKey(mod, key);
}
//=========================================================================================================================

//===================================================Deklarasi Variabel Global=============================================
String DataBarcode, BRCD;
bool x = false;
double harga_belanja_maksimal,total_belanja,sisa_uang;
const byte jumlahBaris = 4;
const byte jumlahKolom = 4;
String Nama[] = {"Sunlight", "Wardah Sampo", "Dettol", "Pepsodent", "Totole"};
String Barcode[] = {"8999999390198", "8993137698436", "8993560025274", "8999999710873", "6922130105100"};
long Harga[] = {26000, 25500, 10000, 14000, 10000};
//=========================================================================================================================


//===================================================Pembuatan Objek=======================================================
USB Usb;
HIDUniversal Hid(&Usb);
KbdRptParser Prs;
LiquidCrystal_I2C lcd(0x27, 20, 4);
char petaTombol[jumlahBaris] [jumlahKolom] =
{
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'},
};
byte pinBaris[jumlahBaris] = {28,26,24,22};
byte pinKolom[jumlahKolom] = {36,34,32,30};
Keypad tombol = Keypad(makeKeymap(petaTombol), pinBaris, pinKolom, jumlahBaris, jumlahKolom);
AccelStepper stepper(AccelStepper::FULL4WIRE, 38, 40, 42, 44);
//=========================================================================================================================

void setup() {
  lcd.init();
  lcd.backlight();
  Serial.begin( 115200 );
  Serial1.begin(115200);
  pinMode(46, INPUT_PULLUP);
  pinMode(26,OUTPUT);
  if (Usb.Init() == -1)
    Serial.println("OSC did not start.");
  delay( 200 );
  Hid.SetReportParser(0, &Prs);
  stepper.setMaxSpeed(500);
  stepper.setAcceleration(2000);
  stepper.setSpeed(-500);
  while (digitalRead(46)) {
    stepper.runSpeed();
    Serial.println("LOOP");
  }
  stepper.setCurrentPosition(0);
  inisial_belanja();
}

void loop() {
  TungguScan();
  Display_Goods();
}

//==================================================Void Membaca Barcode=================================================
void KbdRptParser::OnKeyPressed(uint8_t key)
{
  //Serial.print((char)key);
  if (key == 0x0D) {
    x = true;
  } else {
    DataBarcode += (char)key;
  }
}
