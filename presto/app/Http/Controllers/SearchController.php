<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

use App\Http\Resources\MemberResource;
use App\Http\Resources\QuestionResource;
use App\Http\Resources\AnswerCardResource;
use App\Http\Resources\TopicCardResource;

class SearchController extends Controller
{
    //
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function get($query) {
        // Content type being searched 
        // (Questions, Answers, Topics, Members)
        $type = request('type'); 

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

      return $result;
  }

    private function getQuestions($search_input){

        $questions = \App\Question::whereRaw('search @@ to_tsquery(\'english\', ?)', [$search_input])
                    ->orderByRaw('ts_rank(search, to_tsquery(\'english\', ?)) DESC', [$search_input])
                    ->limit(10)
                    ->get();

        return QuestionResource::collection($questions);
    }

    private function getAnswers($search_input) {
        $answers = \App\Answer::whereRaw('search @@ to_tsquery(\'english\', ?)', [$search_input])
        ->orderByRaw('ts_rank(search, to_tsquery(\'english\', ?)) DESC', [$search_input])
        ->limit(10)
        ->get();

        return AnswerCardResource::collection($answers);
    }

    private function getTopics($search_input){
        $topics = \App\Topic::where('name', 'ILIKE', '%' . $search_input .'%')
                ->limit(10)
                ->get();

        return TopicCardResource::collection($topics);
    }

    private function getMembers($search_input){
        $members = \App\Member::where('username', 'ILIKE', '%' . $search_input .'%')
                    ->orWhere('name', 'ILIKE', '%' . $search_input .'%')
                    ->limit(10)
                    ->get();

        return MemberResource::collection($members);
    }
}
