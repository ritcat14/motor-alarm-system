#!/usr/bin/python

import smbus
import time
import sys

busID = sys.argv[1]
type = sys.argv[2]
bus=smbus.SMBus(int(busID))

if type == "accelerometer":
    bus.write_byte_data(0x68, 0x1C, 0x18)

    # Select power management register1
    bus.write_byte_data(0x68, 0x6B, 0x01)
    time.sleep(0.8)

    # Read data back from 0x3B(59), 6 bytes
    data = bus.read_i2c_block_data(0x68, 0x3B, 6)
    # Convert the data
    xAccl = data[0] * 256 + data[1]
    if xAccl > 32767 :
        xAccl -= 65536

    yAccl = data[2] * 256 + data[3]
    if yAccl > 32767 :
        yAccl -= 65536

    zAccl = data[4] * 256 + data[5]
    if zAccl > 32767 :
        zAccl -= 65536
    f = open("/home/pi/project/sensor/sensor_data/%s.cal" %busID, 'w')
    f.write("aX:{0}|aY:{1}|aZ:{2}\n".format(xAccl, yAccl, zAccl))
    f.close()
    sys.exit(0)
elif type == "gyroscope":
    bus.write_byte_data(0x68, 0x1B, 0x18)

    # Select power management register1
    bus.write_byte_data(0x68, 0x6B, 0x01)
    time.sleep(0.8)

    data = bus.read_i2c_block_data(0x68, 0x43, 6)
    # Convert the data

    xGyro = data[0] * 256 + data[1]
    if xGyro > 32767 :
        xGyro -= 65536

    yGyro = data[2] * 256 + data[3]
    if yGyro > 32767 :
        yGyro -= 65536

    zGyro = data[4] * 256 + data[5]
    if zGyro > 32767 :
        zGyro -= 65536

    f = open("/home/pi/project/sensor/sensor_data/%s.cal" %busID, 'w')
    f.write("gX:{0}|gY:{1}|gZ:{2}\n".format(xGyro, yGyro, zGyro))
    f.close()
    sys.exit(0)

sys.exit(1)
