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
			'body' => 'required|min:2'
		]);

		$content = request('body');
		$author_id = Auth::id();
		$question_id = 3;
		$date = now();

		$question = \App\Question::find($question_id);
		$newComment = $question->addComment(compact('author_id', 'content', 'date'));

		return $this->sendResponse(200, $newComment);
	}
}
