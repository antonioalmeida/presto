<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class IndexController extends Controller
{
    private $view;

    //
    public function __construct(){
        $this->middleware('guest');
    }

    public function show(){

        return view('pages.index');
    }

}
