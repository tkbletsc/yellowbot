#include <SoftwareSerial.h>
//#include <AFMotor.h>
//#include <Servo.h>

int noSignal = 0;

SoftwareSerial bluetooth(A0,A1); //RX,TX  note that RX will go to the TX on the bluetooth, and TX will go to the RX on the bluetooth

#define control_serial bluetooth // set to Serial for wired, bluetooth for wireless


/*
AF_DCMotor motorFL(1);
AF_DCMotor motorFR(2);
AF_DCMotor motorBL(3);
AF_DCMotor motorBR(4);
*/

int motorL[] = {5,6};
int motorR[] = {9,10};
//Servo myServo; //only used if you need a servo

void motor_setSpeed(int pin1, int pin2, int speed) {
  if (speed<0) { // backward
    speed = -speed;
    analogWrite(pin1,0);
    analogWrite(pin2,speed);
  } else {
    analogWrite(pin1,speed);
    analogWrite(pin2,0);
  }
}

#define motorL_setSpeed(speed) motor_setSpeed(motorL[0],motorL[1],speed)
#define motorR_setSpeed(speed) motor_setSpeed(motorR[0],motorR[1],speed)

void setup(){
  Serial.begin(9600);
  Serial.println("Robot booted.");
  bluetooth.begin(9600);
  motorL_setSpeed(0);
  motorR_setSpeed(0);

  pinMode(motorL[0],OUTPUT);
  pinMode(motorL[1],OUTPUT);
  pinMode(motorR[0],OUTPUT);
  pinMode(motorR[1],OUTPUT);
  

  while (0) {
    digitalWrite(5,1);
    digitalWrite(6,0);
  }
  //myServo.attach(9);
  
}

void loop() {
  while(control_serial.available()>0){
    int ax0 = control_serial.parseFloat();//get our zero axis
    int ax1 = control_serial.parseFloat();//get our one axis
    int ax2 = control_serial.parseFloat();//get our two axis
    int ax3 = control_serial.parseFloat();//get our three axis
    //buttonOne = control_serial.parseInt();//get the first button value, it should be a 1 or a 0
    //buttonTwo = control_serial.parseInt();//get the second button value

    int m1speed = constrain(ax1,-255,255);
    int m2speed = constrain(ax3,-255,255);
    motorL_setSpeed(m1speed);
    motorR_setSpeed(m2speed);

    char buf[80];
    sprintf(buf,"axes=[%4d,%4d,%4d,%4d] m=[%4d,%4d]\n",ax0,ax1,ax2,ax3,m1speed,m2speed);

    Serial.println(buf);
    //bluetooth.println(buf);

  }
  /*Serial.println("NOBLUETOOTH");
  noSignal += 1;
  if (noSignal > 40){
    noSignal = 0;    //if you have over 3 seconds of packet loss, the robot will stop moving.
    motorFL.setSpeed(0);
    motorFR.setSpeed(0);
    motorBL.setSpeed(0);
    motorBR.setSpeed(0);    
  }
  delay(40); // delay for 60ms for rough timing on the packet loss shutdown
  */
  delay(40);
}
    

