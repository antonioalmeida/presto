<?php

namespace App\Http\Controllers;

use App\Answer;
use App\Comment;
use App\CommentRating;
use App\CommentReport;
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
        $date = new \DateTime("now", new \DateTimeZone('Europe/Lisbon'));
        $date = $date->format('Y-m-d H:i:s');
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
        $date = new \DateTime("now", new \DateTimeZone('Europe/Lisbon'));
        $date = $date->format('Y-m-d H:i:s');
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
        $finalValue = request('rate');

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
                    $finalValue = 0;
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

        $response = [
            'isUpvoted' => $finalValue == 1 ? true : false,
            'isDownvoted' => $finalValue == -1 ? true : false,
            'upvotes' => $comment->commentRatings->where('rate', 1)->count(),
            'downvotes' => $comment->commentRatings->where('rate', -1)->count()
        ];

        return $response;
    }

    public function report(Comment $comment) {
        $this->validate(request(), [
            'reason' => 'required|min:5'
        ]);

        $reports = CommentReport::where('comment_id', $comment->id)
            ->where('member_id', Auth::id())->get();

        if (!$reports->isEmpty()) {
            return ['error' => 'Member already reported this content!'];
        }

        $result = CommentReport::create([
            'comment_id' => $comment->id,
            'member_id' => Auth::id(),
            'reason' => request('reason'),
            'date' => now()
        ]);

        return compact('result');
    }
}
