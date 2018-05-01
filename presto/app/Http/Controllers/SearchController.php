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
        $type = request('type'); // Content type being searched (Questions, Answers, Topics, Members)
        $query = request('text_search');
        $result = [];
        switch($type) {
          case 'questions':
            $result = $this->getQuestions($query);
            break;
          case 'answers':
            $result = $this->getAnswers($query);
            break;
          case 'topics':
            $result = $this->getTopics($query);
            break;
          case 'members':
            $result = $this->getMembers($query);
            break;
          default:
            break;
        }

        return view('pages.search', compact('query', 'result', 'type'));
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

        return $answers;
    }

    private function getTopics($search_input){
        $topics = \App\Topic::where('name', 'ILIKE', '%' . $search_input .'%')
                ->limit(10)
                ->get();

        return $topics;
    }

    private function getMembers($search_input){
        $members = \App\Member::where('username', 'ILIKE', '%' . $search_input .'%')
                    ->orWhere('name', 'ILIKE', '%' . $search_input .'%')
                    ->limit(10)
                    ->get();

        return $members;
    }
}
