<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Topic;

class TopicController extends Controller
{

    public function __construct(){
        $this->middleware('auth')->except(['show']);
    }

    //
    public function show(Topic $topic){
        return view('pages.topic', compact('topic'));
    }

    public function follow(Topic $topic) {
        Auth::user()->followTopic($topic);
        return back();
    }

    public function unFollow(Topic $topic) {
        Auth::user()->unFollowTopic($topic);
        return back();
    }
}
