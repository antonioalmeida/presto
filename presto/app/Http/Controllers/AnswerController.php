<?php

namespace App\Http\Controllers;

use App\Answer;
use App\AnswerRating;
use App\Http\Resources\AnswerResource;
use App\Question;
use Illuminate\Support\Facades\Auth;
use Purifier;

class AnswerController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth')->except(['getAnswer']);
    }

    public function getAnswer(Question $question, Answer $answer)
    {
        return new AnswerResource($answer);
    }

    public function create(Question $question)
    {

        $content = '<span>' . Purifier::clean(stripslashes(request('content'))) . '</span>';
        $author_id = Auth::id();
        $date = date('Y-m-d H:i:s');

        $answer = $question->answers()->create(compact('content', 'author_id', 'date'));

        return new AnswerResource($answer);
    }

    public function isLikedByMe($id, $rate)
    {
        $answer = Answer::findOrFail($id)->first();
        if (AnswerRating::whereMemberId(Auth::id())->whereAnswerId($answer->id)->where('rate', $rate)->exists()) {
            return true;
        }
        return false;
    }

    public function rate(Question $question, Answer $answer)
    {
        $this->authorize('rate', $answer);

        $existing_rate = AnswerRating::withTrashed()->whereAnswerId($answer->id)->whereMemberId(Auth::id())->first();

        if (is_null($existing_rate)) {
            AnswerRating::create([
                'answer_id' => $answer->id,
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

        $upvotes = $answer->answerRatings->where('rate', 1)->count();
        $downvotes = $answer->answerRatings->where('rate', -1)->count();

        return compact('upvotes', 'downvotes');
    }
}
