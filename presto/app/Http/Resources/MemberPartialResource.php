<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;
use Illuminate\Support\Facades\Auth;

use App\Member;

class MemberPartialResource extends Resource
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

        $isSelf = false;
        $member = Member::find($this->id);
        if (Auth::user() != null && Auth::id() == $this->id)
            $isSelf = true;
        else if(Auth::user() != null) {
                $response['isFollowing'] = $this->isFollowedBy(Auth::user());
        }
    
        $response['isSelf'] = $isSelf;
       
        
        return $response;
    }
}
