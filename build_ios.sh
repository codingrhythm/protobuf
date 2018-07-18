#!/bin/bash

PLATFORMPATH="/Applications/Xcode.app/Contents/Developer/Platforms"
TOOLSPATH="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"
export IPHONEOS_DEPLOYMENT_TARGET="9.0"
pwd=`pwd`

findLatestSDKVersion()
{
    sdks=`ls $PLATFORMPATH/$1.platform/Developer/SDKs`
    arr=()
    for sdk in $sdks
    do
       arr[${#arr[@]}]=$sdk
    done

    # Last item will be the current SDK, since it is alpha ordered
    count=${#arr[@]}
    if [ $count -gt 0 ]; then
       sdk=${arr[$count-1]:${#1}}
       num=`expr ${#sdk}-4`
       SDKVERSION=${sdk:0:$num}
    else
       SDKVERSION="9.0"
    fi
}

buildit()
{
    target=$1
    hosttarget=$1
    platform=$2

    if [[ $hosttarget == "x86_64" ]]; then
        hostarget="i386"
    elif [[ $hosttarget == "arm64" ]]; then
        hosttarget="arm"
    fi

    echo $target
    echo $hostarget
    echo $platform
    echo $SDKVERSION

    CC="$(xcrun -sdk iphoneos -find clang)"
    CPP="$CC -E"
    CFLAGS="-arch ${target} -isysroot $PLATFORMPATH/$platform.platform/Developer/SDKs/$platform$SDKVERSION.sdk -miphoneos-version-min=$SDKVERSION"
    AR=$(xcrun -sdk iphoneos -find ar)
    RANLIB=$(xcrun -sdk iphoneos -find ranlib)
    CPPFLAGS="-arch ${target}  -isysroot $PLATFORMPATH/$platform.platform/Developer/SDKs/$platform$SDKVERSION.sdk -miphoneos-version-min=$SDKVERSION"
    LDFLAGS="-arch ${target} -isysroot $PLATFORMPATH/$platform.platform/Developer/SDKs/$platform$SDKVERSION.sdk"

    echo $CC
    echo $CPP
    echo $CFLAGS
    echo $AR
    echo $RANLIB
    echo $CPPFLAGS
    echo $LDFLAGS

    echo "create output dir"
    echo $pwd/output/$target
    mkdir -p $pwd/output/$target

    ./configure --prefix="$pwd/output/$target" --disable-shared --host=$hosttarget-apple-darwin

    make clean > $target.clean.txt 2>&1
    make > $target.make.txt 2>&1
    make install
}

findLatestSDKVersion iPhoneOS

#buildit armv7 iPhoneOS
#buildit armv7s iPhoneOS
buildit arm64 iPhoneOS
#buildit i386 iPhoneSimulator
#buildit x86_64 iPhoneSimulator

#LIPO=$(xcrun -sdk iphoneos -find lipo)
#$LIPO -create $pwd/output/armv7/lib/libprotobuf.a  $pwd/output/armv7s/lib/libprotobuf.a $pwd/output/arm64/lib/libprotobuf.a $pwd/output/x86_64/lib/libprotobuf.a $pwd/output/i386/lib/libprotobuf.a -output libprotobuf.a
#$LIPO -create $pwd/output/arm64/lib/libprotobuf.a $pwd/output/x86_64/lib/libprotobuf.a -output libprotobuf.a