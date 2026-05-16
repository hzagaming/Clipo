#!/bin/bash
# Reset Accessibility permissions for Clipo during development.
# Run this when a new test build is not recognized by the system.

BUNDLE_ID="Hanazar-Software.Clipo"
APP_NAME="Clipo"

echo "=== Clipo Accessibility Permission Reset ==="
echo ""

# Method 1: Reset ALL accessibility permissions (nuclear option)
# Uncomment the next line if you want to wipe every app's accessibility permissions:
# tccutil reset Accessibility

# Method 2: Try to reset just this bundle ID (may fail on newer macOS due to SIP)
tccutil reset Accessibility "$BUNDLE_ID" 2>/dev/null || true

echo "Please follow these steps:"
echo ""
echo "1. Open System Settings → Privacy & Security → Accessibility"
echo "2. Look for any existing '$APP_NAME' entries and DELETE them (click '-' button)"
echo "3. Run the new build from Xcode"
echo "4. When the permission window appears, click 'Open System Settings'"
echo "5. Click the '+' button, press Cmd+Shift+G, and navigate to:"
echo "   ~/Library/Developer/Xcode/DerivedData/Clipo-*/Build/Products/Debug/"
echo "6. Select 'Clipo.app' and click 'Open'"
echo "7. The checkbox next to Clipo should now be checked"
echo "8. Return to the app — it should detect the permission within 1 second"
echo ""
echo "TIP: To avoid this forever, assign a Development Team in Xcode Signing settings."
