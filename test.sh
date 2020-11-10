set -e
export PYTHONPATH=$(pwd)/src:$(pwd)/test
make
build/test/unittests