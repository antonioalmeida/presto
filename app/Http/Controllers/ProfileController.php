<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function __construct(){
        $this->middleware('auth')->except(['show','followers','following']);
    }

    public function show($id){
        return view('pages.profile.show');
    }

    public function edit($id){
        return view('pages.profile.edit');
    }

    public function followers($id){
        return view('pages.profile.followers');
    }

    public function following($id){
        return view('pages.profile.following');
    }

    public function settings(){
        return view('pages.profile.settings');
    }

    public function notifications(){
        return view('pages.profile.notifications');
    }
}
