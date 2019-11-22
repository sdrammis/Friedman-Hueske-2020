#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  main.py
#  
#  Copyright 2015 delcasso <delcasso@delcasso-ephys>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

import os # library to walk in files and directories for listing
import time  #library to read the current date and time to create the output filename
import serial # library to  read data from arduino board through  usb connec tion

## Variables Setup By User

arduinoPort = '/dev/ttyACM1'
box = '4'
dataFolder =  "/home/snc-team/Dropbox (afried)/Dropbox (MIT)/SNc-Team/Behavior/Data/" 
#dataFolder =  "/home/snc-team/Dropbox (MIT)/SNc-Team/Behavior/Data/" old route pre 4/5/19
#dataFolder = "/home/snc-team/SNC-Team/SNC-Team/Behavior/Data/"  #QS: routing directly to Google Team Drive "SNC-Team"

user='@gmail.com'
pwd=''
recipient=user
subject= 'box' + box + 'done'
body=subject


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def send_email(user, pwd, recipient, subject, body):
    import smtplib

    gmail_user = user
    gmail_pwd = pwd
    FROM = user
    TO = recipient if type(recipient) is list else [recipient]
    SUBJECT = subject
    TEXT = body

    # Prepare actual message
    message = """\From: %s\nTo: %s\nSubject: %s\n\n%s
    """ % (FROM, ", ".join(TO), SUBJECT, TEXT)
    try:
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.ehlo()
        server.starttls()
        server.login(gmail_user, gmail_pwd)
        server.sendmail(FROM, TO, message)
        server.close()
        print 'successfully sent the mail'
    except:
        print "failed to send mail"



def get_filepaths(directory):
    """
    This function will generate the file names in a directory 
    tree by walking the tree either top-down or bottom-up. For each 
    directory in the tree rooted at directory top (including top itself), 
    it yields a 3-tuple (dirpath, dirnames, filenames).
    """
    file_paths = []  # List which will store all of the full filepaths.

    # Walk the tree.
    for root, directories, files in os.walk(directory):
        for filename in files:
            # Join the two strings in order to form the full filepath.
            filepath = os.path.join(root, filename)
            file_paths.append(filepath)  # Add it to the list.

    return file_paths  # Self-explanatory.


def filenameAssistan(dataFolder):

	# Run the above function and store its results in a variable.   
	full_file_paths = get_filepaths(dataFolder)

	print "\t~~~~~~~~~~~~~~~~~~~~~~"	
	print "\t~ Filename Assistant ~"	
	print "\t~~~~~~~~~~~~~~~~~~~~~~"	
	print ""	
	mouse = raw_input("\tMouse : ")
	if mouse == '':	
		useFilename = 'No';
	else:						
		# Store Mouse Names
		TaskList = [];
		for f in full_file_paths:
		  if f.endswith(".txt"):	
				f2= f.split('/')
				f2 = f2[len(f2)-1]
				if f2.startswith(mouse):
					f2 = f2.split('_')
					if len(f2) == 5:
						task=f2[1]	
						if task not in TaskList:			
							TaskList.append(task)							
		i=0		
		for t in TaskList:
			print "\t["+ str(i) +"] "+ t
			i+=1
			
		iTask = raw_input("\tTask : ");
		taskToFind=TaskList[int(iTask)]

		sessionList=[];
		for f in full_file_paths:
		  if f.endswith(".txt"):	
				f2= f.split('/')
				f2 = f2[len(f2)-1]
				if f2.startswith(mouse):
					f2 = f2.split('_')
					if len(f2) == 5:
						task=f2[1]	
						if task == taskToFind:
							#print f2
							session=f2[2];
							if session not in sessionList:			
								sessionList.append(int(session))		
		#print sessionList	

		iSessionMax=max(sessionList)

		newFilename = mouse + "_" +  taskToFind + "_%02d" %( iSessionMax+1)
		useFilename= raw_input("\tDo you accept the following filename :" + newFilename + " (Y) ? ")
		
	if useFilename != 'Y':
		newFilename= raw_input("\tEnter a new filename : ")
	#print "\t" + newFilename
	
	return newFilename


###################################################################



# configure the serial connections check in the arduino editor menu the name of the port  
# and the baudrate that are used to communicate with the arduin
ser = serial.Serial(
    port=arduinoPort,
    baudrate=115200,
    parity=serial.PARITY_ODD,
    stopbits=serial.STOPBITS_TWO,
    bytesize=serial.SEVENBITS
)

# Just in case the connection was still open from a previous execution of the program
if ser.isOpen():
	ser.close()
	
ser.open()
# The arduino is waiting for input, so we can flush input
# and ouput buffers at thea time for communication safety
ser.flushInput() 
ser.flushOutput()

# Variable used to display behavioral  measure during acquisition
nTrials=0
nRewards=0;
nLights=0
nLicks=0;
nStim=0;
nInterrupts=0;
strCurrentTime=""


