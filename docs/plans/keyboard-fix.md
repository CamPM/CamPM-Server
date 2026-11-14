# Keyboard Fix Implementation Plan

## Goal
Stop the code-server layout from jumping when the iPad keyboard bar appears.

## Files to Edit
1. `ct103-localai/keyboard-fix.js`

## Host Commands for the User
1. Navigate to the container: `docker exec -it <container_name> /bin/bash`
2. Apply the changes to `keyboard-fix.js`.
3. Restart the application inside the container.

## Check
1. Verify that the layout no longer jumps when interacting with input fields on a simulated mobile view (or actual iPad/mobile device).
2. Check the console for any errors related to scrolling or focus events.

## Rollback
1. Restore the original content of `ct103-localai/keyboard-fix.js` from a backup or previous commit.

## What Stays the Same
1. All other files and configurations remain unchanged.