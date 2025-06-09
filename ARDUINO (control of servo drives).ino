#include <Servo.h>

Servo servoX, servoY;
int posX = 90, posY = 90;

void setup() {
  Serial.begin(9600);
  servoX.attach(9);
  servoY.attach(10);
  servoX.write(posX);
  servoY.write(posY);
}

void loop() {
  if (Serial.available()) {
    String input = Serial.readStringUntil('\n');
    int comma = input.indexOf(',');
    if (comma > 0) {
      int x = input.substring(0, comma).toInt();
      int y = input.substring(comma + 1).toInt();
      posX = map(x, 0, 640, 0, 180);
      posY = map(y, 0, 480, 0, 180);
      servoX.write(posX);
      servoY.write(posY);
    }
  }
}
