<?php

namespace App\Http\Controllers;

use App\Http\Resources\TopicResource;
use App\Http\Resources\TopicListResource;
use App\Topic;
use Illuminate\Support\Facades\Auth;
use App\Rules\TopicUnique;

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

    public function getAllTopics()
    {
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

    public function update(Topic $topic)
    {
      $this->validate(request(), [
          'name' => ['required', 'max:35', new TopicUnique($topic->id)]
      ]);

      $topic->name = request('name');
      $topic->description = request('description', '');

      $topic->save();

      return new TopicResource($topic);
    }

    public function updatePicture(Topic $topic)
    {
        $this->validate(request(), [
            'pic-url' => 'required|url'
        ]);

        $topic->picture = request('pic-url');
        $topic->save();

        return ['pic-url' => $topic->picture];
    }
}
