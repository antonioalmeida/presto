<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth')->except(['getNewContent', 'getTopContent', 'index', 'error']);
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('pages.index');
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

        $data = $query1->union($query2)->orderBy('score', 'DESC');

        dd($data->get());
        return;
    }

    public function getNewContent()
    {
        $query1 = DB::table('question')
            ->selectRaw('id, date')
            ->addSelect(DB::raw("'question' as type"));

        $query2 = DB::table('answer')
            ->selectRaw('id, date')
            ->addSelect(DB::raw("'answer' as type"));

        $data = $query1->union($query2)->orderBy('date', 'DESC');
        dd($data->get());
    }

    public function getRecommendedContent()
    {
        $user_id = Auth::user()->id;
        $query1 = DB::table('question')
            ->selectRaw('id, (((select count(*) from question_rating where question_id = question.id and rate = 1) + 1.9208) / ((select count(*) from question_rating where question_id = question.id)) - 1.96 * SQRT(((select count(*) from question_rating where question_id = question.id and rate = 1) * (select count(*) from question_rating where question_id = question.id and rate = -1)) / ((select count(*) from question_rating where question_id = question.id)) + 0.9604) / ((select count(*) from question_rating where question_id = question.id))) / (1 + 3.8416 / ((select count(*) from question_rating where question_id = question.id))) as score')
            ->whereRaw('(select count(*) from question_rating where question_id = question.id) > 0 and question.author_id in (select following_id from follow_member where follower_id = ?)', ['user_id' => $user_id])
            ->addSelect(DB::raw("'question' as type"));

        $query2 = DB::table('answer')
            ->selectRaw('id, (((select count(*) from answer_rating where answer_id = answer.id and rate = 1) + 1.9208) / ((select count(*) from answer_rating where answer_id = answer.id)) - 1.96 * SQRT(((select count(*) from answer_rating where answer_id = answer.id and rate = 1) * (select count(*) from answer_rating where answer_id = answer.id and rate = -1)) / ((select count(*) from answer_rating where answer_id = answer.id)) + 0.9604) / ((select count(*) from answer_rating where answer_id = answer.id))) / (1 + 3.8416 / ((select count(*) from answer_rating where answer_id = answer.id))) as score')
            ->whereRaw('(select count(*) from answer_rating where answer_id = answer.id) > 0 and answer.author_id in (select following_id from follow_member where follower_id = ?) ', ['user_id' => $user_id])
            ->addSelect(DB::raw("'answer' as type"));

        $data = $query1->union($query2)->orderBy('score', 'DESC');
        dd($data->get());
    }


    public function error()
    {

        return view('pages.404');
    }

}
