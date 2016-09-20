# GatheringQoSOpenSimReportCommand
A shell script that gather QoS statistics through "monitor report" OpenSim console command

monitor report OpenSim console command
---------------------------------------
#This shell script saves statistics every 3 seconds for 3 minutes (during 180 seconds) from the OpenSim console command "monitor report"
#It utilizes the OpenSim Console command "monitor report" and the Linux screen command
#The challenge solved is to get the output back from the screen command that is sent through -X Stuff "Monitor report"  file for later analysis
#and store that output in a single CSV file for later statistical analysis ((a CSV file is easier to give to a statistical software).parse 
#This script may generate many files but do a great job in parsing.
#This script create a folder named monitor (please give it the adequate permissions)
