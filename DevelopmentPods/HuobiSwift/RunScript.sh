#!/bin/sh

#  RunScript.sh
#  Pods
#
#  Created by xu.shuifeng on 29/01/2018.
#  
COMMOM_CRYPTO_PATH=$SDKROOT/usr/include/CommonCrypto/CommonCrypto.h'
COMMOM_CRYPTO_R_PATH=$SDKROOT/usr/include/CommonCrypto/CommonRandom.h

MODULE_DIR="$SRCROOT/Modules/CommonCrypto"
MODULE_FILE=$MODULE_DIR/module.map
MODULE_TEMPLATE="module CommonCrypto [system] {\n\t
header \"$COMMOM_CRYPTO_PATH\"\n\t
header \"$COMMOM_CRYPTO_R_PATH\"\n\t
export *\n
}"

echo "Create Modules path to map CommonCrypto lib"
mkdir -p "$SRCROOT/Modules/CommonCrypto"

echo "Cleanup previous CommonCrypto script to make sure the deployment target is always updated"

echo "" > $MODULE_FILE

echo "Create CommonCrypto module map template"
echo -e $MODULE_TEMPLATE > $MODULE_FILE'}
