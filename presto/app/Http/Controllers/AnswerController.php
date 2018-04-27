<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

use App\Answer;
use App\Question;

use \App\AnswerRating;

class AnswerController extends Controller
{
    public function __construct(){
        $this->middleware('auth')->except(['show']);
    }

    public function show(Question $question, Answer $answer){
        return view('pages.answer', compact('answer'));
    }

    public function isLikedByMe($id, $rate)
    {
        $answer = Answer::findOrFail($id)->first();
        if (AnswerRating::whereMemberId(Auth::id())->whereAnswerId($answer->id)->where('rate',$rate)->exists()){
            return true;
        }
        return false;
    }

    public function rate(Question $question, Answer $answer)
    {
        $existing_rate = AnswerRating::withTrashed()->whereAnswerId($answer->id)->whereMemberId(Auth::id())->first();

        if (is_null($existing_rate)) {
            AnswerRating::create([
                'answer_id' => $answer->id,
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
