#!/bin/sh

export PATH="/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:$PATH"
# env > env.txt
# echo "$0" "$*" > cmd.txt
# which -a swift > swift.txt
swift build
