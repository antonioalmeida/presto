<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Resources\MemberListResource;
use App\Http\Resources\FlagResource;
use App\Http\Resources\QuestionResource;

use App\Member;
use App\Flag;

class AdminController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:admin');
    }
    
    public function getUsers(Request $request){
        $query = $request->input('query');
        $search_query = '%'.$query.'%';

        if(strcmp($query,"") == 0)
            return Member::where('is_banned', false)->paginate(10);
        else
        $search_query = '%'.$query.'%';
            return Member::where([['is_banned', false],['name', 'ILIKE', $search_query]])->orWhere([['is_banned', false],['username','ILIKE',$search_query]])->paginate(10);

        //whereRaw('("name" LIKE ? OR "username" LKE ?)',[$search_query,$search_query])->paginate(10);
    }

    public function getFlagged(){
        return FlagResource::collection(Flag::orderBy('date')->get());
    }

    public function getBanned(){
        return MemberListResource::collection(Member::where('is_banned', true)->get());
    }
    public function getModerators(){
        return MemberListResource::collection(Member::where(['is_moderator' => true, 'is_banned' => false])->get());
    }

    public function getCertified(){
        return MemberListResource::collection(Member::where(['is_certified' => true, 'is_banned' => false])->get());
    }

    public function ban(String $username){
        $member = Member::where('username',$username)->first();
        $member->is_banned = 1;
        $member->update();
    }

    public function toggleModerator(String $username){
        $member = Member::where('username',$username)->first();
        if($member->is_moderator == 0)
            $member->is_moderator = 1;
        else
            $member->is_moderator = 0;
        $member->update();
        return $member->is_moderator;
    }

    public function dismissFlag(int $member_id, int $moderator_id){
        $flag = Flag::where(['member_id' => $member_id, 'moderator_id' => $moderator_id])->first();
        $flag->delete();
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
