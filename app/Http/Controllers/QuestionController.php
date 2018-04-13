<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use \App\Question;

class QuestionController extends Controller
{
    public function show(Question $question){
        return view('pages.question.show', compact('question'));
    }

}
