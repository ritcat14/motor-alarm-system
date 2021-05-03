/**
*  @filename   :   TCP.cpp
*  @brief      :   Implements for sim800 4g hat raspberry pi demo
*  @author     :   Kaloha from Waveshare
*
*  Copyright (C) Waveshare     January 1 2019
*  http://www.waveshare.com / http://www.waveshare.net
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documnetation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to  whom the Software is
* furished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS OR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

#include "../arduPi.h"
#include "../sim800.h"

// Pin definition
int POWERKEY = 4;

/*********************TCP and UDP**********************/
char aux_string[50];
char server_ip[] = "118.190.93.84";
char port[] = "2317";
char message[] = "Waveshare Sending TCP data with socket_id";


void setup() {

	sim800c.PowerOn(POWERKEY);
	
	memset(aux_string, '\0', 50);
	


	if(sim800c.sendATcommand("AT+CSOC=1,1,1","+CSOC:",500)){
		printf("Created TCP socket id %d Successfully!\n",0);

	sim800c.sendATcommand("AT+CSOCON=0,2317,\"118.190.93.84\"",6000);
	sim800c.sendATcommand("AT+CSOSEND=0,0,\"Waveshare Send to Socket id 0 using TCP\"",6000);

	/***************Close all******************/
	printf("\n");
	sim800c.sendATcommand("AT+CSOCL=0",500);
	printf("Close Socket\n");

}


void loop() {

}

int main() {
	setup();
	return (0);
}