<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;

class FlagResource extends Resource
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
        $response['member'] = new MemberListResource($this->member);
        $response['moderator'] = new MemberListResource($this->moderator);
        return $response;
    }
}
