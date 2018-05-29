window.$ = window.jQuery = jQuery;
window.Pusher = require('pusher-js');
import Echo from "laravel-echo";

window.Pusher.logToConsole = true;

window.Echo = new Echo({
    broadcaster: 'pusher',
    key: 'b9238648fe8769320bdf',
    cluster: 'eu',
    encrypted: false
});

var notifications = [];

const NOTIFICATION_TYPES = {
    follow: 'App\\Notifications\\MemberFollowed',
    newQuestion: 'App\\Notifications\\NewQuestion',
    newAnswer: 'App\\Notifications\\NewAnswer',
    newComment: 'App\\Notifications\\NewComment',
    answerRated: 'App\\Notifications\\AnswerRated',
    questionRated: 'App\\Notifications\\QuestionRated',
    commentRated: 'App\\Notifications\\CommentRated',
    mention: 'App\\Notifications\\MemberMention',
};

var NOTIFICATION_TEXT_LIMIT = 20;

$(document).ready(function () {

    // check if there's a logged in user
    if (Laravel.userId) {
        window.Echo.private('App.Member.' + window.Laravel.userId)
            .notification((notification) => {
                addNotifications([notification], '#notificationsDropdown');
            });

        $.get('/api/UnreadNotifications', function (data) {
            addNotifications(data, "#notificationsDropdown");
        });

    }
});

function addNotifications(newNotifications, target) {
    notifications = notifications.concat(newNotifications);
    // show only last 5 notifications
    let sliced = notifications.slice(0, 5);
    showNotifications(sliced, target);
}

function showNotifications(notifications, target) {
    if (notifications.length > 0) {
        var htmlElements = notifications.map(function (notification) {
            return makeNotification(notification);
        });
        $('#notificationsMenu').html(htmlElements.join(''));
    } else {
        $('#notificationsMenu').html('<a class="dropdown-item" href="#"><span class="text-muted">No Unread Notifications</span></a>');
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
    to = notification.data.url + to;

    return '/' + to;
}

// get the notification text based on it's type
function makeNotificationText(notification) {
    var text = '';
    if (notification.type === NOTIFICATION_TYPES.follow) {
        const name = notification.data.follower_name;
        const picture = notification.data.follower_picture;
        text += '<img class="user-preview rounded-circle pr-1" height="36" alt="' + name + '\'s profile picture" src="' + picture + '" width="36">'
            + name + '<span class="text-muted"> started following you.</span>';

    } else if (notification.type === NOTIFICATION_TYPES.newQuestion) {
        const name = notification.data.following_name;
        const picture = notification.data.following_picture;
        text += '<img class="user-preview rounded-circle pr-1" height="36" alt="' + name + '\'s profile picture" src="' + picture + '" width="36">'
            + name + '<span class="text-muted"> posted a question.</span>';
    } else if (notification.type === NOTIFICATION_TYPES.newAnswer) {
        const name = notification.data.following_name;
        const picture = notification.data.following_picture;
        const title = notification.data.question_title;
        text += '<img class="user-preview rounded-circle pr-1" height="36" alt="' + name + '\'s profile picture" src="' + picture + '" width="36">'
            + name + '<span class="text-muted"> answered your question: </span>'
            + (title.length < NOTIFICATION_TEXT_LIMIT ? title : title.substring(0, NOTIFICATION_TEXT_LIMIT) + '...');
    } else if (notification.type === NOTIFICATION_TYPES.newComment) {
        const name = notification.data.following_name;
        const picture = notification.data.following_picture;
        const title = notification.data.question_title;
        const type = notification.data.type_comment;
        text += '<img class="user-preview rounded-circle pr-1" height="36" alt="' + name + '\'s profile picture" src="' + picture + '" width="36">'
            + name + '<span class="text-muted"> left a comment on your ' + (type == 'Answer' ? 'answer to the ' : '') + 'question: </span>'
            + (title.length < NOTIFICATION_TEXT_LIMIT ? title : title.substring(0, NOTIFICATION_TEXT_LIMIT) + '...');
    } else if (notification.type === NOTIFICATION_TYPES.answerRated) {
        const name = notification.data.following_name;
        const picture = notification.data.following_picture;
        const title = notification.data.question_title;
        text += '<img class="user-preview rounded-circle pr-1" height="36" alt="' + name + '\'s profile picture" src="' + picture + '" width="36">'
            + name + '<span class="text-muted"> upvoted your answer to the question: </span>'
            + (title.length < NOTIFICATION_TEXT_LIMIT ? title : title.substring(0, NOTIFICATION_TEXT_LIMIT) + '...');
    } else if (notification.type === NOTIFICATION_TYPES.questionRated) {
        const name = notification.data.following_name;
        const picture = notification.data.following_picture;
        const title = notification.data.question_title;
        text += '<img class="user-preview rounded-circle pr-1" height="36" alt="' + name + '\'s profile picture" src="' + picture + '" width="36">'
            + name + '<span class="text-muted"> upvoted your question: </span>'
            + (title.length < NOTIFICATION_TEXT_LIMIT ? title : title.substring(0, NOTIFICATION_TEXT_LIMIT) + '...');
    } else if (notification.type === NOTIFICATION_TYPES.commentRated) {
        const name = notification.data.following_name;
        const picture = notification.data.following_picture;
        const title = notification.data.question_title;
        const type = notification.data.type_comment;
        text += '<img class="user-preview rounded-circle pr-1" height="36" alt="' + name + '\'s profile picture" src="' + picture + '" width="36">'
            + name + '<span class="text-muted"> upvoted your comment to the ' + (type == 'Answer' ? 'answer to the ' : '') + 'question: </span>'
            + (title.length < NOTIFICATION_TEXT_LIMIT ? title : title.substring(0, NOTIFICATION_TEXT_LIMIT) + '...');
    } else if (notification.type === NOTIFICATION_TYPES.mention) {
        const name = notification.data.follower_name;
        const picture = notification.data.follower_picture;
        const title = notification.data.question_title;
        const type = notification.data.type_comment;
        text += '<img class="user-preview rounded-circle pr-1" height="36" alt="' + name + '\'s profile picture" src="' + picture + '" width="36">'
            + name + '<span class="text-muted"> mentioned you on their comment to the ' + (type == 'Answer' ? 'answer to the ' : '') + 'question: </span>'
            + (title.length < NOTIFICATION_TEXT_LIMIT ? title : title.substring(0, NOTIFICATION_TEXT_LIMIT) + '...');

    }

    return text;
}
