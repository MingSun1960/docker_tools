mkdir -p studio-data/profile/AndroidStudio4.2.2.0 || exit
mkdir -p studio-data/Android || exit
mkdir -p studio-data/profile/.android || exit
mkdir -p studio-data/profile/.java || exit
mkdir -p studio-data/profile/.gradle || exit
docker build -t snpe-build-004 . || exit
