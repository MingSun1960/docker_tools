# snpe-entrypoint-test.sh
# Entrypoint script to check on all components used by SNPE-Android-SDK-NDK when docker image is run with parameter to run the script

# List Android Studio version
android list target

# List SNPE Library version
head -10 ~/SNPE-LIB/ReleaseNotes.txt

# Check Ubuntu version
lsb_release -a

