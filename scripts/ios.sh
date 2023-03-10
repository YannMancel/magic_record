#!/bin/sh

cd ../ios || exit
rm Podfile.lock
rm -rf Pods
pod cache clean --all
pod deintegrate
pod setup
pod install --repo-update
cd .. || exit
