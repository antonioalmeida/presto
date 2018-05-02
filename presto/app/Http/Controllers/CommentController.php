<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\ApiBaseController;

use App\Http\Resources\CommentResource;

use App\Comment;
use \App\CommentRating;

class CommentController extends ApiBaseController
{
    public function __construct(){
        $this->middleware('auth')->except(['show', 'get']);
    }

    public function store()
    {
        $this->validate(request(), [
            'content' => 'required|min:2',
            'question_id' => 'required|integer|min:0'
        ]);

        $content = request('content');
        $question_id = request('question_id');
        $author_id = Auth::id();
        $date = now();

        $comment = Comment::create(compact('question_id','author_id','content','date'));

        return new CommentResource($comment);
    }

    public function get(Comment $comment) {
        return new CommentResource($comment);
    }

    public function rate(Comment $comment)
    {
        $existing_rate = CommentRating::withTrashed()->whereCommentId($comment->id)->whereMemberId(Auth::id())->first();

        if (is_null($existing_rate)) {
            CommentRating::create([
                'comment_id' => $comment->id,
                'member_id' => Auth::id(),
                'rate' => request('rate')
            ]);
        } else {
            if (is_null($existing_rate->deleted_at)) {
                if($existing_rate->rate == request('rate')){
                    $existing_rate->delete();
                }
                else{
                    $existing_rate->rate = request('rate');
                    $existing_rate->save();
                }
            } else {
                $existing_rate->restore();
                $existing_rate->rate = request('rate');
                $existing_rate->save();
            }
        }

        return back();
    }
}
