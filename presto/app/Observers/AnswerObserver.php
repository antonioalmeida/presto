<?php

namespace App\Observers;

use App\Notifications\NewAnswer;
use App\Answer;

class AnswerObserver
{
    public function created(Answer $answer)
    {
        $user = $answer->member;
        foreach ($user->followers as $follower) {
            $follower->notify(new NewAnswer($user, $answer));
        }
    }
}
