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

Route::get('/', function () {
    return redirect('index');
});

//Index
Route::get('index', 'HomeController@index')->name('index');
Route::get('about', 'HomeController@about')->name('about');
Route::get('search', 'HomeController@search')->name('search');
Route::get('404', 'HomeController@error')->name('404');

//Profile
Route::get('profile/edit', 'ProfileController@edit')->name('profile.edit');
Route::get('profile/{member}', 'ProfileController@show')->name('profile');
Route::get('profile/{member}/followers', 'ProfileController@followers')->name('followers');
Route::get('profile/{member}/following', 'ProfileController@following')->name('following');
Route::put('profile/{member}', 'ProfileController@update')->name('profile.update');
Route::get('settings', 'ProfileController@settings')->name('settings');
Route::get('notifications', 'ProfileController@notifications')->name('notifications');

//Admin
Route::get('admin', 'AdminController@show')->name('admin');

// Answer
Route::get('questions/{question}/answers/{answer}', 'AnswerController@show')->name('answer');

// Question
Route::get('questions/{question}', 'QuestionController@show')->name('question');
Route::post('questions', 'QuestionController@store')->name('question-add');

// Topic
Route::get('topic/{topic}', 'TopicController@show')->name('topic');

// Authentication
Route::get('login', 'Auth\LoginController@showLoginForm')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::get('logout', 'Auth\LoginController@logout')->name('logout');
Route::get('signup', 'Auth\RegisterController@showRegistrationForm')->name('signup');
Route::post('signup', 'Auth\RegisterController@register');

Auth::routes(); 

Route::prefix('admin')->group(function() {
    Route::get('/login', 'Auth\AdminLoginController@showLoginForm')->name('admin.login');
    Route::post('/login', 'Auth\AdminLoginController@login')->name('admin.login.submit');
    Route::get('/', 'AdminController@show')->name('admin.dashboard');
    Route::get('/logout', 'Auth\AdminLoginController@logout')->name('admin.logout');
  });

//API
//Profile
Route::patch('api/member/edit-profile-pic', 'ProfileController@updatePicture')->name('api.edit-profile-pic');

//Settings
Route::put('api/members/{username}/settings/email', 'ProfileController@updateEmail')->name('api.edit-email');
Route::put('api/members/{username}/settings/password', 'ProfileController@updatePassword')->name('api.edit-password');

//Follows Member
Route::post('api/member/{follower}/toggle-follow', 'ProfileController@follow')->name('api.follow');
Route::delete('api/member/{follower}/toggle-follow', 'ProfileController@unFollow')->name('api.unFollow');

//Follows Topic
Route::post('api/topic/{topic}/toggle-follow', 'TopicController@follow')->name('api.followTopic');
Route::delete('api/topic/{topic}/toggle-follow', 'TopicController@unFollow')->name('api.unFollowTopic');

// Comments
Route::post('api/comments/question', 'CommentController@create')->name('question-add-comment');

//Questions
Route::post('api/questions/{question}/rate', 'QuestionController@like');

//Answers
Route::post('api/questions/{question}/answers/{answer}/rate', 'AnswerController@like')->name('api.upvoteAnswer');

