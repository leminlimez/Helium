WORKING_LOCATION="$(pwd)"
APP_BUILD_FILES="$WORKING_LOCATION/layout/Applications/Helium.app"
DEBUG_LOCATION="$WORKING_LOCATION/.theos/obj/debug"
BUILD_LOCATION="$DEBUG_LOCATION/Helium.app"

if [ ! -d "build" ]; then
    mkdir build
fi
#remove existing archive if there
if [ -d "build/Helium.tipa" ]; then
    rm -rf "build/Helium.tipa"
fi

make

if [ -d ".theos/obj/debug/Helium.app" ]; then
	# Add the necessary files
	echo "Adding application files"
	cp -r "$APP_BUILD_FILES/icon.png" "$BUILD_LOCATION/icon.png"
	cp -r "$APP_BUILD_FILES/Info.plist" "$BUILD_LOCATION/Info.plist"
	cp -r "$APP_BUILD_FILES/Assets.car" "$BUILD_LOCATION/Assets.car"
	cp -r "$APP_BUILD_FILES/en.lproj" "$BUILD_LOCATION/"
	cp -r "$APP_BUILD_FILES/zh-Hans.lproj" "$BUILD_LOCATION/"
	cp -r "$APP_BUILD_FILES/fonts" "$BUILD_LOCATION/"
	
	# Create payload
	echo "Creating payload"
	cd build
	mkdir Payload
	cp -r $BUILD_LOCATION Payload/Helium.app
	
	# Archive
	echo "Archiving"
	strip Payload/Helium.app/Helium
	zip -vr Helium.tipa Payload
	rm -rf Helium.app
	rm -rf Payload
fi
