<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;


class QuestionResource extends Resource
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

        $response['rating'] = $this->questionRatings()->where('rate', 1)->count();

        $response['topics'] = $this->topics;
        return $response;
    }

}
