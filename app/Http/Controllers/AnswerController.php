<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AnswerController extends Controller
{
    //

    public function show($idq, $ida){
        return view('pages.answer');
    }
}
