#!/bin/sh
flutter build appbundle --flavor staging --build-number $TRAVIS_BUILD_NUMBER
cd android
bundle exec fastlane deploy
