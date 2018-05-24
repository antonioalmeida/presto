// window.fbAsyncInit = function() {
//   FB.init({
//     appId      : '{your-app-id}',
//     cookie     : true,
//     xfbml      : true,
//     version    : '{latest-api-version}'
//   });

//   FB.AppEvents.logPageView();

// };

// (function(d, s, id){
//    var js, fjs = d.getElementsByTagName(s)[0];
//    if (d.getElementById(id)) {return;}
//    js = d.createElement(s); js.id = id;
//    js.src = "https://connect.facebook.net/en_US/sdk.js";
//    fjs.parentNode.insertBefore(js, fjs);
//  }(document, 'script', 'facebook-jssdk'));


// function onSuccess(googleUser) {
//   console.log('Logged in as: ' + googleUser.getBasicProfile().getName());
// }
// function onFailure(error) {
//   console.log(error);
// }
// function renderButton() {
//   gapi.signin2.render('my-signin2', {
//     'scope': 'profile email',
//     'width': 200,
//     'height': 50,
//     'longtitle': true,
//     'theme': 'dark',
//     'onsuccess': onSuccess,
//     'onfailure': onFailure
//   });
// }


let indexSignupForm = document.getElementById('indexSignupForm');
if (indexSignupForm != null)
    indexSignupForm.addEventListener('submit', addSignupHandler);

function addSignupHandler() {
    //get the input elements from HTML DOM
    let password = document.getElementById("passwordForm");
    let password_confirmed = document.getElementById("passwordFormConfirmed");

    //Assign the value of textOne textbox to textTwo textbox
    password_confirmed.value = password.value;
}


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

