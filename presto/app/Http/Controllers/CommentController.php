<?php

namespace App\Http\Controllers;

use App\Answer;
use App\Comment;
use App\CommentRating;
use App\Member;
use App\Http\Resources\CommentResource;
use App\Notifications\MemberMention;
use App\Question;
use Illuminate\Support\Facades\Auth;

class CommentController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth')->except(['get']);
    }

    public function storeQuestionComment(Question $question)
    {
        $this->validate(request(), [
            'content' => 'required|min:2'
        ]);

        $content = request('content');
        $author_id = Auth::id();
        $date = date('Y-m-d H:i:s');
        $mentions = request('mentions');

        $comment = $question->comments()->create(compact('author_id', 'content', 'date'));

        foreach ($mentions as $mention) {
            $member = Member::where('username', 'ILIKE', trim($mention))->get();

            if (!$member->isEmpty()) {
                $member->first()->notify(new MemberMention(Auth::user(), $comment));
            }
        }

        return new CommentResource($comment);
    }

    public function storeAnswerComment(Answer $answer)
    {
        $this->validate(request(), [
            'content' => 'required|min:2'
        ]);

        $content = request('content');
        $author_id = Auth::id();
        $date = date('Y-m-d H:i:s');
        $mentions = request('mentions');

        $comment = $answer->comments()->create(compact('author_id', 'content', 'date'));

        foreach ($mentions as $mention) {
            $member = Member::where('username', 'ILIKE', trim($mention))->get();

            if (!$member->isEmpty()) {
                $member->first()->notify(new MemberMention(Auth::user(), $comment));
            }
        }

        return new CommentResource($comment);
    }

    public function get(Comment $comment)
    {
        return new CommentResource($comment);
    }

    public function rate(Comment $comment)
    {
        $this->authorize('rate', $comment);

        $existing_rate = CommentRating::withTrashed()->whereCommentId($comment->id)->whereMemberId(Auth::id())->first();

        if (is_null($existing_rate)) {
            CommentRating::create([
                'comment_id' => $comment->id,
                'member_id' => Auth::id(),
                'rate' => request('rate')
            ]);
        } else {
            if (is_null($existing_rate->deleted_at)) {
                if ($existing_rate->rate == request('rate')) {
                    $existing_rate->delete();
                } else {
                    $existing_rate->rate = request('rate');
                    $existing_rate->save();
                }
            } else {
                $existing_rate->restore();
                $existing_rate->rate = request('rate');
                $existing_rate->save();
            }
        }

        $upvotes = $comment->commentRatings->where('rate', 1)->count();
        $downvotes = $comment->commentRatings->where('rate', -1)->count();

        return compact('upvotes', 'downvotes');
    }
}
