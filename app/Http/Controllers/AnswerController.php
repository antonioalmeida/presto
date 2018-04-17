<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AnswerController extends Controller
{
    //

    public function show($question_id, $answer_id){
        return view('pages.answer');
    }
}
