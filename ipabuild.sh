if [[ $* == *--scriptdebug* ]]; then
    set -x
fi
set -e

WORKING_LOCATION="$(pwd)"
APP_BUILD_FILES="$WORKING_LOCATION/layout/Applications/Helium.app"
DEBUG_LOCATION="$WORKING_LOCATION/.theos/obj/debug"
RELEASE_LOCATION="$WORKING_LOCATION/.theos/obj"
if [[ $* == *--debug* ]]; then
    BUILD_LOCATION="$DEBUG_LOCATION/Helium.app"
else
    BUILD_LOCATION="$RELEASE_LOCATION/Helium.app"
fi

if [[ $* == *--clean* ]]; then
    echo "[*] Cleaning..."
    rm -rf build
    make clean
fi

if [ ! -d "build" ]; then
    mkdir build
fi
#remove existing archive if there
if [ -d "build/Helium.tipa" ]; then
    rm -rf "build/Helium.tipa"
fi

if ! type "gmake" >/dev/null; then
    echo "[!] gmake not found, using macOS bundled make instead"
    make clean
    if [[ $* == *--debug* ]]; then
        make
    else
        make FINALPACKAGE=1
    fi
else
    gmake clean
    if [[ $* == *--debug* ]]; then
        gmake -j"$(sysctl -n machdep.cpu.thread_count)"
    else
        gmake -j"$(sysctl -n machdep.cpu.thread_count)" FINALPACKAGE=1
    fi
fi

if [ -d $BUILD_LOCATION ]; then
    # Add the necessary files
    echo "Adding application files"
    cp -r "$APP_BUILD_FILES/icon.png" "$BUILD_LOCATION/icon.png"
    cp -r "$APP_BUILD_FILES/Info.plist" "$BUILD_LOCATION/Info.plist"
    cp -r "$APP_BUILD_FILES/Assets.car" "$BUILD_LOCATION/Assets.car"
    cp -r "$APP_BUILD_FILES/en.lproj" "$BUILD_LOCATION/"
    cp -r "$APP_BUILD_FILES/zh-Hans.lproj" "$BUILD_LOCATION/"
    cp -r "$APP_BUILD_FILES/fonts" "$BUILD_LOCATION/"
    cp -r "$APP_BUILD_FILES/credits" "$BUILD_LOCATION/"

    # Create payload
    echo "Creating payload"
    cd build
    mkdir Payload
    cp -r $BUILD_LOCATION Payload/Helium.app

    # Archive
    echo "Archiving"
    if [[ $* != *--debug* ]]; then
        strip Payload/Helium.app/Helium
    fi
    zip -vr Helium.tipa Payload
    rm -rf Helium.app
    rm -rf Payload
fi
