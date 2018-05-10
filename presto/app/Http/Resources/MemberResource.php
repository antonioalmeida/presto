<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;
use Illuminate\Support\Facades\Auth;

class MemberResource extends Resource
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
        $response['answers_views'] = $this->getAnswerViews();

        $response['nrFollowers'] = $this->followers()->count();
        $response['nrFollowing'] = $this->followings()->count();

        $isOwner = false;
        $member = Auth::user();
        if ($member->can('update', request('member')))
            $isOwner = true;
    
        $response['isOwner'] = $isOwner;
        return $response;
    }
}
