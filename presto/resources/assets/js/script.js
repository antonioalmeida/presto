// let indexSignupForm = document.getElementById('indexSignupForm');
// if (indexSignupForm != null)
//     indexSignupForm.addEventListener('submit', addSignupHandler);

// function addSignupHandler() {
//     //get the input elements from HTML DOM
//     let password = document.getElementById("passwordForm");
//     let password_confirmed = document.getElementById("passwordFormConfirmed");

//     //Assign the value of textOne textbox to textTwo textbox
//     password_confirmed.value = password.value;
// }


/*
 * Eliminating navbar dropdowns when screen is too small
 */
let navbar_avatar = document.getElementById("navbarDropdown");
let notifications_button = document.getElementById("notificationsDropdown");

function updateHrefs(x) {
    if (x.matches) { // If media query matches
        console.log("Smaller than 768");
        navbar_avatar.href = "profile.html";
        notifications_button.href = "notifications.html";
        navbar_avatar.removeAttribute("data-toggle");
        notifications_button.removeAttribute("data-toggle");
    }
    else {
        console.log("Bigger than 768");
        navbar_avatar.href = "#";
        notifications_button.href = "#";
        navbar_avatar.setAttribute("data-toggle", "dropdown");
        notifications_button.setAttribute("data-toggle", "dropdown");
    }
}

if (navbar_avatar != null && notifications_button != null) {
    var x = window.matchMedia("(max-width: 768px)");
    updateHrefs(x); // Call listener function at run time
    x.addListener(updateHrefs); // Attach listener function on state changes
}

