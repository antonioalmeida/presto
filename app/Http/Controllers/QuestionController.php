<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

use \App\Question;
use \App\Topic;

class QuestionController extends Controller
{
    public function show(Question $question){
        return view('pages.question.show', compact('question'));
    }

    public function create()
	{
		// $this->validate(request(), [
		// 	'content' => 'required|min:2',
		// 	'question_id' => 'required|integer|min:0'
		// ]);

		// $content = request('content');
		// $question_id = request('question_id');
		// $author_id = Auth::id();
		// $date = now();

		// $question = \App\Question::find($question_id);
		// $comment = $question->addComment(compact('author_id', 'content', 'date'));
		// $view = view('partials.comment', compact('comment'))->render();
		
        // return $this->sendResponse($view, $comment);
        
        // $this->validate($request, [
        //     'body' => 'required|max:1000'
        // ]);
        // $post = new Post();
        // $post->body = $request['body'];
        // $message = 'There was an error';
        // if ($request->user()->posts()->save($post)) {
        //     $message = 'Post successfully created!';
        // }
        // return redirect()->route('dashboard')->with(['message' => $message]);
    }
    
    public function store(){  
        $this->validate(request(), [
            'title' => 'required',
            'tags'  => 'required'
        ]);
          
        $question = new Question();
        $question->title = request('title');
        $question->date = now();
        request()->user()->questions()->save($question);
        //$question->topics()->attach();
        $tags = explode(',', request('tags'));

        foreach ($tags as $tag){
            // $topic[$tag] = Topic::where('name', 'ILIKE', $tag)->get();
            $topic = Topic::whereRaw('lower(name) ILIKE ?', array(trim($tag)))->get();
            
            if($topic->isEmpty()){
                $newTopic = new Topic();
                $newTopic->name = $tag;
                $newTopic->save();
                $question->topics()->attach($newTopic);
            } else {
                try{
                $question->addTopic($topic->first());
                } catch (\Illuminate \Database\QueryException $e){

                }
            }
        }
        

        session()->flash('message','Your question has now been published');
        print_r($question->id);
        return redirect()->route('question', $question);
      }

}
