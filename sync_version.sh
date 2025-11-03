#!/bin/bash

# Script to synchronize version from podspec to KhipuVersion.swift
# Usage: ./sync_version.sh

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PODSPEC_FILE="$SCRIPT_DIR/KhipuClientIOS.podspec"
VERSION_FILE="$SCRIPT_DIR/KhipuClientIOS/Classes/KhipuVersion.swift"

# Extract version from podspec
VERSION=$(grep "s.version" "$PODSPEC_FILE" | head -1 | sed -E "s/.*'(.*)'.*/\1/")

if [ -z "$VERSION" ]; then
    echo "Error: Could not extract version from $PODSPEC_FILE"
    exit 1
fi

echo "Generating KhipuVersion.swift with version $VERSION"

# Generate KhipuVersion.swift
cat > "$VERSION_FILE" <<EOF
import Foundation

/// Provides version information for the KhipuClientIOS SDK
/// This file is auto-generated from KhipuClientIOS.podspec - DO NOT EDIT MANUALLY
/// Run ./sync_version.sh to update this file
public class KhipuVersion {

    /// The current version of the KhipuClientIOS SDK
    public static let version = "$VERSION"

    /// Private initializer to prevent instantiation
    private init() {}
}
EOF

echo "✓ Generated KhipuVersion.swift with version $VERSION"
