<?php

namespace App\Http\Controllers;

use App\Http\Resources\AnswerCardResource;
use App\Http\Resources\MemberResource;
use App\Http\Resources\QuestionResource;
use App\Http\Resources\TopicCardResource;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function get(Request $request, $query)
    {
        // Content type being searched
        // (Questions, Answers, Topics, Members)
        $type = $request->input('type');
        $chunk = intval($request->input('chunk'));
        $maxNr = 10;

        $result = [];

        switch ($type) {
            case 'questions':
                $result = $this->getQuestions($query,$chunk,$maxNr);
                break;
            case 'answers':
                $result = $this->getAnswers($query,$chunk,$maxNr);
                break;
            case 'topics':
                $result = $this->getTopics($query,$chunk,$maxNr);
                break;
            case 'members':
                $result = $this->getMembers($query,$chunk,$maxNr);
                break;
            default:
                break;
        }

        return $result;
    }

    private function getQuestions($search_input,$chunkNr,$maxNr)
    {
        $questions = \App\Question::whereRaw('search @@ to_tsquery(\'english\', replace(plainto_tsquery(\'english\', ?)::text, \'&\', \'|\'))', [$search_input])
            ->orderByRaw('ts_rank(search, to_tsquery(\'english\', replace(plainto_tsquery(\'english\', ?)::text, \'&\', \'|\'))) DESC', [$search_input])
            ->get();

        $res = getDataChunk($questions,$chunkNr,$maxNr);

        $res['data'] = QuestionResource::collection($res['data']);
        return $res;
    }

    private function getAnswers($search_input,$chunkNr,$maxNr)
    {
        $answers = \App\Answer::whereRaw('search @@ plainto_tsquery(\'english\', ?)', [$search_input])
            ->orderByRaw('ts_rank(search, plainto_tsquery(\'english\', ?)) DESC', [$search_input])
            ->get();

        $res = getDataChunk($answers,$chunkNr,$maxNr);

        $res['data'] = AnswerCardResource::collection($res['data']);
        return $res;
    }

    private function getTopics($search_input,$chunkNr,$maxNr)
    {
        $topics = \App\Topic::where('name', 'ILIKE', '%' . $search_input . '%')
            ->get();

        $res = getDataChunk($topics,$chunkNr,$maxNr);

        $res['data'] = TopicCardResource::collection($res['data']);
        return $res;
    }

    private function getMembers($search_input,$chunkNr,$maxNr)
    {
        $members = \App\Member::where('username', 'ILIKE', '%' . $search_input . '%')
            ->orWhere('name', 'ILIKE', '%' . $search_input . '%')
            ->get();

        $res = getDataChunk($members,$chunkNr,$maxNr);

        $res['data'] = MemberResource::collection($res['data']);
        return $res;
    }
}
