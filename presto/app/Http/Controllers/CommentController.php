<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\ApiBaseController;

use App\Comment;

class CommentController extends ApiBaseController
{
	public function create()
	{
		$this->validate(request(), [
			'content' => 'required|min:2',
			'question_id' => 'required|integer|min:0'
		]);

		$content = request('content');
		$question_id = request('question_id');
		$author_id = Auth::id();
		$date = now();

		$question = \App\Question::find($question_id);
		$comment = $question->addComment(compact('author_id', 'content', 'date'));
		$view = view('partials.comment', compact('comment'))->render();
		
		return $this->sendResponse($view, $comment);
	}
}
