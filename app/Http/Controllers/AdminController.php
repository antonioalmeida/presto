<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Member;

class AdminController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:admin');
    }
    
    //
    public function show(){
    	$members = Member::paginate(10);

        return view('pages.admin',['members' => $members]);
    }
}
