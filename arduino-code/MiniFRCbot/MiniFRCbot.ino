#include <SoftwareSerial.h>
#include <AFMotor.h>
#include <Servo.h>

float zero;
float one;
float two;
float three;
int buttonOne;
int buttonTwo;
int noSignal = 0;
int degree; //this is used if you have a servo attached

float powerOne = 0;
float powerTwo = 0;
float powerThree = 0;
float powerFour = 0;



int mode = 3;//1= Four motor Tank Drive, 2=Four Motor Mecanum Drive, 3=Two Motor Tank Drive


SoftwareSerial bluetooth(14,15); //RX,TX  note that RX will go to the TX on the bluetooth, and TX will go to the RX on the bluetooth


AF_DCMotor motorFL(1);
AF_DCMotor motorFR(2);
AF_DCMotor motorBL(3);
AF_DCMotor motorBR(4);
Servo myServo; //only used if you need a servo

void setup(){
  //Serial.begin(9600);
  //Serial.print("Hello");
  bluetooth.begin(9600);
  motorBL.setSpeed(0);
  motorBL.run(FORWARD);
  motorBR.setSpeed(0);
  motorBR.run(FORWARD);
  motorFL.setSpeed(0);
  motorFL.run(FORWARD);
  motorFR.setSpeed(0);//even if you don't need all of these motors, other people do.
  motorFR.run(FORWARD);
  myServo.attach(9);
  
}

void loop() {
  while(bluetooth.available()>0){
    zero = bluetooth.parseFloat();//get our zero axis
    one = bluetooth.parseFloat();//get our one axis
    two = bluetooth.parseFloat();//get our two axis
    three = bluetooth.parseFloat();//get our three axis
    //buttonOne = bluetooth.parseInt();//get the first button value, it should be a 1 or a 0
    //buttonTwo = bluetooth.parseInt();//get the second button value

  /*
  if(two >= 0 && two != degree){
    myServo.write(two*180);     // this is used for testing a servo with one of the joystick axis
    degree = two;
  }
  */
  if( buttonOne == 1){
    motorBR.run(FORWARD);
    motorBR.setSpeed(255);
  }
  else if (buttonTwo == 1){
    motorBR.run(BACKWARD);
    motorBR.setSpeed(255);
  }
  else{
    motorBR.setSpeed(0);
  }
  if(mode == 3){
    powerOne = (-one*255)+(three*255);
    powerTwo = (-one*255)+(-three*255);
    if(powerOne >255){
      powerOne = 255;
     }
    else if (powerOne < -255){
      powerOne = -255;
     }
    if(powerTwo >255){
      powerTwo = 255;
     }
    else if (powerTwo <-255){
      powerTwo = -255;
     }
    if(powerOne < 0){
        motorFL.run(BACKWARD);
        motorFL.setSpeed(-powerOne);
      }
    if (powerOne>0){
        motorFL.run(FORWARD);
        motorFL.setSpeed(powerOne);
      } 
    if(powerTwo < 0){
        motorFR.run(BACKWARD);
        motorFR.setSpeed(-powerTwo);
      }
    if (powerTwo>0){
        motorFR.run(FORWARD);
        motorFR.setSpeed(powerTwo);
      } 
  }
   if(mode == 1 || mode == 2){   
     powerOne = (one*255)+(three*255);
     powerTwo = (one*255)+(-three*255);
     powerThree = (one*255)+(three*255); 
     powerFour = (one*255)+(-three*255);
     if(mode == 2){
      powerOne += (-zero*255); 
      powerTwo += (zero*255);
      powerThree += (zero*255);  //really crappy math to get mecanum drive working. Works fine but may cause pain to CS students
      powerFour += (-zero*255);
     }
     if(powerOne >255){
      powerOne = 255;
     }
     else if (powerOne < -255){
      powerOne = -255;
     }
     if(powerTwo >255){
      powerTwo = 255;
     }
     else if (powerTwo <-255){
      powerTwo = -255;
     }
     if(powerThree >255){
      powerThree = 255;
     }
     else if (powerThree <-255){
      powerThree = -255;
     }
     if(powerFour >255){
      powerFour = 255;
     }
     else if (powerFour <-255){
      powerFour = -255;
     }
       
      if(powerOne < 0){
        motorFL.run(BACKWARD);
        motorFL.setSpeed(-powerOne);
      }
      if (powerOne>0){
        motorFL.run(FORWARD);
        motorFL.setSpeed(powerOne);
      } 
      if(powerTwo < 0){
        motorFR.run(BACKWARD);
        motorFR.setSpeed(-powerTwo);
      }
      if (powerTwo>0){
        motorFR.run(FORWARD);
        motorFR.setSpeed(powerTwo);
      }   
      if(powerThree < 0){
        motorBL.run(BACKWARD);
        motorBL.setSpeed(-powerThree);
      }
      if (powerThree>0){
        motorBL.run(FORWARD);
        motorBL.setSpeed(powerThree);
      }  
      if(powerFour < 0){
        motorBR.run(BACKWARD);
        motorBR.setSpeed(-powerFour);
      }
      if (powerFour>0){
        motorBR.run(FORWARD);
        motorBR.setSpeed(powerFour);
      } 

    }    
  
  }
  Serial.println("NOBLUETOOTH");
  noSignal += 1;
  if (noSignal > 40){
    noSignal = 0;    //if you have over 3 seconds of packet loss, the robot will stop moving.
    motorFL.setSpeed(0);
    motorFR.setSpeed(0);
    motorBL.setSpeed(0);
    motorBR.setSpeed(0);    
  }
  delay(40); // delay for 60ms for rough timing on the packet loss shutdown
}
    
