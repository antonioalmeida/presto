/*
 * Eliminating navbar dropdowns when screen is too small
 */
let notifications_button = document.getElementById("notificationsDropdown");

function updateHrefs(x) {
    if (x.matches) { // If media query matches
        console.log("Smaller than 768");
        notifications_button.href = "notifications";
        notifications_button.removeAttribute("data-toggle");
    }
    else {
        console.log("Bigger than 768");
        notifications_button.href = "#";
        notifications_button.setAttribute("data-toggle", "dropdown");
    }
}

if (notifications_button != null) {
    var x = window.matchMedia("(max-width: 768px)");
    updateHrefs(x); // Call listener function at run time
    x.addListener(updateHrefs); // Attach listener function on state changes
}

