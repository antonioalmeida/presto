
(function(d, s, id) {
  let js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s);
  js.id = id;
  js.src = 'https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.12&appId=197095890882205&autoLogAppEvents=1';
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

function onSuccess(googleUser) {
  console.log('Logged in as: ' + googleUser.getBasicProfile().getName());
}
function onFailure(error) {
  console.log(error);
}
function renderButton() {
  gapi.signin2.render('my-signin2', {
    'scope': 'profile email',
    'width': 200,
    'height': 50,
    'longtitle': true,
    'theme': 'dark',
    'onsuccess': onSuccess,
    'onfailure': onFailure
  });
}


let indexSignupForm = document.getElementById('indexSignupForm');
indexSignupForm.addEventListener('submit', addSignupHandler);

function addSignupHandler() {
    //get the input elements from HTML DOM
    let password = document.getElementById("passwordForm");
    let password_confirmed = document.getElementById("passwordFormConfirmed");

    //Assign the value of textOne textbox to textTwo textbox
    password_confirmed.value = password.value;
}