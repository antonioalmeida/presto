<?php

namespace App\Observers;

use App\Notifications\NewQuestion;
use App\Question;

class QuestionObserver
{
    public function created(Question $question)
    {
        $user = $question->member;
        foreach ($user->followers as $follower) {
            $follower->notify(new NewQuestion($user, $question));
        }
    }
}
