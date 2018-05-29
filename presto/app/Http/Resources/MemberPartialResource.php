<?php

namespace App\Http\Resources;

use App\Member;
use Illuminate\Http\Resources\Json\Resource;
use Illuminate\Support\Facades\Auth;

class MemberPartialResource extends Resource
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
        $response['score'] = $this->getScore();

        $isSelf = false;
        $member = Member::find($this->id);
        if (Auth::user() != null && Auth::id() == $this->id)
            $isSelf = true;
        else if (Auth::user() != null) {
            $response['isFollowing'] = $this->isFollowedBy(Auth::user());
        }

        $response['isSelf'] = $isSelf;

        return $response;
    }
}
