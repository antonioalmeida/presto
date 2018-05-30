<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;
use Illuminate\Support\Facades\Auth;

class MemberCommentResource extends Resource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        $isSelf = false;
        if (Auth::user() != null && Auth::id() == $this->id)
            $isSelf = true;
        else if (Auth::user() != null) {
            $response['isFollowing'] = $this->isFollowedBy(Auth::user());
        }

        $response = [
           'username' => $this->username, 
           'profile_picture' => $this->profile_picture, 
           'name' => $this->name, 
           'isSelf' => $isSelf
        ];

        return $response;
    }
}
