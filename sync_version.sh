#!/bin/bash

# Script to synchronize version from podspec to KhipuVersion.swift and README.md
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

# Sync the SPM version shown in README.md (the `from: "X.Y.Z"` line)
README_FILE="$SCRIPT_DIR/README.md"
if [ -f "$README_FILE" ]; then
    sed -i.bak -E "s|(KhipuClientIOS\.git\", from: \")[0-9]+\.[0-9]+\.[0-9]+(\")|\1${VERSION}\2|" "$README_FILE"
    rm -f "$README_FILE.bak"
    echo "✓ Synced SPM version in README.md to $VERSION"
fi
