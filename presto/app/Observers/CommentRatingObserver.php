<?php

namespace App\Observers;

use App\CommentRating;
use App\Notifications\CommentRated;

class CommentRatingObserver
{
    public function created(commentRating $rating)
    {
        $comment = \App\Comment::find($rating->comment_id);
        $user = \App\Member::find($rating->member_id);
        $author = $comment->member;

        if ($author->id != $user->id && $rating->rate == '1')
            $author->notify(new CommentRated($user, $rating));
    }
}
 