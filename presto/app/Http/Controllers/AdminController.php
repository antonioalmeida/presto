<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Member;
use App\Flag;

class AdminController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:admin');
    }
    
    public function getUsers(){
        $members = Member::get();
        /*
        $data = array('a' => 'apple', 'b' => 'banana', 'c' => 'catnip');
        return json_encode($data);
        */
        return new MemberResource(Member::first());
    }

    public function getFlagged(){

    }

    public function getBanned(){

    }
    public function getModerators(){

    }

    public function getCertified(){

    }

    public function show(){
    	$members = Member::get();
    	$flagged = Flag::orderBy('date')->get();
    	$banned = Member::where('is_banned', true)->get();
    	$moderators = Member::where('is_moderator',true)->get();
    	$certified = Member::where('is_certified',true)->get();

        $members = Member::paginate(10);

        return view('pages.admin',['members' => $members, 'flagged' => $flagged, 'banned' => $banned, 'moderators' => $moderators, 'certified' => $certified]);
    }
}
