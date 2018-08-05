#!/bin/sh
# MIQROB 1.0 22/7/2018
# Karwan BK (karwanbk@yahoo.com)
# REQUIRED (wget, plutil, curl)


if [ ! -f "/var/root/hacks" ]; then
mkdir -p /var/root/hacks
mkdir -p /var/root/hacks/debs
mkdir -p /var/root/hacks/hack
fi

function usage () {
echo ""
echo "#################################"
echo "Put your hack files to /var/root/hacks/hack"
echo "#################################"

echo "Welcome to Miqrob Hack Maker !"
sleep .1
echo "This Script only working on Kurd-Patcher"
echo ""
sleep .1
	echo "# Usage: #"
	echo "- miqrob <id>"
	echo " id = id of the app in appstore"
	echo " Will get information about the app from appstore :) "
	echo ""
	echo "- miqrob"
	echo " You should manually add information :( "
	echo ""
}
function itunes () {
            online="yes"
			first='http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStoreServices.woa/wa/wsLookup?id='
			output=$(curl -H -d -s "$first""$appid")
			code=$(echo "$output" | tr '{', '\n' | sed -n "2p" | sed -e 's/:/ /' | awk '{print $2}')
			string=$(echo "$output" | tr '{', '\n' | sed -e '/"signature":\(.*\)/d;/"data":\(.*\)/d;/"signature":\(.*\)/d;/"code":\(.*\)/d' |sed -e 's/\\"//g;s/\\\\\\\//\//g;s/\\//g' | tr '}', '\n' | sed -e 's/"//' | sed '/^$/d')
			echo "$string">/var/root/hacks/tempappinfo
			
			#get the bundleid
			bi=$(sed -n '/bundleId":"/p' /var/root/hacks/tempappinfo)
			BundleID=$(echo $bi | awk -v w1="bundleId\":\"" -v w2="\"" 'match($0, w1 ".*" w2){
			print substr($0,RSTART+length(w1),RLENGTH-length(w1 w2))}')
			
			#get the app version
			Work_Version=$(sed -n '/version":"/p' /var/root/hacks/tempappinfo)
			Work_Version=$(echo $Work_Version | awk -v w1="version\":\"" -v w2="\"" 'match($0, w1 ".*" w2){
print substr($0,RSTART+length(w1),RLENGTH-length(w1 w2))}')
			
			#get the app name
			appname=$(sed -n '/trackCensoredName":"/p' /var/root/hacks/tempappinfo)
			appname=$(echo $appname | awk -v w1="trackCensoredName\":\"" -v w2="\"" 'match($0, w1 ".*" w2){
			print substr($0,RSTART+length(w1),RLENGTH-length(w1 w2))}')
			Name=$(printf "$appname")
			
			#image
			image=$(sed -n '/artworkUrl100":"/p' /var/root/hacks/tempappinfo)
			image=$(echo $image | awk -v w1="artworkUrl100\":\"" -v w2="\"" 'match($0, w1 ".*" w2){
print substr($0,RSTART+length(w1),RLENGTH-length(w1 w2))}')
}

function clean () {
echo -n "Cleaning .. "
rm -rf /var/root/hacks/tempappinfo
echo " Done"
echo ""
exit 0;
}


 # info file
 
function info () {
now=`date`
cd "/var/root/hacks/"
mkdir -p "$pName"
mkdir -p "$pName"/DEBIAN
mkdir -p "$pName"/var/mobile/Library/kurd-patcher

cd "$pName/var/mobile/Library/kurd-patcher/" && wget "$image" --no-check-certificate &>/dev/null && mv "100x100bb.jpg" $pName.png

echo -n "Making info File .." && sleep 1
file="$pName.plist"
if [ ! -f "$file" ]; then
plutil -create "$file" 2>&1> /dev/null
plutil -key "BundleID" -string $BundleID "$file" 2>&1> /dev/null
plutil -key "Name" -string "$Name" "$file" 2>&1> /dev/null
plutil -key "Work_Version" -string $Work_Version "$file" 2>&1> /dev/null
plutil -key "No_Backup" -string $No_Backup "$file" 2>&1> /dev/null
plutil -key "Type" -string $Type "$file" 2>&1> /dev/null
plutil -key "MIQROB" -string "Made with MIQROB On $now" "$file" 2>&1> /dev/null
fi
if [ "$Work_Version" == "ALL" ];then
Work_Version="1.0"
fi
echo " Done !"
}

  # where does your hack go
  
