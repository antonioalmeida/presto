<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;

class TopicCardResource extends Resource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request $request
     * @return array
     */
    public function toArray($request)
    {
        return parent::toArray($request);

        $response['author'] = [
            'username' => $this->member->username,
            'name' => $this->member->name,
            'profile_picture' => $this->member->profile_picture,
        ];

    }
}
