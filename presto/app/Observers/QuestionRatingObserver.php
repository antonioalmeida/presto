<?php

namespace App\Observers;

use App\Notifications\QuestionRated;

class QuestionRatingObserver
{
    public function created(AnswerRating $rating)
    {
        $question = \App\Question::find($rating->question_id);
        $user = \App\Member::find($rating->member_id);
        $author = $question->member;

        if ($author->id != $user->id && $rating->rate == '1')
            $author->notify(new QuestionRated($user, $rating));
    }
}
 