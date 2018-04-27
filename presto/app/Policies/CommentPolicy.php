<?php

namespace App\Policies;

use App\Member;
use App\Comment;
use Illuminate\Auth\Access\HandlesAuthorization;

class CommentPolicy
{
    use HandlesAuthorization;

    /**
     * Determine whether the user can update the comment.
     *
     * @param  \App\Member  $user
     * @param  \App\Comment  $comment
     * @return mixed
     */
    public function update(Member $user, Comment $comment)
    {
        return $user->id === $comment->author_id || $user->is_moderator;

    }

    public function rate(Member $user, Comment $comment)
    {
        return $user->id !== $comment->author_id;
    }

    /**
     * Determine whether the user can delete the comment.
     *
     * @param  \App\Member  $user
     * @param  \App\Comment  $comment
     * @return mixed
     */
    public function delete(Member $user, Comment $comment)
    {
        return $user->id === $comment->author_id || $user->is_moderator;

    }
}
