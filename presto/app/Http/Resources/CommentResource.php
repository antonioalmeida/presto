<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;
use Illuminate\Support\Facades\Auth;


class CommentResource extends Resource
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

        $response['author'] = new MemberCommentResource($this->member);

        $response['upvotes'] = $this->commentRatings->where('rate', 1)->count();
        $response['downvotes'] = $this->commentRatings->where('rate', -1)->count();

        $response['isUpvoted'] = $this->commentRatings->where('rate', 1)->where('member_id', Auth::id())->count() == 1;
        $response['isDownvoted'] = $this->commentRatings->where('rate', -1)->where('member_id', Auth::id())->count() == 1;

        return $response;
    }
}
