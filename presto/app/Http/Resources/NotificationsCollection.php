<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\ResourceCollection;

class NotificationsCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request $request
     * @return array
     */
    public function toArray($request)
    {
        // $response = parent::toArray($request);
        $response['Follows'] = $this->where('type', 'App\Notifications\MemberFollowed')->count();
        $response['Questions'] = $this->where('type', 'App\Notifications\NewQuestion')->count();
        $response['Answers'] = $this->where('type', 'App\Notifications\NewAnswer')->count();
        $response['Comments'] = $this->where('type', 'App\Notifications\NewComment')->count();
        $response['Rating'] = $this->where('type', 'App\Notifications\QuestionRated')->count()
            + $this->where('type', 'App\Notifications\AnswerRated')->count()
            + $this->where('type', 'App\Notifications\CommentRated')->count();

        return $response;
    }
}
