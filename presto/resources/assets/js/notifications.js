window._ = require('lodash');
window.$ = window.jQuery = jQuery;
// = require('jquery');
//require('bootstrap-sass');
window.Pusher = require('pusher-js');
import Echo from "laravel-echo";

window.Pusher.logToConsole = true;

window.Echo = new Echo({
    broadcaster: 'pusher',
    key: 'b9238648fe8769320bdf',
    cluster: 'eu',
    encrypted: true
});

var notifications = [];

const NOTIFICATION_TYPES = {
    follow: 'App\\Notifications\\MemberFollowed',
    newQuestion: 'App\\Notifications\\NewQuestion'
};

//${Laravel.userId}

$(document).ready(function() {
   
    // check if there's a logged in user
    if(Laravel.userId) {
        window.Echo.private('App.Member.'+ window.Laravel.userId)
        .notification((notification) => {
            addNotifications([notification], '#notifications');
        });

        // window.Echo.channel('App.Member.'+ window.Laravel.userId)
        // .notification((notification) => {
        //     addNotifications([notification], '#notifications');
        // });

            $.get('/notifications', function (data) {
            addNotifications(data, "#notifications");
        });
    }
});

function addNotifications(newNotifications, target) {
    notifications = _.concat(notifications, newNotifications);
    // show only last 5 notifications
    notifications.slice(0, 5);
    showNotifications(notifications, target);
}

function showNotifications(notifications, target) {
    if(notifications.length) {
        var htmlElements = notifications.map(function (notification) {
            return makeNotification(notification);
        });
        $(target + 'Menu').html(htmlElements.join(''));
        $(target).addClass('has-notifications')
    } else {
        $(target + 'Menu').html('<li class="dropdown-header">No notifications</li>');
        $(target).removeClass('has-notifications');
    }
}

// Make a single notification string
function makeNotification(notification) {
    var to = routeNotification(notification);
    var notificationText = makeNotificationText(notification);
    return '<a  class="dropdown-item" href="' + to + '">' + notificationText + '</a>';
}

// get the notification route based on it's type
function routeNotification(notification) {
    var to = '?read=' + notification.id;
    if(notification.type === NOTIFICATION_TYPES.follow) {
        const username = notification.data.follower_username;
        to = 'profile/' + username + to;
    } else if(notification.type === NOTIFICATION_TYPES.newQuestion) {
        const questionId = notification.data.question_id;
        to = 'questions/' + questionId + to;
    }
    return '/' + to;
}

// get the notification text based on it's type
function makeNotificationText(notification) {
    var text = '';
    if(notification.type === NOTIFICATION_TYPES.follow) {
        const name = notification.data.follower_name;
        const username = notification.data.follower_username;
        const picture = notification.data.follower_picture;
        text += '<img class="user-preview rounded-circle pr-1" heigth="36px" src="' + picture + '" width="36px">'
        + name + '<span class="text-muted"> started following you.</span>';

    } else if(notification.type === NOTIFICATION_TYPES.newQuestion) {
        const name = notification.data.following_name;
        const username = notification.data.following_username;
        const picture = notification.data.following_picture;
        const idq = notification.data.question_id;
        const title = notification.data.question_title;
        text += '<img class="user-preview rounded-circle pr-1" heigth="36px" src="' + picture + '" width="36px">'
                + name + '<span class="text-muted"> post a question.</span>';
    }

    return text;
}