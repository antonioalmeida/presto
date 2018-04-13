<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Question;

class QuestionController extends Controller
{
    public function show($id){
    	$question = Question::find($id);
        return view('pages.question.show', compact('question'));
    }

}
