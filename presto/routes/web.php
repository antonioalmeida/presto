<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

//Index
Route::view('', 'layouts.master')->name('index');
Route::view('about', 'layouts.master')->name('about');
Route::view('404', 'layouts.master')->name('404');

//Notifications
Route::view('notifications', 'layouts.master')->name('notifications');

//Profile
Route::view('profile/{member}', 'layouts.master');
Route::view('profile/{member}/followers', 'layouts.master');
Route::view('profile/{member}/following', 'layouts.master');
Route::view('settings', 'layouts.master')->name('settings');
Route::view('edit-profile', 'layouts.master')->name('profile.edit');


// Answer
Route::view('questions/{question}/answers/{answer}', 'layouts.master');

// Question
Route::view('questions/{question}', 'layouts.master');

// Topic
Route::view('topic/{topic}/edit', 'layouts.master')->middleware('moderator');
Route::view('topic/{topic}', 'layouts.master');

Route::prefix('api')->group(function () {
    // Profile API
    Route::get('profile/{member}/answers', 'ProfileController@getAnswers');
    Route::get('profile/{member}/questions', 'ProfileController@getQuestions');
    Route::get('profile/{member}/followers', 'ProfileController@getFollowers')->name('followers');
    Route::get('profile/{member}/following', 'ProfileController@getFollowing')->name('following');
    Route::get('profile/{member}', 'ProfileController@get')->name('profile');
    Route::get('profile/', 'ProfileController@getLoggedIn');
    Route::get('notifications', 'ProfileController@getNotifications');
    Route::get('notificationsStats', 'ProfileController@getNotificationsStats');
    Route::get('UnreadNotifications', 'ProfileController@getUnreadNotifications');
    Route::post('profile/{member}/flag', 'ProfileController@flag')->middleware('moderator');
    Route::post('member/{follower}/toggle-follow', 'ProfileController@toggleFollow')->name('api.follow');
    Route::patch('member/edit-profile-pic', 'ProfileController@updatePicture')->name('api.edit-profile-pic');
    Route::post('members/{username}/settings/email', 'ProfileController@updateEmail')->name('api.edit-email');
    Route::post('members/{username}/settings/password', 'ProfileController@updatePassword')->name('api.edit-password');

    Route::post('profile/', 'ProfileController@update');

    // Question API
    Route::get('questions/{question}/answers/{answer}', 'AnswerController@getAnswer');
    Route::get('questions/{question}', 'QuestionController@get');
    Route::get('questions/{question}/answers', 'QuestionController@getAnswers');
    Route::post('questions/{question}/answers/{answer}', 'AnswerController@update')->name('answer.edit');
    Route::post('questions/{question}', 'QuestionController@update')->name('question.edit');
    Route::post('questions', 'QuestionController@store')->name('question.add');
    Route::post('questions/{question}/solve', 'QuestionController@solve');
    Route::post('questions/{question}/unsolve', 'QuestionController@unsolve');
    Route::delete('questions/{question}','QuestionController@delete')->name('question.delete');
    Route::post('questions/{question}/rate', 'QuestionController@rate')->name('api.rateQuestion');
    Route::post('questions/{question}/report', 'QuestionController@report')->name('question.report');


    // Comments
    Route::get('comments/{comment}', 'CommentController@get');
    Route::post('comments/question/{question}', 'CommentController@storeQuestionComment')->name('question.add.comment');
    Route::post('comments/answer/{answer}', 'CommentController@storeAnswerComment')->name('answer.add.comment');
    Route::post('comments/{comment}/rate', 'CommentController@rate')->name('api.comment.rate');
    Route::post('comments/{comment}/report', 'CommentController@report')->name('api.comment.report');

    // Topics API
    Route::get('topic/{topic}', 'TopicController@get');
    Route::post('topic/{topic}', 'TopicController@update')->middleware('moderator');
    Route::post('topic/{topic}/toggle-follow', 'TopicController@toggleFollow');
    Route::get('topic/', 'TopicController@getAllTopics');
    Route::patch('topic/{topic}/edit-pic', 'TopicController@updatePicture')->middleware('moderator');

    // Search API
    Route::get('search/{query}', 'SearchController@get');

    //Feed API
    Route::get('isLoggedIn', 'HomeController@isLoggedIn');
    Route::get('feed/getNewContent', 'HomeController@getNewContent');
    Route::get('feed/getTopContent', 'HomeController@getTopContent');
    Route::get('feed/getRecommendedContent', 'HomeController@getRecommendedContent');
    Route::get('feed/getTrendingTopics', 'HomeController@getTrendingTopics');
    Route::get('feed/getTopMembers', 'HomeController@getTopMembers');

    // Admin API
    Route::get('admin/get-users', 'AdminController@getUsers');
    Route::get('admin/get-banned', 'AdminController@getBanned');
    Route::get('admin/get-flagged', 'AdminController@getFlagged');
    Route::get('admin/get-moderators', 'AdminController@getModerators');
    Route::post('members/{username}/ban', 'AdminController@ban')->name('api.ban');
    Route::post('members/{username}/toggle-moderator', 'AdminController@toggleModerator')->name('api.promote');
    Route::delete('flags/{member_id}/{moderator_id}/dismiss', 'AdminController@dismissFlag')->name('api.dismiss');

    // Answer API
    Route::post('/questions/{question}/answers/', 'AnswerController@create')->name('answer.create');
    Route::delete('questions/{question}/answers/{answer}','AnswerController@delete')->name('answer.delete');
    Route::post('questions/{question}/answers/{answer}/rate', 'AnswerController@rate')->name('answer.rate');
    Route::post('questions/{question}/answers/{answer}/report', 'AnswerController@report')->name('answer.report');

});

//Search
Route::view('search/{query}', 'layouts.master');

// Authentication
Route::view('login', 'layouts.master_aux')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::get('logout', 'Auth\LoginController@logout')->name('logout');
Route::view('signup', 'layouts.master_aux')->name('signup');
Route::post('signup', 'Auth\RegisterController@register');

// OAuth Routes
Route::get('auth/{provider}', 'Auth\LoginController@redirectToProvider');
Route::get('auth/{provider}/callback', 'Auth\LoginController@handleProviderCallback');

// Password Reset Routes...
Route::view('password/reset', 'layouts.master_aux')->name('password.request');
Route::post('password/email', 'Auth\ForgotPasswordController@sendResetLinkEmail')->name('password.email');
Route::view('password/reset/{token}', 'layouts.master_aux')->name('password.reset');
Route::post('password/reset', 'Auth\ResetPasswordController@reset');

// Administration
Route::prefix('admin')->group(function () {
    Route::view('/login', 'layouts.master_aux')->name('admin.login');
    Route::post('/login', 'Auth\AdminLoginController@login')->name('admin.login.submit');
    Route::view('/', 'layouts.master')->name('admin.dashboard');
    Route::get('/logout', 'Auth\AdminLoginController@logout')->name('admin.logout');
});
