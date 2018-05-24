<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;
use Illuminate\Support\Facades\Auth;


class AnswerResource extends Resource
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

        $response['question'] = new QuestionResource($this->question);

        $response['author'] = new MemberPartialResource($this->member);

        $response['comments'] = CommentResource::collection($this->comments);

        $response['upvotes'] = $this->answerRatings()->where('rate', 1)->count();
        $response['downvotes'] = $this->answerRatings()->where('rate', -1)->count();

        $response['isUpvoted'] = $this->answerRatings()->where('rate', 1)->where('member_id', Auth::id())->count() == 1;
        $response['isDownvoted'] = $this->answerRatings()->where('rate', -1)->where('member_id', Auth::id())->count() == 1;

        return $response;
    }
}
