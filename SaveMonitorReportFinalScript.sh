#!/bin/bash
##################################################################################################################################################
#Author: Hussein Bakri
#Script Title: OpenSim Monitor Report Script
#License: GNU GPL v3 License - you are free to distribute, change, enhance and include any of the code of this script in your tools. I only expect #adequate attribution of this work. The attribution should include the title of the script, the author and the site or the document where the #script is taken from.
#----- monitor report OpenSim console command-----
#This shell script saves statistics every 3 seconds for 3 minutes (during 180 seconds) from the OpenSim console command "monitor report"
#It utilizes the OpenSim Console command "monitor report" and the Linux screen command
#The challenge solved is to get the output back from the screen command that is sent through -X Stuff "Monitor report"  file for later analysis
#and store that output in a single CSV file for later statistical analysis ((a CSV file is easier to give to a statistical software).parse 
#This script may generate many files but do a great job in parsing.
#This script create a folder named monitor (please give it the adequate permissions)
##################################################################################################################################################
echo "Let us begin the retrieval of statistics that comes from the monitor report command in the OpenSim server."
echo 
echo "Retrieval is done every 3 seconds for 3 minutes or during 180 seconds (i.e 60 values intake)"
echo

filenumber=0

echo "Creating a screen session for OpenSim server named: OpenSimSession..."
echo
screen -S OpenSimSession -d -m
sleep 3

echo "Launching the OpenSim server through the mono framework by using screen -S OpenSimSession -X stuff ..."
screen -S OpenSimSession -X stuff 'mono OpenSim.exe'`echo -ne '\015'`

echo "Please wait untill OpenSim server loads completely (it might take several minutes)...."
#########################################################################################################
sleep 700 			#### change denpending on startup time of the OpenSim world
				#### Example: Cathedral takes 8 minutes and 17 seconds (497 seconds) to load
				#### Give always additional time.
##########################################################################################################

echo "I finished loading OpenSim server in the screen session created previously. Moving on to the next step..."
sleep 3
echo "Please go and launch any avatar mobility script(s)/ Viewers etc..."
sleep 2
read -rsp $'When ready, Press any key in this terminal to continue - terminal should be in focus...\n' -n1 key

echo "Creating a folder called monitor...."
mkdir -p monitor
echo

echo "Sending now monitor report command in a loop" 
echo "Using  -hardcopy option with the screen...Saving in monitor/FILOn file - please wait...."
while [ $filenumber -lt 60 ]
do
screen -r OpenSimSession -X stuff $'monitor report\n'
sleep 2

# it create a file of the whole Screen session whenever a the monitor report OpenSim command is sent
screen -r OpenSimSession -X hardcopy -h monitor/FILO${filenumber}

sleep 1
((filenumber++))
done

echo
echo "I finished the loop (saving every 3 seconds - monitor report stats in a file (FILO), you should have 60 files (180/3) stats txt files in your folder...."
echo

echo "Now shutting down OpenSim server.... "
echo "Please go and terminate or shutdown any avatar mobility script(s)/ Viewers etc..."
sleep 2
read -rsp $'When ready, Press any key in this terminal to continue - terminal should be in focus...\n' -n1 key


echo "Putting into effect the Shutdown of OpenSim server"
echo "..."
sleep 4


echo "Sending a shutdown to the OpenSim server - it takes time (several minutes), please wait..."
screen -r OpenSimSession -X stuff $'shutdown\n'		#sending a shutdown command 

#########################################################################################################
sleep 60	 		#### time to wait for OpenSim to shutdown – normally should be higher
				#### change denpending on startup time of the OpenSim world
				#### Give always additional time.
##########################################################################################################

echo "Making sure that OpenSim is closed..."
OpenSimID=`ps –ef | grep OpenSim |grep ‘mono OpenSim.exe’ | gawk ‘{ print $2 }’`
kill -9 $OpenSimID

echo "Exiting the screen session itself...." 
sleep 2
screen -r OpenSimSession -X stuff $'exit\n' #exiting the session itself (i.e terminating)
echo
echo "Moving on to the phase of parsing the files in the final aim of making one CSV file..."
echo
######################################################################################################################
######################################################################################################################
######################################################################################################################
read -rsp $'When ready, Press any key in this terminal to continue - terminal should be in focus...\n' -n1 key

echo
sleep 2
echo " 1st step: tail the last 34 lines from all files (named FILO) in monitor folder retrieved previously - output: tailedFileN - please wait..."
sleep 1
number=0
while [ $number -lt 60 ]
do
########################################################################################################################
tail -n 34 monitor/FILO${number} > monitor/tailedFile${number}		#####Change the number 34 depending on the world
########################################################################################################################
sleep 1
((number++))
done

echo

echo " 2nd step: remove spaces but keep the  new lines - output: SpacesRemovedN - please wait..."
sleep 1
read -rsp $'When ready, Press any key in this terminal to continue - terminal should be in focus...\n' -n1 key
echo
sleep 2

number=0
while [ $number -lt 60 ]
do
cat monitor/tailedFile${number} | tr -d " \t\r" > monitor/SpacesRemoved${number} 
sleep 1
((number++))
done

echo

echo " 3rd step: remove last lines - output: lastLineGoneN - please wait..."
sleep 1
read -rsp $'When ready, Press any key in this terminal to continue - terminal should be in focus...\n' -n1 key
echo
sleep 2
number=0
while [ $number -lt 60 ]
do
sed '$ d' monitor/SpacesRemoved${number} > monitor/lastLineGone${number}  
sleep 1
((number++))
done

echo

echo "4th step:  Deleting [MONITORMODULE]: from the files - output: lastLineGoneN files but changed - please wait..."
sleep 1
read -rsp $'When ready, Press any key in this terminal to continue - terminal should be in focus...\n' -n1 key
echo
sleep 2
number=0
while [ $number -lt 60 ]
do
sed -i -e "s/\[MONITORMODULE\]\://g" monitor/lastLineGone${number} 
sleep 1
((number++))
done

echo
echo

echo "5th Step: Transform all lastLineGoneN files into CSV files of one data row + header - output: CSVFileN.csv-  please wait..."
echo "Transforming the files into a CSVs - please wait..."
echo
sleep 1
read -rsp $'When ready, Press any key in this terminal to continue - terminal should be in focus...\n' -n1 key
echo
sleep 2
number=0
while [ $number -lt 60 ]
do
awk -F= '{a[NR,1]=$1;a[NR,2]=$2}
         END{
            for(i=1; i<NR; i++){
                printf a[i,1] ","
            }
            print a[i,1]; 
            for(i=1; i<NR; i++){
                printf "%s", a[i,2]+0
            } 
            print a[i,2];
        }' monitor/lastLineGone${number} > monitor/CSVFile${number}.csv
sleep 1
((number++))
done

echo
echo
sleep 2
echo "Final Step: Merging all CSV files into one single CSV file, keeping the header of the first file- output final.csv - please wait..."
echo
sleep 1
read -rsp $'When ready, Press any key in this terminal to continue - terminal should be in focus...\n' -n1 key
echo
sleep 2
number=0
cat monitor/CSVFile${number}.csv > monitor/final.csv
((number++))
while [ $number -lt 60 ]
do
tail -n 1 monitor/CSVFile${number}.csv >> monitor/final.csv
sleep 1
((number++))
done

echo "Please check now the file final.csv in monitor folder- is everything fine?"
echo "Fin"













