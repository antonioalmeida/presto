let navbar_avatar = document.getElementById("navbarDropdown");
let notifications_button = document.getElementById("notificationsDropdown");

function updateHrefs(x) {
    if (x.matches) { // If media query matches
        console.log("Smaller than 768");
        navbar_avatar.href = "profile.html";
        notifications_button.href = "notifications.html";
        navbar_avatar.removeAttribute("data-toggle");
        notifications_button.removeAttribute("data-toggle");
    } else {
        console.log("Bigger than 768");
        navbar_avatar.href = "#";
        notifications_button.href = "#";
        navbar_avatar.setAttribute("data-toggle", "dropdown");
        notifications_button.setAttribute("data-toggle", "dropdown");
    }
}

var x = window.matchMedia("(max-width: 768px)")
updateHrefs(x) // Call listener function at run time
x.addListener(updateHrefs) // Attach listener function on state changes
