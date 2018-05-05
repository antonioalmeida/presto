<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;
use App\Http\Resources\QuestionResource;
use Illuminate\Support\Facades\Auth;


class TopicResource extends Resource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        $response = parent::toArray($request);

        $response['nrFollowers'] = count($this->followers);
        $response['nrQuestions'] = count($this->questions);
        $response['nrAnswers'] = count($this->answers);
        $response['related'] = $this->getRelatedTopics();
        $response['nrViews'] = $this->getNumViews();

        $isFollowing = false;
        if (Auth::user()->isFollowingTopic($request['topic']))
            $isFollowing = true;

        $response['isFollowing'] = $isFollowing;

        $response['questions'] = QuestionResource::collection($this->questions);

        return $response;
    }
}