# Creation of the ouput filename and opening of the file
print "\t\t~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
print "\t\t~ Behavioral Data Acquisition Software v1.0 ~"
print "\t\t~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
print ""

filename=filenameAssistan(dataFolder) 
from time import localtime, strftime
filename += strftime("_%Y%m%d-%H%M", localtime())
filename +=  "_box"+box+".txt"
filename =  dataFolder + filename;
#print("Name = " + filename)
subject= "box" + box  + " done"
fo = open(filename, "w")

responseShouldBe = "Let's Go!"
running=True
out = "";

print ""
print ""

print "\tArduino Could You Hear Us ??"
while running:
	print "\tPC ==> Do You Wanna Go?"	
	ser.write("Do You Wanna Go?")	
	out = ser.readline()
	out=out.strip() # to remove the end line char
	print("\tARDUINO ==> " + out)
	if out == responseShouldBe:
		running = False		
print("\tConnection with Arduino Established!");	
print ""
print ""
print "\tExperiment Started"
time.sleep(0.2)

out=""
c=""
h=0;
m=0;
s=0;
ms=0;

running = True
while running:
	
	if (ser.inWaiting() > 0):		
		
		#print "ser.inWaiting = " +str(ser.inWaiting())	
		out = ser.readline()		
		fo.write(out)
		out.replace('\n','')
		c = out.split("\t")
		value = c[2]
		value = value[:-1]		
		# print c[0] + "-" + c[1] + "-" + c[2]				
		ms=int(c[0]);
		s=int(ms/1000);
		h=int(s/3600);
		s=s-(h*3600);
		m=int(s/60);
		s=s-(m*60);
		ms = ms - (h*3600000) - (m*60000) - (s*1000);		
		strCurrentTime = str(h) + ":" + str(m) + ":" + str(s) + ":" + str(ms);
		if c[1]=="21": #TTL_EVT_TONE1_ON												
			nTrials+=1	
			print bcolors.WARNING + "\t" + strCurrentTime + "\tTONE_1 ON    trial #" + str(nTrials) + bcolors.ENDC
		if c[1]=="25": #TTL_EVT_TONE2_ON													
			nTrials+=1	
			print bcolors.WARNING + "\t" + strCurrentTime + "\tTONE_2 ON    trial #" + str(nTrials) + bcolors.ENDC
		if c[1]=="93": #TTL_EVT_TONE3_ON													
			nTrials+=1	
			print bcolors.WARNING + "\t" + strCurrentTime + "\tTONE_3 ON    trial #" + str(nTrials) + bcolors.ENDC
		if c[1]=="24": #TTL_EVT_TONE1_OFF													
			print bcolors.WARNING + "\t" + strCurrentTime + "\tTONE_1 OFF    trial #" + str(nTrials) + bcolors.ENDC
		if c[1]=="28": #TTL_EVT_TONE2_OFF													
			print bcolors.WARNING + "\t" + strCurrentTime + "\tTONE_2 OFF    trial #" + str(nTrials) + bcolors.ENDC
		if c[1]=="96": #TTL_EVT_TONE3_OFF													
			print bcolors.WARNING + "\t" + strCurrentTime + "\tTONE_3 OFF    trial #" + str(nTrials) + bcolors.ENDC
		elif c[1]=="13": #TTL_EVT_LICK
			nLicks+=1	
			print  bcolors.OKGREEN + "\t" + strCurrentTime + "\tLICK #" + str(nLicks) + bcolors.ENDC
		elif c[1]=="91": #END OF DECISION
			nLicks+=1	
			print  bcolors.HEADER + "\t" + strCurrentTime + "\tDEC. val=" + value + bcolors.ENDC	
		elif c[1]=="103": #INTERRPUT
			nInterrupts+=1	
			print  bcolors.OKBLUE + "\t" + strCurrentTime + "\tinterrupt #" + value + bcolors.ENDC
		elif c[1]=="14": #TTL_EVT_SOLENOID_ON
			nRewards+=1
			print  bcolors.OKBLUE + "\t" + strCurrentTime + "\tREWARD #" + str(nRewards) + bcolors.ENDC		
		elif c[1]=="18": #TTL_EVT_LED_PWM
			nLights+=1			       
			print  bcolors.FAIL   + "\t" + strCurrentTime + "\tLIGHT #" + str(nLights) + " " + str(int(value)) + " PWM" + bcolors.ENDC					
		elif c[1]=="6": #TTL_EVT_EXPSTOP
			running=False
			print "Experiment Stoped By Arduino"					
		#time.sleep(0.01)
	else:
		time.sleep(0.1)		
		c=""
		out=""
		


	
	
ser.close()		
fo.close()	 # 
#const int TTL_EVT_TRIAL_STOP               = 8;Close opend file
send_email(user, pwd, recipient, subject, body)



