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

    	return $all;
    }

}
