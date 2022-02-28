# tf_entrypoint_test.sh
# script to test components installed in Docker image when the image is run with the paramete to run the script

# List TensorFlow version
python -c 'import tensorflow as tf; print(tf.__version__)'

# List jupyter installed
jupyter --version

# List Conda version
conda --version
