<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;
use Illuminate\Support\Facades\Auth;


class FullQuestionResource extends Resource
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

        $isOwner = false;
        $member = Auth::user();
        if ($member != null && $member->can('update', $this->resource))
            $isOwner = true;

        $response['isOwner'] = $isOwner;

        $response['author'] = [
            'username' => $this->member->username,
            'name' => $this->member->name,
            'profile_picture' => $this->member->profile_picture,
        ];

        $response['topics'] = $this->topics;
        $response['comments'] = CommentResource::collection($this->comments);

        return $response;
    }
}
