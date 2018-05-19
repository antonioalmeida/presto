<?php

namespace App\Http\Controllers;

use App\Http\Resources\AnswerResource;
use App\Http\Resources\MemberResource;
use App\Http\Resources\NotificationsCollection;
use App\Http\Resources\NotificationsResource;
use App\Http\Resources\QuestionResource;
use App\Member;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


// use App\Notification;

class ProfileController extends ApiBaseController
{
    public function __construct()
    {
        $this->middleware('auth')->except(['get', 'getQuestions', 'getAnswers', 'show', 'getFollowers', 'following']);
    }

    public function show(Member $member)
    {
        return view('pages.profile.show', compact('member'));
    }

    public function get(Member $member)
    {
        return new MemberResource($member);
    }

    public function getLoggedIn()
    {
        $member = Auth::user();
        return new MemberResource($member);
    }

    public function getAnswers(Member $member)
    {
        return AnswerResource::collection($member->answers);
    }

    public function getQuestions(Member $member)
    {
        return QuestionResource::collection($member->questions);
    }

    public function getQuestionsLoggedIn()
    {
        $member = Auth::user();
        return QuestionResource::collection($member->questions);
    }

    public function getNotificationsStats()
    {
        $member = Auth::user();

        return new NotificationsCollection($member->notifications);
    }

    public function getNotifications()
    {
        $member = Auth::user();

        $member->unreadNotifications->markAsRead();

        return NotificationsResource::collection($member->notifications);
    }

    public function getUnreadNotifications()
    {
        $member = Auth::user();

        return NotificationsResource::collection($member->unreadNotifications);
    }

    public function update()
    {
        $member = Auth::user();

        $this->validate(request(), [

        ]);

        $member->name = request('name');
        $member->username = request('username');
        $member->bio = request('bio');

        $member->save();

        return new MemberResource($member);
    }

    public function updatePicture(Request $request)
    {
        $member = Auth::user();

        $request->validate([
            'profile-pic-url' => 'required|url'
        ]);

        $member->profile_picture = request('profile-pic-url');
        $member->save();

        return redirect()->route('profile.edit', $member);
    }

    public function updateEmail(Request $request)
    {
        $member = Auth::user();

        $request->validate([
            'email' => 'required|string|email|max:255|unique:member'
        ]);

        $member->email = request('email');
        $member->save();

        return redirect()->route('settings');
    }

    public function updatePassword(Request $request)
    {
        $member = Auth::user();

        $request->validate([
            'password' => 'required|string|min:6'
        ]);

        $member->password = bcrypt(request('password'));
        $member->save();

        return redirect()->route('settings');
    }

    public function getFollowers(Member $member)
    {
        //TODO: use MemberCardResource instead (need to create it)
        return MemberResource::collection($member->followers);
    }

    public function getFollowing(Member $member)
    {
        //TODO: use MemberCardResource instead (need to create it)
        return MemberResource::collection($member->followings);
    }

    public function toggleFollow(Member $follower)
    {
        $member = Auth::user();

        if ($member->isFollowing($follower))
            $member->unFollow($follower);
        else
            $member->follow($follower);

        return ['following' => $member->isFollowing($follower), 'no_followings' => $member->followings->count()];
    }


    public function follow(Member $follower)
    {
        return Auth::user()->follow($follower);
        return back();
    }

    public function unFollow(Member $follower)
    {
        Auth::user()->unFollow($follower);
        return back();
    }

    public function settings()
    {
        return view('pages.profile.settings');
    }

    // public function notifications(){
    //     $notifications_p = Auth()->user()->notifications()->paginate(7);
    //     $notifications = Auth()->user()->notifications;
    //     $counters['Follows'] = $notifications->where('type','App\Notifications\MemberFollowed')->count();
    //     $counters['Questions'] = $notifications->where('type','App\Notifications\NewQuestion')->count();
    //     $counters['Answers'] = $notifications->where('type','App\Notifications\NewAnswer')->count();
    //     $counters['Comments'] = $notifications->where('type','App\Notifications\NewComment')->count();
    //     $counters['Rating'] = $notifications->where('type','App\Notifications\QuestionRated')->count() 
    //     + $notifications->where('type','App\Notifications\AnswerRated')->count() 
    //     + $notifications->where('type','App\Notifications\CommentRated')->count();

    //     return view('pages.profile.notifications', ['counters' => $counters, 'notifications_p' => $notifications_p]);
    // }

}
