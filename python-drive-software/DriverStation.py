'''
Mini FRC Drivers Station V1.1

Requirements:
Made in Python 3.4 <<<<<<<<<<<<<<< BACKPORTED TO PYTHON 2
Uses Pygame and Pyserial

This program is for grabbing data from joysticks to control arduinos connected to bluetooth
'''
import serial
import serial.tools.list_ports
import time
import pygame
import sys,os,re
print("MiniFRC Driver Station v1.0\n")
print("Booting...")
pygame.init()
pygame.joystick.init()
joysticks = [pygame.joystick.Joystick(x) for x in range(pygame.joystick.get_count())]
print("\nDetected %s joystick(s): " % (pygame.joystick.get_count())+str(joysticks)) 

serial_port_autodetect_enabled = False

for i in range(pygame.joystick.get_count()):
    joystick = pygame.joystick.Joystick(i)
    joystick.init()
    for i in range(0,5):
        events = pygame.event.get()
        time.sleep(0.1)
    name = joystick.get_name()
    print("\nJoystick name: %s" % (name))
    
    axes = joystick.get_numaxes()
    print("Num of axes: %s" % (axes))
    
    for j in range( axes ):
        axis = joystick.get_axis( j )
        print("Axis %s value: %s" % (j, axis) )
        
    buttons = joystick.get_numbuttons()
    print("Number of buttons: %s"%(buttons))

    for k in range( buttons ):
        button = joystick.get_button( k )
        print("Button %s value: %s"%(k,button))

    hats = joystick.get_numhats()
    print("Number of hats: %s" % (hats))
    
    for l in range( hats ):
        hat = joystick.get_hat( l )
        print("Hat %s value: %s" % (l, hat))

if pygame.joystick.get_count() <= 0:
    print("No joysticks found, closing...")
    sys.exit(1)

print "Scanning for serial ports..."
ports = sorted(list(serial.tools.list_ports.comports()))
print "Got %d ports." % len(ports)
if not ports:
    print "No serial ports, check your cables/drivers and try again. Exiting."
    sys.exit(1)
    
for i,port in enumerate(ports):
    print "%d.  %s" % (i,port)
if serial_port_autodetect_enabled and len(ports)==1:
    # auto detect success
    com = ports[0].device
    print "Autodetect assumes serial port: %s" % com
else:
    # manual choice
    port_num = input("Please select the robot COM port: ")
    #com = ports[port_num].device
    com = ports[port_num][0]
    print "Select your serial port from the list above: %s" % com

try:
    s = serial.Serial(str(com), 9600, timeout = 1) #we pretend the robot is on a usb port
except Exception as e:
    print("Couldn't connect to the robot on this port:\n%s"%e)
    sys.exit(1)
    
print("Connected to robot!")
joystick_one = pygame.joystick.Joystick(0) #initiate first joystick
joystick_one.init()
Clock = pygame.time.Clock()
while 1:
    events = pygame.event.get() #update pygame internally
    package = ' '.join("%d"%(255*joystick.get_axis(i)) for i in range(joystick.get_numaxes()))
    #package += ' ' + ' '.join("%d"%joystick.get_button(i) for i in range(joystick.get_numbuttons()))
    print(package)
    #s.write(bytes(package,'utf-8'))
    s.write("%s\n"%package)
    s.flush()
    #print s.readline()
    Clock.tick(20) #driver station tested and run at 20FPS, results may vary at other framerates.
    #if s.in_waiting:
    #    print "<<%s>>" % s.read(s.in_waiting)




