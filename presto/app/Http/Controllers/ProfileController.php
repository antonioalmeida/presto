<?php

namespace App\Http\Controllers;

require_once app_path() . '/Utils.php';

use App\Http\Resources\AnswerResource;
use App\Http\Resources\MemberResource;
use App\Http\Resources\NotificationsCollection;
use App\Http\Resources\NotificationsResource;
use App\Http\Resources\QuestionResource;
use App\Member;
use App\Flag;
use Illuminate\Http\Request;
use App\Http\Controllers;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
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
        $chunkNr = request('chunk');

        $res = getDataChunk($member->answers,$chunkNr,10);

        $res['data'] =  AnswerResource::collection($res['data']);
        return $res;
    }

    public function getQuestions(Member $member)
    {
        $chunkNr = request('chunk');

        $res = getDataChunk($member->questions,$chunkNr,10);

        $res['data'] =  QuestionResource::collection($res['data']);
        return $res;
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

    public function getNotifications(Request $request)
    {
        $type = $request->input('type','All');
        $member = Auth::user();

        $member->unreadNotifications->markAsRead();

        if(strcmp($type,'All') == 0)
            $notifiations = $member->notifications;
        else
            $notifiations = $member->notifications->where('data.type',$type);

        return paginate(NotificationsResource::collection($notifiations),10);
        //return DB::table('notifications')->where([['notifiable_id',$member->id]])->get();
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
            'username' => ['required', 'string', 'alpha_dash', Rule::unique('member')->ignore($member->id)],
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

        return ['profile-pic-url' => $member->profile_picture];
    }

    public function updateEmail(Request $request)
    {
        $member = Auth::user();

        $request->validate([
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('member')->ignore($member->id)]
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

        $chunkNr = request('chunk');

        $res = getDataChunk($member->followers,$chunkNr,10);

        $res['data'] =  MemberResource::collection($res['data']);
        return $res;
    }

    public function getFollowing(Member $member)
    {
        $chunkNr = request('chunk');

        $res = getDataChunk($member->followings,$chunkNr,10);

        $res['data'] =  MemberResource::collection($res['data']);
        return $res;
    }

    public function toggleFollow(Member $follower)
    {
        $member = Auth::user();

        if ($member->isFollowing($follower))
            $member->unFollow($follower);
        else
            $member->follow($follower);

        return ['following' => $member->isFollowing($follower), 'no_follow' => $member->followings->count()];
    }

    public function flag(Member $member)
    {
        $flagger = Auth::user();

        $this->validate(request(), [
          'reason' => 'required|string'
        ]);

        $flag = new Flag;
        $flag->moderator_id = $flagger->id;
        $flag->member_id = $member->id;
        $flag->reason = request('reason');
        $flag->date = date("Y-m-d H:i:s");
        $flag->save();
    }
}
