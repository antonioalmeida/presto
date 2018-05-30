<?php

namespace App\Http\Controllers;

use App\Answer;
use App\AnswerRating;
use App\Http\Resources\AnswerResource;
use App\Http\Resources\AnswerPartialResource;
use App\Question;
use Illuminate\Support\Facades\Auth;

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
        $content = '<span>' . request('content') . '</span>';
        $author_id = Auth::id();
        $date = new \DateTime("now", new \DateTimeZone('Europe/Lisbon'));
        $date = $date->format('Y-m-d H:i:s');

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
        $finalValue = request('rate');

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
            'upvotes' => $answer->answerRatings->where('rate', 1)->count(),
            'downvotes' => $answer->answerRatings->where('rate', -1)->count()
        ];

        return $response;
    }

    public function update(Question $question, Answer $answer) {
        $this->authorize('update', $answer);

        $this->validate(request(), [
            'content' => 'required',
        ]);

        $content = '<span>' . request('content') . '</span>';

        $answer->content = $content;

        $answer->save();

        return new AnswerPartialResource($answer);
    }

    public function delete(Question $question, Answer $answer) {
        $this->authorize('delete', $answer);

        $result = false;
        if($answer->delete())
            $result = true;

        return compact('result');
    }
}
