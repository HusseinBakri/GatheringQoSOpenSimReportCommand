# GatheringQoSUsingOpenSimReportCommand
A shell script that gathers QoS Server statistics using the "monitor report" OpenSim console command and the GNU "screen" command. It retrieve back the results and parse them and transform them into a csv file that can be fetched to a statistical tool later.

Author
-----
Hussein Bakri

Program Name
-----------
GatheringQoSUsingOpenSimReportCommand 1.0

License
-------
This program is licensed under GNU GPL v3 License - you are free to distribute, change, enhance and include any of the code of this application in your tools.
I only expect adequate attribution of this work. The attribution should include the title of the program, the author and the site or the document where the program is taken from.

Description
-----------
This shell script saves statistics every 3 seconds for 3 minutes (during 180 seconds) from the OpenSim console command "monitor report"
In other words, It utilizes the OpenSim Console command "monitor report" and the Linux GNU screen command. 
The challenge solved: is to get the output back from the GNU screen command that is sent through -X Stuff "Monitor report"  file for later analysis and store that output in a single CSV file for later statistical analysis ((a CSV file is easier to give to a statistical software). 
This script may generate many files [that can be improved] but do a great job in parsing.
This script create a folder named monitor (please give it the adequate permissions)


Technicalities
-------------
Set adequate permissions for the Linux shell script to run.
Please don't run it immediately, change the time to wait for loading/shutting down OpenSim world depending on your world.
The script should reside in the bin folder of OpenSim server

TODO
-----
1)needs improvement

Enjoy!
