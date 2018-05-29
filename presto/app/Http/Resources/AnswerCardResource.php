<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;

class AnswerCardResource extends Resource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request $request
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

        $response['question'] = $this->question;

        $response['question']['topics'] = $this->question->topics;

        $response['rating'] = $this->answerRatings()->where('rate', 1)->count();

        return $response;
    }
}
