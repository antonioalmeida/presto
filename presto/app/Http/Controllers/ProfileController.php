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
use Illuminate\Validation\Rule;


class ProfileController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth')->except(['get', 'getQuestions', 'getAnswers', 'getFollowers', 'following']);
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
          'username' => ['required','string','alpha_dash',Rule::unique('member')->ignore($member->id)],
          'name' => 'required|max:35'
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
            'email' => ['required','string','email','max:255',Rule::unique('member')->ignore($member->id)]
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

    public function settings()
    {
        return view('pages.profile.settings');
    }

}
