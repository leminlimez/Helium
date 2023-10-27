WORKING_LOCATION="$(pwd)"
APP_BUILD_FILES="$WORKING_LOCATION/layout/Applications/XXTAssistiveTouch.app"
DEBUG_LOCATION="$WORKING_LOCATION/.theos/obj/debug"
BUILD_LOCATION="$DEBUG_LOCATION/XXTAssistiveTouch.app"

if [ ! -d "build" ]; then
    mkdir build
fi
#remove existing archive if there
if [ -d "build/Helium.tipa" ]; then
    rm -rf "build/Helium.tipa"
fi

make

if [ -d ".theos/obj/debug/XXTAssistiveTouch.app" ]; then
	# Add the necessary files
	echo "Adding application files"
	cp -r "$APP_BUILD_FILES/icon.png" "$BUILD_LOCATION/icon.png"
	cp -r "$APP_BUILD_FILES/Info.plist" "$BUILD_LOCATION/Info.plist"
	cp -r "$APP_BUILD_FILES/Assets.car" "$BUILD_LOCATION/Assets.car"
	
	# Create payload
	echo "Creating payload"
	cd build
	mkdir Payload
	cp -r $BUILD_LOCATION Payload/XXTAssistiveTouch.app
	
	# Archive
	echo "Archiving"
	strip Payload/XXTAssistiveTouch.app/XXTAssistiveTouch
	zip -vr Helium.tipa Payload
	rm -rf XXTAssistiveTouch.app
	rm -rf Payload
fi
