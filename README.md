# Miqrob

Turn your iOS SaveGame into a DEB file.


1- go to Cydia and add this repo

      http://repo.kurdios.com

2- install "Kurd Patcher" and "curl" from Cydia.

Put your hack files to /var/root/hacks/hack

3- run this Script "Miqrob"

# Usage: #
  miqrob <id>
	
  id = id of the app in appstore
  
	Will get information about the app from appstore :) you should have internet for sure.
	
  
  miqrob
  
	You should manually add information :(  just miqrob without <id>
	
# Sample
https://itunes.apple.com/app/id553834731 using this app as example :) id : 553834731
sh miqrob.sh 553834731

# OutPut
after running the script finally it will give you Debian file .deb you can use it 
 ** Remember your debian file works only if "kurd-patcher" installed so don't remove it in Depends.
 

# Support
All Device's running iOS (iPad, iPhone, iPod)

All iOS versions ( iOS 5 - iOS 11.4)

# TESTED ON
iPad, iPhone ( iOS 6,7,8,9,11)


