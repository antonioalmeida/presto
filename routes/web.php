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
Route::patch('api/member/edit-profile-pic', 'ProfileController@updatePicture')->name('api.edit-profile-pic');

//Follows
Route::post('api/member/{follower}/toggle-follow', 'ProfileController@follow')->name('api.follow');
Route::delete('api/member/{follower}/toggle-follow', 'ProfileController@unFollow')->name('api.unFollow');

//Admin
Route::get('admin', 'AdminController@show')->name('admin');

// Answer
Route::get('questions/{idq}/answers/{ida}', 'AnswerController@show')->name('answer');

// Question
Route::get('questions/{question}', 'QuestionController@show')->name('question');


// Topic
Route::get('topic/{topic}', 'TopicController@show')->name('topic');

// Cards
Route::get('cards', 'CardController@list');
Route::get('cards/{id}', 'CardController@show');

// API
Route::put('api/cards', 'CardController@create');
Route::delete('api/cards/{card_id}', 'CardController@delete');
Route::put('api/cards/{card_id}/', 'ItemController@create');
Route::post('api/item/{id}', 'ItemController@update');
Route::delete('api/item/{id}', 'ItemController@delete');

// Authentication

Route::get('login', 'Auth\LoginController@showLoginForm')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::get('logout', 'Auth\LoginController@logout')->name('logout');
Route::get('signup', 'Auth\RegisterController@showRegistrationForm')->name('signup');
Route::post('signup', 'Auth\RegisterController@register');

Auth::routes();

//Route::get('/home', 'HomeController@index')->name('home');
