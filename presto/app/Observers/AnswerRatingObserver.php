<?php

namespace App\Observers;

use App\AnswerRating;
use App\Notifications\AnswerRated;

class AnswerRatingObserver
{
    public function created(AnswerRating $rating)
    {
        $answer = \App\Answer::find($rating->answer_id);
        $user = \App\Member::find($rating->member_id);
        $author = $answer->member;

        if ($author->id != $user->id && $rating->rate == '1')
            $author->notify(new AnswerRated($user, $rating));
    }
}
 