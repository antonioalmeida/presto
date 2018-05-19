<?php

namespace App\Http\Controllers;

use App\Http\Resources\TopicResource;
use App\Topic;
use Illuminate\Support\Facades\Auth;

class TopicController extends Controller
{

    public function __construct()
    {
        $this->middleware('auth')->except(['show', 'get']);
    }

    public function get(Topic $topic)
    {
        return new TopicResource($topic);
    }

    public function show(Topic $topic)
    {
        return view('pages.topic', compact('topic'));
    }

    public function toggleFollow(Topic $topic)
    {
        $member = Auth::user();

        if ($member->isFollowingTopic($topic))
            $member->unFollowTopic($topic);
        else
            $member->followTopic($topic);

        return ['following' => $member->isFollowingTopic($topic)];
    }

    public function follow(Topic $topic)
    {
        if (Auth::user()->followTopic($topic))
            return "ola";

        return "adeus";
        //return back();
    }

    public function unFollow(Topic $topic)
    {
        Auth::user()->unFollowTopic($topic);
        return back();
    }
}