#//-------------------------------------------
#//TTL EVENT TYPE //SERIAL CODE FOR PROCESSING
#//-------------------------------------------
#const int TTL_EVT_PROGRAM_VERSION          = 1;
#const int TTL_EVT_MAX_TRIAL_NUMBER         = 2;
#const int TTL_EVT_MAX_REWARD_NUMBER        = 3;
#const int TTL_EVT_MAX_SESSION_DURATION     = 4;
#const int TTL_EVT_EXPERIMENT_START         = 5;
#const int TTL_EVT_EXPERIMENT_STOP          = 6;
#const int TTL_EVT_TRIAL_START              = 7;
#const int TTL_EVT_TRIAL_STOP               = 8;
#const int TTL_EVT_ITI_ON                   = 9;
#const int TTL_EVT_ITI_OFF                  = 10;
#const int TTL_EVT_ITI_MIN                  = 11;
#const int TTL_EVT_ITI_MAX                  = 12;
#const int TTL_EVT_LICK                     = 13;
#const int TTL_EVT_SOLENOID_ON              = 14;
#const int TTL_EVT_SOLENOID_DURATION        = 15;
#const int TTL_EVT_SOLENOID_OFF             = 16;
#const int TTL_EVT_LED_ON                   = 17;
#const int TTL_EVT_LED_PWM                  = 18;
#const int TTL_EVT_LED_DURATION             = 19;
#const int TTL_EVT_LED_OFF                  = 20;
#const int TTL_EVT_TONE1_ON                 = 21;
#const int TTL_EVT_TONE1_FREQ               = 22;
#const int TTL_EVT_TONE1_DURATION           = 23;
#const int TTL_EVT_TONE1_OFF                = 24;
#const int TTL_EVT_TONE2_ON                 = 25;
#const int TTL_EVT_TONE2_FREQ               = 26;
#const int TTL_EVT_TONE2_DURATION           = 27;
#const int TTL_EVT_TONE2_OFF                = 28;
#const int TTL_EVT_STATE                    = 29;
#const int TTL_EVT_EVENT                    = 30;
#const int TTL_EVT_CORRECT_REPONSE          = 31;
#const int TTL_EVT_INCORRECT_RESPONSE       = 32;
#const int TTL_EVT_OMISSION                 = 33;

#const int TTL_EVT_ITI_DURATION             = 34;
#const int TTL_EVT_EOD                      = 35;
#const int TTL_EVT_STIM_TYPE                = 36;
#const int TTL_EVT_STIM_ON                  = 37;
#const int TTL_EVT_STIM_DURATION            = 38;
#const int TTL_EVT_STIM_OFF                 = 39;
#const int TTL_EVT_BLOCK_SIZE               = 40;
#const int TTL_EVT_THRESHOLD                = 41;
#const int TTL_EVT_LIGHT_INTENSITY_START    = 42;
#const int TTL_EVT_LIGHT_INTENSITY_STEP     = 43;
#const int TTL_EVT_NOLIGHT_NTRIALS          = 44;
#
#const int TTL_EVT_MEGA_STATE               = 45;
#const int TTL_EVT_SLOW_SEARCH_STEP         = 46;
#const int TTL_EVT_FAST_SEARCH_STEP         = 47;
#const int TTL_EVT_BASELINE_THRESHOLD       = 48;
#const int TTL_EVT_SLOW_SEARCH_THRESHOLD    = 49;
#const int TTL_EVT_FAST_SEARCH_THRESHOLD    = 50;
#const int TTL_EVT_BASELINE_SIZE            = 51;
#const int TTL_EVT_SLOW_SEARCH_SIZE         = 52;
#const int TTL_EVT_FAST_SEARCH_SIZE         = 53;
#
#const int TTL_EVT_SLOW_SEARCH_STARTING_POINT = 54;
#
#const int TTL_EVT_NSUCC_TEST = 55;
#const int TTL_EVT_LED_VOLTAGE_MV = 56;
#const int TTL_EVT_OFFER_ACCEPTED = 57;
#const int TTL_EVT_OFFER_REJECTED = 58;
#const int TTL_EVT_AFTERTONEDELAYMSEC = 59;
#const int TTL_EVT_RESPONSEDURATIONMSEC = 60;
#
#const int TTL_EVT_DELAYBEFORETONEMSEC = 61;
#const int TTL_EVT_DELAYAFTEROFFERMSEC = 62;
#
#const int TTL_EVT_SERVOPOSITION = 63;
#
#const int TTL_EVT_AFTERDECISIONDELAYMSEC = 64;
#const int TTL_EVT_CONSUMPTIONPERIODMSEC  = 65;
#const int TTL_EVT_CONSUMPTIONLICKNUMBER  = 66;
#const int TTL_EVT_TRIALTYPE              = 67;
#const int TTL_EVT_MAXWAITFORFIRSTLICKMSEC = 68;
#
#const int TTL_EVT_QUENCHINGPERIODMSEC  = 69;
#const int TTL_EVT_QUENCHINGLICKNUMBER  = 70;
#const int TTL_EVT_REST_ON  = 71;
#const int TTL_EVT_QUENCHING_ON  = 72;
