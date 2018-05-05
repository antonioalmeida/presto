<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;

class AnswerResource extends Resource
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

         $response['author'] = [
            'username' => $this->member->username,
            'name' => $this->member->name,
            'profile_picture' => $this->member->profile_picture,
        ];

        $response['comments'] = CommentResource::collection($this->comments);

        $response['upvotes'] = $this->answerRatings()->where('rate', 1)->count();
        $response['downvotes'] = $this->answerRatings()->where('rate', -1)->count();

        return $response;
    }
}
