/**
 * Fixes layout jumping when the mobile keyboard appears by scrolling to the top.
 */
function fix() {
    // (a) Scroll to the top
    window.scrollTo(0, 0);
    document.documentElement.scrollTop = 0;
    document.body.scrollTop = 0;
}

// Attach fix to window scroll event
window.addEventListener('scroll', fix);

// Attach fix to visualViewport resize/scroll if available
if (window.visualViewport) {
    window.visualViewport.addEventListener('resize', fix);
    window.visualViewport.addEventListener('scroll', fix);
}

// Attach fix to document focusin (now and after 300ms)
document.addEventListener('focusin', function handler() {
    // Immediate call
    fix();
    
    // Delayed call after 300ms
    setTimeout(() => {
        fix();
    }, 300);
});