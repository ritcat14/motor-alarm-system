/**
*  @filename   :   sim800c.cpp
*  @brief      :   Implements for sim800 library
*  @author     :   Kaloha from Waveshare
*
*  Copyright (C) Waveshare     January 1 2019
*  http://www.waveshare.com  http://www.waveshare.net
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


#include "sim800.h"
#include "arduPi.h"

sim800::sim800(){
}

sim800::~sim800(){
}


/**************************Power on sim800**************************/
void sim800::PowerOn(int PowerKey = powerkey){
   uint8_t answer = 0;

	Serial.begin(115200);

	// checks if the module is started
	answer = sendATcommand("AT", "OK", 500);
	if (answer == 0)
	{
		printf("Starting up...\n");

		
		pinMode(PowerKey, OUTPUT);
		// power on pulse
		digitalWrite(PowerKey, HIGH);
		delay(1000);
		digitalWrite(PowerKey, LOW);
		
		// waits for an answer from the module
		while (answer == 0) {     // Send AT every two seconds and wait for the answer
			answer = sendATcommand("AT", "OK", 2000);
		}

	}

    printf("Wait 5 seconds...\n");
	delay(2000);

    /*************Firmware version*************/
    sendATcommand("AT+CGMR",500);

    /*************Network environment checking*************/
    sendATcommand("AT+CPIN?",500);
	sendATcommand("AT+CSQ",500);
	sendATcommand("AT+CGREG?", "+CREG: 0,1", 500);

	while ((sendATcommand("AT+CGREG?", "+CGREG: 0,1", 500) || sendATcommand("AT+CGACT?", "AT+CGACT?", 500)) == 0)
		delay(500);

    sendATcommand("AT+COPS?",500);

    printf("The module starts...\n");
}

/**************************Phone Calls**************************/
/*
void sim800::PhoneCall(const char* PhoneNumber) {
	char aux_str[30];

	sprintf(aux_str, "ATD%s;", PhoneNumber);
	sendATcommand(aux_str, "OK", 10000);

	delay(50000);

	Serial.println("AT+CHUP");            // disconnects the existing call
	printf("Call disconnected\n");
}*/

/**************************SMS sending and receiving message **************************/
//SMS sending short message
bool sim800::SendingShortMessage(const char* PhoneNumber,const char* Message){
	uint8_t answer = 0;
	char aux_string[30];

	printf("Setting SMS mode...\n");
    sendATcommand("AT+CMGF=1", "OK", 1000);    // sets the SMS mode to text
    printf("Sending Short Message\n");
    
    sprintf(aux_string,"AT+CMGS=\"%s\"", PhoneNumber);

   answer = sendATcommand(aux_string, ">", 2000);    // send the SMS number
    if (answer == 1)
    {
        Serial.println(Message);
        Serial.write(0x1A);
        answer = sendATcommand("", "OK", 20000);
        if (answer == 1)
        {
            printf("Sent successfully \n"); 
			return true;   
        }
        else
        {
            printf("error \n");
			return false;
        }
    }
    else
    {
        printf("error %o\n",answer);
		return false;
    }
}

//SMS receiving short message
bool sim800::ReceivingShortMessage(){
	uint8_t answer = 0;
	int i = 0;
	char RecMessage[200];

	printf("Setting SMS mode...\n");
    sendATcommand("AT+CMGF=1", "OK", 1000);    // sets the SMS mode to text
	sendATcommand("AT+CPMS=\"SM\",\"SM\",\"SM\"", "OK", 1000);    // selects the memory

    answer = sendATcommand("AT+CMGR=1", "+CMGR:", 2000);    // reads the first SMS

	if (answer == 1)
    {
        answer = 0;
        while(Serial.available() == 0);
        // this loop reads the data of the SMS
        do{
            // if there are data in the UART input buffer, reads it and checks for the asnwer
            if(Serial.available() > 0){    
                RecMessage[i] = Serial.read();
                i++;
                // check if the desired answer (OK) is in the response of the module
                if (strstr(RecMessage, "OK") != NULL)    
                {
                    answer = 1;
                }
            }
        }while(answer == 0);    // Waits for the asnwer with time out
        
        RecMessage[i] = '\0';
        
        printf("%s\n",RecMessage);    
        
    }
    else
    {
        printf("error %o\n",answer);
		return false;
    }

	return true;
}


/**************************Other functions**************************/
char sim800::sendATcommand(const char* ATcommand, unsigned int timeout) {
	uint8_t x = 0, answer = 0;
	char response[200];
	unsigned long previous;
	memset(response, '\0', 200);    // Initialize the string

	delay(100);

	while (Serial.available() > 0) Serial.read();    // Clean the input buffer

	Serial.println(ATcommand);    // Send the AT command 

	previous = millis();

	// this loop waits for the answer
	do {
		// if there are data in the UART input buffer, reads it and checks for the asnwer
		if (Serial.available() != 0) {
			response[x] = Serial.read();
			printf("%c", response[x]);
			x++;
		}
		
	} while ((answer == 0) && ((millis() - previous) < timeout));

	return answer;
}

char sim800::sendATcommand(const char* ATcommand, const char* expected_answer, unsigned int timeout) {

	char x = 0, answer = 0;
	char response[200];
	unsigned long previous;

	memset(response, '\0', 200);    // Initialize the string

	delay(100);

	while (Serial.available() > 0) Serial.read();    // Clean the input buffer

	Serial.println(ATcommand);    // Send the AT command 


	x = 0;
	previous = millis();

	// this loop waits for the answer
	do {
		if (Serial.available() != 0) {
			// if there are data in the UART input buffer, reads it and checks for the asnwer
			response[x] = Serial.read();
			printf("%c", response[x]);
			x++;
			// check if the desired answer  is in the response of the module
			if (strstr(response, expected_answer) != NULL)
			{
				printf("\n");
				answer = 1;
			}
		}
	}
	// Waits for the asnwer with time out
	while ((answer == 0) && ((millis() - previous) < timeout));

	return answer;
}

char sim800::sendATcommand2(const char* ATcommand, const char* expected_answer1, const char* expected_answer2, unsigned int timeout){
	uint8_t x=0,  answer=0;
    char response[100];
    unsigned long previous;

    memset(response, '\0', 100);    // Initialize the string

    delay(100);

    while( Serial.available() > 0) Serial.read();    // Clean the input buffer

    Serial.println(ATcommand);    // Send the AT command 

    x = 0;
    previous = millis();

    // this loop waits for the answer
    do{
        // if there are data in the UART input buffer, reads it and checks for the asnwer
        if(Serial.available() != 0){    
            response[x] = Serial.read();
            printf("%c",response[x]);
            x++;
            // check if the desired answer 1  is in the response of the module
            if (strstr(response, expected_answer1) != NULL)    
            {
				printf("\n");
                answer = 1;
            }
            // check if the desired answer 2 is in the response of the module
            else if (strstr(response, expected_answer2) != NULL)    
            {
				printf("\n");
                answer = 2;
            }
        }
    }
    // Waits for the asnwer with time out
    while((answer == 0) && ((millis() - previous) < timeout));    

    return answer;

}

sim800 sim800c = sim800();

