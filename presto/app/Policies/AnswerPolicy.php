<?php

namespace App\Policies;

use App\Member;
use App\Answer;
use Illuminate\Auth\Access\HandlesAuthorization;

class AnswerPolicy
{
    use HandlesAuthorization;

     /**
     * Determine whether the user can update the answer.
     *
     * @param  \App\Member  $user
     * @param  \App\Answer  $answer
     * @return mixed
     */
    public function update(Member $user, Answer $answer)
    {
        return $user->id === $answer->author_id || $user->is_moderator;
    }

    public function rate(Member $user, Answer $answer)
    {
        return $user->id !== $answer->author_id;
    }


    /**
     * Determine whether the user can delete the answer.
     *
     * @param  \App\Member  $user
     * @param  \App\Answer  $answer
     * @return mixed
     */
    public function delete(Member $user, Answer $answer)
    {
        return $user->id === $answer->author_id || $user->is_moderator;
    }
}
