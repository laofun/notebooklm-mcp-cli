#!/bin/bash
set -e

# Configuration
IMAGE_NAME="notebooklm-test"
CONTAINER_NAME="nlm-test-run"
OUT_DIR="downloads"
TEST_NOTEBOOK="ae3684d4-8e83-4fc8-9177-d29b0cc0978e"

# Get project root (parent of the directory where this script resides)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "---------------------------------------------------------"
echo " NotebookLM MCP CLI - Docker Integration Test"
echo " Project Root: $PROJECT_ROOT"
echo "---------------------------------------------------------"

# Ensure we are running from project root context for building
cd "$PROJECT_ROOT"

# Make sure cookies.txt exists in root
if [ ! -f "cookies.txt" ]; then
    echo "❌ Error: cookies.txt not found in project root!"
    echo "Please run 'nlm login' or manually create 'cookies.txt'."
    exit 1
fi

# Build the docker image
echo "=> Building Docker image ($IMAGE_NAME)..."
docker build -q -t "$IMAGE_NAME" -f scripts/docker/Dockerfile .

# Create output directory
mkdir -p "$OUT_DIR"
rm -f "$OUT_DIR/test_audio.mp3"

# Run the container
echo "=> Running download test in Docker..."
docker run --rm \
    -v "$PROJECT_ROOT/$OUT_DIR:/app/$OUT_DIR" \
    -v "$PROJECT_ROOT/cookies.txt:/app/cookies.txt:ro" \
    --name "$CONTAINER_NAME" \
    --entrypoint bash \
    "$IMAGE_NAME" -c "nlm login --manual --file /app/cookies.txt && nlm --debug download audio $TEST_NOTEBOOK --no-progress --output /app/$OUT_DIR/test_audio.mp3"

# Verify results
if [ -f "$OUT_DIR/test_audio.mp3" ]; then
    echo "---------------------------------------------------------"
    echo "✅ SUCCESS: Audio file downloaded correctly."
    echo "Location: ./$OUT_DIR/test_audio.mp3"
    ls -lh "$OUT_DIR/test_audio.mp3"
    echo "---------------------------------------------------------"
else
    echo "---------------------------------------------------------"
    echo "❌ FAILURE: Audio file was not downloaded."
    echo "---------------------------------------------------------"
    exit 1
fi
