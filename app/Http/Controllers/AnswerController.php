<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Answer;
use App\Question;

class AnswerController extends Controller
{
    //

    public function show(Question $question, Answer $answer){
        return view('pages.answer', compact('answer'));
    }
}
