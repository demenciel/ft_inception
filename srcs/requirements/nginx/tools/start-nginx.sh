#!/bin/sh

# Test NGINX configuration
# Add colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Testing NGINX configuration..."
if nginx -t; then
    echo "NGINX configuration test passed"
else
    echo "NGINX configuration test failed"
    exit 1
fi

# Start NGINX in foreground
exec nginx -g 'daemon off;'
