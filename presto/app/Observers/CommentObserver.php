<?php

namespace App\Observers;

use App\Notifications\NewComment;
use App\Comment;

class CommentObserver
{
    public function created(Comment $comment)
    {
        $user = $comment->member;
        foreach ($user->followers as $follower) {
            $follower->notify(new NewComment($user, $comment));
        }
    }
}