function where () {
echo ""
echo "-----------------------------"
echo "- Where Dose Your Hack Go ? .HackType"
echo ""
echo "1> Documents"
echo "2> Library"
echo "3> Library/Preferences"
echo "4> .APP folder"        
echo "5> Documents & Library Together"
echo ""

if [ -f /var/root/hacks/hack/*.plist ]; then
Type="LP"
echo "- Enter Hack Type $Type"
else
read -p "- HackType (1,2,3,4,5) " "Type";
fi

if [ -z "$BundleID" ]; then
read -p "- Enter Bundle ID of the App. " "BundleID";
read -p "- APP Name. " "Name";
read -p "- Work Version (ALL). " "Work_Version";
else
echo ""
echo "- Bundle ID of the App. $BundleID";
echo "- APP Name. $Name";
echo "- Work Version. $Work_Version";
fi
read -p "- Com.Kurdios." "pName";
read -p "- No Backup Mode (Y) for large files it won't backup user data. " "No_Backup";
echo "-----------------------------"

if [[ "$Name" == "exit" || "$pName" == "exit" || "$Work_Version" == "exit" || "$No_Backup" == "exit" || "$Type" == "exit" ]];then
clean
fi
if [[ "$Name" == "" || "$pName" == "" || "$Work_Version" == "" ]];then
clean
fi
if [ "$No_Backup" == "" ] || [ ! "$No_Backup" = "Y" ] || [ ! "$No_Backup" = "y" ];then
No_Backup="N"
else
No_Backup="Y"
fi
if [ "$Type" == "1" ] || [ "$Type" == "D" ] || [ "$Type" == "d" ];then
Type="D"
fi
if [ "$Type" == "2" ] || [ "$Type" == "L" ] || [ "$Type" == "l" ];then
Type="L"
fi
if [ "$Type" == "3" ] || [ "$Type" == "LP" ] || [ "$Type" == "lp" ];then
Type="LP"
fi
if [ "$Type" == "4" ] || [ "$Type" == "A" ] || [ "$Type" == "a" ];then
Type="A"
fi
if [ "$Type" == "5" ] || [ "$Type" == "D/L" ] || [ "$Type" == "d/l" ] || [ "$Type" == "L/D" ];then
Type="D/L"
fi
}

  # zip file and deb file
  
function file_deb () {
	if [ ! -f "/var/root/hacks/hack/$pName.zip" ]; then
	echo -n "Making Hack zip .."
	    if [ ! "$(ls -A "/var/root/hacks/hack/")" ]; then
	    echo " ERROR !"
	    echo " No hack file's found in /var/root/hacks/hack/" && rm -rf "$pName" && clean
	    fi
		if [ ! -f "/var/root/hacks/hack/$pName" ]; then
		zip_file="/var/root/hacks/hack/"
		else
		zip_file="/var/root/hacks/hack/$pName"
		fi
    cd "$zip_file" && zip "$pName.zip" `find -type f -print0 | xargs -0 ls -t` 2>&1> /dev/null
	mv "$pName.zip" "/var/root/hacks/$pName/$pName.zip"
    echo " Done !"
	else
	echo -n "We found zip file.."
	cp -rf "/var/root/hacks/hack/$pName.zip" "/var/root/hacks/$pName/$pName.zip"
	echo " Done !"
	fi
	
	if [ ! -f "/var/root/hacks/$pName/$pName.zip" ]; then
	echo "NO zip file found !"
	clean
	fi
	
echo -n "Making Control File .."
echo "Package: com.kurdios.$pName
Name: $Name Hack
Version: $Work_Version
Section: Kurd Games
Architecture: iphoneos-arm
Description: $Name hack by KurdiOS team!
Depiction: http://repo.kurdios.com/depiction/package/$pName
Homepage: http://repo.kurdios.com/depiction/package/$pName
Depends: com.kurdios.kurd-patcher
Author: KurdiOS Team <repo@kurdios.com>
Sponsor: KurdiOS Team <repo.kurdios.com>
dev: kurd-patcher
Maintainer: KurdiOS Team <repo@kurdios.com>
Icon: file:///var/mobile/Library/kurd-patcher/$pName.png" >"/var/root/hacks/$pName/DEBIAN/control"
echo " Done !"

echo -n "Making Postinst File .." && sleep 1
echo "#!/bin/sh
kurd-patcher \"$pName\" \"i\" \"-p\"
" >"/var/root/hacks/$pName/DEBIAN/postinst"
echo " Done !"

echo -n "Making Prerm File .." && sleep 1
echo "#!/bin/sh
kurd-patcher \"$pName\" \"r\"
" >"/var/root/hacks/$pName/DEBIAN/prerm"
echo " Done !"

echo -n "Changing Chmod .." && sleep 1
cd "/var/root/hacks/$pName/DEBIAN"
chmod 775 prerm 2>&1> /dev/null
chmod 775 postinst 2>&1> /dev/null
chmod 775 control 2>&1> /dev/null
echo " Done !"
echo ""
read -p "- Last Step before making deb file check your hack .. " "enter";
echo ""
echo -n "Making deb file .."
dpkg-deb -b -Zgzip "/var/root/hacks/$pName" "/var/root/hacks/debs" &>/dev/null
if [ -f /var/root/hacks/debs/com.kurdios.$pName*_*$Work_Version*_iphoneos-arm.deb ]; then
echo "DONE!"
else 
echo "DEB NOT CREATED !
/var/root/hacks/debs/com.kurdios.$pName*_*$Work_Version*_iphoneos-arm.deb"
fi
clean
}

#here script go
[ `id -u` != 0 ] && exec echo "You Must be root to run this script."

if [ -n "$1" ]; then
    if [[ "$1" == "-help" || "$1" == "-usage" || "$1" == "-USAGE" || "$1" == "-h"  || "$1" == "help"   || "$1" == "HELP" ]]; then
	usage
	exit 0;
	fi
	appid="$1"
	if [[ ! -n ${appid//[0-9]/} ]]; then
    itunes
    fi
fi

echo ""
echo "Welcome to Miqrob SaveGame DEB builder !"
sleep .1
echo " #By : Karwan BK (karwanbk@yahoo.com)"
echo ""
echo " ## miqrob -help
    for showing help"
sleep .1
echo ""
echo "#################################"
echo "Put your hack files to /var/root/hacks/hack"
echo "#################################"

echo ""
echo "-----------------------------"
echo "- Wanna hack something ?"
echo ""
echo "1> APP installed"
echo "2> APP NOT installed"
echo ""
read -p "- Enter Option Number (1/2) " "have";
echo "-----------------------------"
	echo ""
if [ "$have" == "1" ];then
        if [ "$online" == "yes" ];then
		kurd-patcher $BundleID
		doc=$(cat "/var/mobile/temp.temp" 2>/dev/null)
	    app=$(cat "/var/mobile/tempapp.temp" 2>/dev/null)
		else
        kurd-patcher applist
	    doc=$(cat "/var/mobile/temp.temp" 2>/dev/null)
	    app=$(cat "/var/mobile/tempapp.temp" 2>/dev/null)
	    BundleID=$(plutil -key CFBundleIdentifier $app/Info.plist)
    if grep -q "CFBundleShortVersionString" "$app/Info.plist"
    then Work_Version=$(plutil -key CFBundleShortVersionString "$app/Info.plist")
    else Work_Version=$(plutil -key CFBundleVersion "$app/Info.plist")
    fi
	
    if grep -q "CFBundleDisplayName" "$app/Info.plist"
    then Name=$(plutil -key CFBundleDisplayName "$app/Info.plist")
    else Name=$(plutil -key CFBundleName "$app/Info.plist")
    fi
		fi
	echo ""
	where
	    if [ "$Type" == "D" ];then
		loc="$doc/Documents"
		fi
	    if [ "$Type" == "L" ];then
		loc="$doc/Library"
		fi
	    if [ "$Type" == "LP" ];then
		loc="$doc/Library/Preferences"
		fi
	    if [ "$Type" == "D/L" ];then
        loc="$doc"
		fi
		echo ""
		read -p "- You want your app files as hack files ? (y=yes) " "have";
		if [ "$have" == "y" ];then
	        if [ "$Type" == "A" ];then
            echo "not supporting yet!"
		    else
		echo -n "- Putting your files into hack folder "
		rm -rf "/var/root/hacks/hack/*"
		cp -rf "$loc"/* "/var/root/hacks/hack/"
		echo "Done !"
		    fi

		fi
	echo ""
	info
	file_deb
else
    if [ "$have" == "2" ];then
    where
	info
	file_deb
	else
	echo "" && clean
	fi
fi
