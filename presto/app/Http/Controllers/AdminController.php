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
    	$members = Member::get();
    	$flagged = array();
    	$banned = array();
    	$moderators = array();
    	$certified = array();

    	foreach($members as $member){
    		if($member->flags()->count() != 0)
    			$flagged[] = $member;

    		if($member->is_banned)
    			$banned[] = $member;

    		if($member->is_moderator)
    			$moderators[] = $member;

    		if($member->is_certified)
    			$certified[] = $member;

    	}

        $members = Member::paginate(10);

        return view('pages.admin',['members' => $members, 'flagged' => $flagged, 'banned' => $banned, 'moderators' => $moderators, 'certified' => $certified]);
    }
}
