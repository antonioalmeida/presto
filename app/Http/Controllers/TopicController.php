<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class TopicController extends Controller
{
    //
    public function show($id){
        return view('pages.topic');
    }
}
