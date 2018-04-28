<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SearchController extends Controller
{
    //
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function search(){
        // $questions = getQuestions(request('text_search'));
        $questions = $this->getMembers('aalvaradoo');
        return view('pages.search');
    }
    
    private function getQuestions($search_input){

        $questions = \App\Question::whereRaw('search @@ to_tsquery(\'english\', ?)', [$search_input])
                    ->orderByRaw('ts_rank(search, to_tsquery(\'english\', ?)) DESC', [$search_input])
                    ->limit(10)
                    ->get();

        return $questions;
    }

    private function getAnswers($search_input){
        $answers = \App\Answer::whereRaw('search @@ to_tsquery(\'english\', ?)', [$search_input])
        ->orderByRaw('ts_rank(search, to_tsquery(\'english\', ?)) DESC', [$search_input])
        ->limit(10)
        ->get();
        dd($answers);
        return $answers;
    }

    private function getTopics($search_input){
        $topics = \App\Topic::where('name', 'ILIKE', '%' . $search_input .'%')
                ->limit(10)
                ->get();
        dd($topics);
         return $topics;

    }

    private function getMembers($search_input){
        $members = \App\Member::where('username', 'ILIKE', '%' . $search_input .'%')
                    ->orWhere('name', 'ILIKE', '%' . $search_input .'%')
                    ->limit(10)
                    ->get();
        dd($members);
        return $members;
    }
}
