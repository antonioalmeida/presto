window._ = require('lodash');
window.$ = window.jQuery;
// = require('jquery');
//require('bootstrap-sass');
window.Pusher = require('pusher-js');
import Echo from "laravel-echo";

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

$(document).ready(function() {
    // check if there's a logged in user
    if(Laravel.userId) {
        window.Echo.private('App.User.${Laravel.userId}')
        .notification((notification) => {
            addNotifications([notification], '#notifications');
        });

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
    return '<li><a href="' + to + '">' + notificationText + '</a></li>';
}

// get the notification route based on it's type
function routeNotification(notification) {
    var to = '?read=' + notification.id;
    if(notification.type === NOTIFICATION_TYPES.follow) {
        to = 'users' + to;
    } else if(notification.type === NOTIFICATION_TYPES.newQuestion) {
        console.log("cenas");
        const questionId = notification.data.question_id;
        to = 'questions/${questionId}' + to;
    }
    return '/' + to;
}

// get the notification text based on it's type
function makeNotificationText(notification) {
    var text = '';
    if(notification.type === NOTIFICATION_TYPES.follow) {
        const name = notification.data.follower_name;
        text += '<strong>' + name + '</strong> followed you';
    } else if(notification.type === NOTIFICATION_TYPES.newQuestion) {
        console.log("lel");
        const name = notification.data.following_name;
        text += '<strong>${name}</strong> published a question';
    }

    return text;
}