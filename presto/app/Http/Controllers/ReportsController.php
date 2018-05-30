<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\QuestionReport;
use App\CommentReport;
use App\AnswerReport;

class ReportsController extends Controller
{
	public function __construct()
    {
        $this->middleware('moderator')->except(['get']);
    }

    public function getReports() {
    	$answers = AnswerReport::limit(10)->get();
    	$questions = QuestionReport::limit(10)->get()->concat($answers);
    	$all = CommentReport::limit(10)->get()->concat($questions);

    	foreach($all as $report){
    	    $report['member'] = \App\Member::find($report->member_id);
    	    if($report->comment_id != null){
                $report['comment'] = \App\Comment::find($report->comment_id);
            } else if($report->answer_id != null){
                $report['answer'] = \App\Answer::find($report->answer_id);
            } else if($report->question_id != null){
                $report['question'] = \App\Question::find($report->question_id);
            }
        }
    	return $all;
    }

}
