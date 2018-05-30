<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

use App\Question;
use App\Answer;
use App\Http\Resources\QuestionResource;
use App\Http\Resources\AnswerCardResource;
use App\Http\Resources\MemberPartialResource;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth')->except(['getTopMembers', 'getTrendingTopics', 'isLoggedIn', 'getNewContent', 'getTopContent', 'getRecommendedContent', 'error']);
    }

    public function isLoggedIn()
    {
        $isLoggedIn = false;
        $member = Auth::user();
        if ($member != null)
            $isLoggedIn = true;

        return compact('isLoggedIn');
    }

    public function getTopContent()
    {
        //Top questions/answers (sorted by a weird score):
        $query1 = DB::table('question')->selectRaw('id, (((select count(*) from question_rating where question_id = question.id and rate = 1) + 1.9208) / ((select count(*) from question_rating where question_id = question.id)) - 1.96 * SQRT(((select count(*) from question_rating where question_id = question.id and rate = 1) * (select count(*) from question_rating where question_id = question.id and rate = -1)) / ((select count(*) from question_rating where question_id = question.id)) + 0.9604) / ((select count(*) from question_rating where question_id = question.id))) / (1 + 3.8416 / ((select count(*) from question_rating where question_id = question.id))) as score')
            ->whereRaw('(select count(*) from question_rating where question_id = question.id) > 0')
            ->addSelect(DB::raw("'question' as type"));

        $query2 = DB::table('answer')->selectRaw('id, (((select count(*) from answer_rating where answer_id = answer.id and rate = 1) + 1.9208) / ((select count(*) from answer_rating where answer_id = answer.id)) - 1.96 * SQRT(((select count(*) from answer_rating where answer_id = answer.id and rate = 1) * (select count(*) from answer_rating where answer_id = answer.id and rate = -1)) / ((select count(*) from answer_rating where answer_id = answer.id)) + 0.9604) / ((select count(*) from answer_rating where answer_id = answer.id))) / (1 + 3.8416 / ((select count(*) from answer_rating where answer_id = answer.id))) as score')
            ->whereRaw('(select count(*) from answer_rating where answer_id = answer.id) > 0')
            ->addSelect(DB::raw("'answer' as type"));

        $data = $query1->union($query2)->orderBy('score', 'DESC')->get();

        return $this->getDataChunk($data,10);
    }

    public function getNewContent()
    {
        $query1 = DB::table('question')
            ->selectRaw('id, date')
            ->addSelect(DB::raw("'question' as type"));

        $query2 = DB::table('answer')
            ->selectRaw('id, date')
            ->addSelect(DB::raw("'answer' as type"));

        $data = $query1->union($query2)->orderBy('date', 'DESC')->get();

        return $this->getDataChunk($data,10);
    }

    public function getRecommendedContent()
    {
        if (Auth::user() == null) {
            return [];
        }

        $user_id = Auth::user()->id;

        $query1 = DB::table('question')
            ->selectRaw('id, (((select count(*) from question_rating where question_id = question.id and rate = 1) + 1.9208) / ((select count(*) from question_rating where question_id = question.id)) - 1.96 * SQRT(((select count(*) from question_rating where question_id = question.id and rate = 1) * (select count(*) from question_rating where question_id = question.id and rate = -1)) / ((select count(*) from question_rating where question_id = question.id)) + 0.9604) / ((select count(*) from question_rating where question_id = question.id))) / (1 + 3.8416 / ((select count(*) from question_rating where question_id = question.id))) as score')
            ->whereRaw('(select count(*) from question_rating where question_id = question.id) > 0 and question.author_id in (select following_id from follow_member where follower_id = ?)', ['user_id' => $user_id])
            ->addSelect(DB::raw("'question' as type"));

        $query2 = DB::table('answer')
            ->selectRaw('id, (((select count(*) from answer_rating where answer_id = answer.id and rate = 1) + 1.9208) / ((select count(*) from answer_rating where answer_id = answer.id)) - 1.96 * SQRT(((select count(*) from answer_rating where answer_id = answer.id and rate = 1) * (select count(*) from answer_rating where answer_id = answer.id and rate = -1)) / ((select count(*) from answer_rating where answer_id = answer.id)) + 0.9604) / ((select count(*) from answer_rating where answer_id = answer.id))) / (1 + 3.8416 / ((select count(*) from answer_rating where answer_id = answer.id))) as score')
            ->whereRaw('(select count(*) from answer_rating where answer_id = answer.id) > 0 and answer.author_id in (select following_id from follow_member where follower_id = ?) ', ['user_id' => $user_id])
            ->addSelect(DB::raw("'answer' as type"));

        $data = $query1->union($query2)->orderBy('score', 'DESC')->get();

        return $this->getDataChunk($data,10);
    }

    public function getDataChunk($data,$maxNr){
        $chunkNr = request('chunk');

        $res = getDataChunk($data,$chunkNr,$maxNr);
        
        $res['data'] = $res['data']->map(function ($item, $key) {
            if ($item->type == 'question') {
                $item->question = new QuestionResource(Question::find($item->id));
            } else {
                $item->answer = new AnswerCardResource(Answer::find($item->id));
            }
            return $item;
        });


        return $res;
    }

    public function getTrendingTopics()
    {
        $data = DB::table('topic')
            ->select(DB::raw('count(*) as nrTimes, name'))
            ->join('question_topic', function ($join) {
                $join->on('topic.id', '=', 'question_topic.topic_id');
            })
            ->groupBy('name')
            ->orderByRaw('nrTimes DESC')
            ->limit(5)
            ->get();

        return $data;
    }

    public function getTopMembers()
    {
        $data = \App\Member::
        orderBy('score', 'DESC')
            ->limit(5)
            ->get();

        return MemberPartialResource::collection($data);
    }

    public function error()
    {
        return view('pages.404');
    }

}
