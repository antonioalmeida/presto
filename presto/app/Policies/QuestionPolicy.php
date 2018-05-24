<?php

namespace App\Policies;

use App\Member;
use App\Question;
use Illuminate\Auth\Access\HandlesAuthorization;

class QuestionPolicy
{
    use HandlesAuthorization;

    /**
     * Determine whether the user can update the question.
     *
     * @param  \App\Member $user
     * @param  \App\Question $question
     * @return mixed
     */
    public function update(Member $user, Question $question)
    {
        return $user->id === $question->author_id || $user->is_moderator;
    }

    public function rate(Member $user, Comment $comment)
    {
        return $user->id !== $comment->author_id;
    }

    /**
     * Determine whether the user can delete the question.
     *
     * @param  \App\Member $user
     * @param  \App\Question $question
     * @return mixed
     */
    public function delete(Member $user, Question $question)
    {
        return $user->id === $question->author_id || $user->is_moderator;
    }
}
