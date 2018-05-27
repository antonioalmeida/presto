<?php

namespace App\Http\Controllers;

use App\Http\Resources\TopicResource;
use App\Http\Resources\TopicListResource;
use App\Topic;
use Illuminate\Support\Facades\Auth;

class TopicController extends Controller
{

    public function __construct()
    {
        $this->middleware('auth')->except(['get', 'getAllTopics']);
    }

    public function get(Topic $topic)
    {
        return new TopicResource($topic);
    }

    public function getAllTopics() {
        return TopicListResource::collection(Topic::all());
    }

    public function toggleFollow(Topic $topic)
    {
        $member = Auth::user();

        if ($member->isFollowingTopic($topic))
            $member->unFollowTopic($topic);
        else
            $member->followTopic($topic);

        return ['following' => $member->isFollowingTopic($topic), 'no_follow' => $topic->followers->count()];
    }

}
