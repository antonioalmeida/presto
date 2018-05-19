<?php

namespace App\Observers;

use App\Comment;
use App\Notifications\NewComment;

class CommentObserver
{
    public function created(Comment $comment)
    {
        $user = $comment->member;

        if ($comment->question_id != null) {
            $author = $comment->question->member;
        } else {
            $author = $comment->answer->member;
        }

        if ($author->id != $user->id)
            $author->notify(new NewComment($user, $comment));
    }
}
