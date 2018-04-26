<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

use App\Answer;
use App\Question;

use \App\AnswerRating;

class AnswerController extends Controller
{
    //

    public function show(Question $question, Answer $answer){
        return view('pages.answer', compact('answer'));
    }

    public function isLikedByMe($id)
    {
       $answer = Answer::findOrFail($id)->first();
       if (AnswerRating::whereUserId(Auth::id())->whereAnswerId($answer->id)->exists()){
           return 'true';
       }
       return 'false';
   }
   
   public function like(Question $question, Answer $answer)
   {
       $existing_like = AnswerRating::withTrashed()->whereAnswerId($answer->id)->whereMemberId(Auth::id())->first();
   
       if (is_null($existing_like)) {    
        AnswerRating::create([
               'answer_id' => $answer->id,
               'member_id' => Auth::id(),
               'rate' => 1
           ]);
       } else {
           if (is_null($existing_like->deleted_at)) {
               $existing_like->delete();
           } else {
               $existing_like->restore();
           }
       }

       return back();
   }
}
