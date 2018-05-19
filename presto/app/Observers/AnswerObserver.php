<?php

namespace App\Observers;

use App\Answer;
use App\Notifications\NewAnswer;

class AnswerObserver
{
    public function created(Answer $answer)
    {
        $user = $answer->member;
        $author = $answer->question->member;

        if ($author->id != $user->id)
            $author->notify(new NewAnswer($user, $answer));
    }
}
 