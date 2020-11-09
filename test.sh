set -e
export PYTHONPATH=$(pwd)/src:$(pwd)/test
make
test/unittests