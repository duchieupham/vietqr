#!/bin/bash
set -e

#fvm flutter packages pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "Build Data Done !!!"