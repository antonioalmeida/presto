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

/*
Route::get('/', function () {
    return redirect('index');
});
*/

// Route::get('/', 'HomeController@index')->name('index');

//Index
Route::view('', 'layouts.master')->name('index');
Route::view('about', 'layouts.master')->name('about');
Route::view('404', 'layouts.master')->name('404');


Route::put('profile/{member}', 'ProfileController@update')->name('profile.update');
Route::view('notifications', 'layouts.master')->name('notifications');

// Profile
Route::view('profile/{member}', 'layouts.master');
Route::view('profile/{member}/followers', 'layouts.master');
Route::view('profile/{member}/following', 'layouts.master');
Route::view('settings', 'layouts.master')->name('settings');
Route::view('edit-profile', 'layouts.master')->name('profile.edit');


// Answer
// Route::view('answers/{answer}', 'layouts.master');
Route::view('questions/{question}/answers/{answer}', 'layouts.master');

// Question
Route::view('questions/{question}', 'layouts.master');

// Topic
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
    Route::post('member/{follower}/toggle-follow', 'ProfileController@toggleFollow')->name('api.follow');

    Route::post('profile/', 'ProfileController@update');

    // Question API
    Route::get('questions/{question}/answers/{answer}', 'AnswerController@getAnswer');
    Route::get('questions/{question}', 'QuestionController@get');
    Route::get('questions/{question}/answers', 'QuestionController@getAnswers');
    Route::post('questions/{question}/answers/{answer}', 'AnswerController@update')->name('question.edit');
    Route::post('questions/{question}', 'QuestionController@update')->name('question.edit');
    Route::post('questions', 'QuestionController@store')->name('question.add');
    Route::post('questions/{question}/solve', 'QuestionController@solve');
    Route::post('questions/{question}/unsolve', 'QuestionController@unsolve');
    Route::delete('questions/{question}','QuestionController@delete')->name('question.delete');

    // Comments
    Route::get('comments/{comment}', 'CommentController@get');
    Route::post('comments/question/{question}', 'CommentController@storeQuestionComment')->name('question.add.comment');
    Route::post('comments/answer/{answer}', 'CommentController@storeAnswerComment')->name('answer.add.comment');

    // Topics API
    Route::get('topic/{topic}', 'TopicController@get');
    Route::post('topic/{topic}/toggle-follow', 'TopicController@toggleFollow');
    //Route::delete('topic/{topic}/toggle-follow', 'TopicController@unFollow');
    Route::get('topic/', 'TopicController@getAllTopics');

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
    Route::get('admin/get-certified', 'AdminController@getCertified');

    // Answer API
    Route::post('/questions/{question}/answers/', 'AnswerController@create')->name('answer-add');
    Route::delete('questions/{question}/answers/{answer}','AnswerController@delete')->name('answer.delete');

});

//Search
Route::view('search/{query}', 'layouts.master');
//Route::post('search', 'SearchController@search')->name('search');

//Admin
// Route::get('admin', 'AdminController@show')->name('admin');


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

// Auth::routes();

Route::prefix('admin')->group(function () {
    Route::view('/login', 'layouts.master_aux')->name('admin.login');
    Route::post('/login', 'Auth\AdminLoginController@login')->name('admin.login.submit');
    //Route::get('/', 'AdminController@show')->name('admin.dashboard');
    Route::view('/', 'layouts.master')->name('admin.dashboard');
    Route::get('/logout', 'Auth\AdminLoginController@logout')->name('admin.logout');
});

//API
//Profile
Route::patch('api/member/edit-profile-pic', 'ProfileController@updatePicture')->name('api.edit-profile-pic');

//Settings
Route::post('api/members/{username}/settings/email', 'ProfileController@updateEmail')->name('api.edit-email');
Route::post('api/members/{username}/settings/password', 'ProfileController@updatePassword')->name('api.edit-password');

//Follows Member
// Route::post('api/member/{follower}/toggle-follow', 'ProfileController@follow')->name('api.follow');
// Route::delete('api/member/{follower}/toggle-follow', 'ProfileController@unFollow')->name('api.unFollow');

//Ban Member
Route::post('api/members/{username}/ban', 'AdminController@ban')->name('api.ban');

//Promote Moderator
Route::post('api/members/{username}/toggle-moderator', 'AdminController@toggleModerator')->name('api.promote');

//Dismiss Flag
Route::delete('api/flags/{member_id}/{moderator_id}/dismiss', 'AdminController@dismissFlag')->name('api.dismiss');

Route::post('api/comments/{comment}/rate', 'CommentController@rate')->name('api.rateComment');

//Questions
Route::post('api/questions/{question}/rate', 'QuestionController@rate')->name('api.rateQuestion');

//Answers
Route::post('api/questions/{question}/answers/{answer}/rate', 'AnswerController@rate')->name('api.rateAnswer');
