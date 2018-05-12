<?php

namespace App\Observers;

use App\Notifications\NewAnswer;
use App\Answer;

class AnswerObserver
{
    public function created(Answer $answer)
    {
        $user = $answer->member;
        $author = $answer->question->member;
       
        if($author->id != $user->id)
         $author->notify(new NewAnswer($user, $answer));
    }
}
 