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

Route::get('/', 'HomeController@index')->name('index');

//Index
Route::view('index', 'layouts.master')->name('index');
Route::view('about', 'layouts.master')->name('about');
Route::get('404', 'HomeController@error')->name('404');

//Profile
Route::get('profile/edit', 'ProfileController@edit')->name('profile.edit');

Route::put('profile/{member}', 'ProfileController@update')->name('profile.update');
Route::get('settings', 'ProfileController@settings')->name('settings');
Route::get('notifications', 'ProfileController@notifications')->name('notifications');

// Profile
Route::view('profile/{member}', 'layouts.master');
Route::view('profile/{member}/followers', 'layouts.master');

// Answer
Route::view('answers/{answer}', 'layouts.master');
Route::view('questions/{question}/answers/{answer}', 'layouts.master');

// Question
Route::view('questions/{question}', 'layouts.master');

// Topic
Route::view('topic/{topic}', 'layouts.master');

Route::prefix('api')->group(function() {
	// Profile API
	Route::get('profile/{member}/questions', 'ProfileController@getQuestions');
	Route::get('profile/{member}/followers', 'ProfileController@getFollowers')->name('followers');
	Route::get('profile/{member}/following', 'ProfileController@following')->name('following');
	Route::get('profile/{member}', 'ProfileController@get')->name('profile');

	// Question API
	Route::get('questions/{question}', 'QuestionController@get');
	Route::get('questions/{question}/answers', 'QuestionController@getAnswers');
	Route::post('questions', 'QuestionController@store')->name('question-add');

	// Comments
	Route::get('comments/{comment}', 'CommentController@get');
	Route::post('comments/question', 'CommentController@storeQuestionComment')->name('question.add.comment');
	Route::post('comments/answer', 'CommentController@storeAnswerComment')->name('answer.add.comment');

	// Topics API
	Route::get('topic/{topic}', 'TopicController@get');
	Route::post('topic/{topic}/toggle-follow', 'TopicController@toggleFollow');
	//Route::delete('topic/{topic}/toggle-follow', 'TopicController@unFollow');

	// Search API
	Route::get('search/{query}', 'SearchController@get');

	// Answer API
	Route::post('/questions/{question}/answers/', 'AnswerController@create')->name('answer-add');
});

//Search
Route::view('search/{query}', 'layouts.master');
//Route::post('search', 'SearchController@search')->name('search');

//Admin
Route::get('admin', 'AdminController@show')->name('admin');



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




Route::post('api/comments/{comment}/rate', 'CommentController@rate')->name('api.rateComment');

//Questions
Route::post('api/questions/{question}/rate', 'QuestionController@rate')->name('api.rateQuestion');

//Answers
Route::post('api/questions/{question}/answers/{answer}/rate', 'AnswerController@rate')->name('api.rateAnswer');
