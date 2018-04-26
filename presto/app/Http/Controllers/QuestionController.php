<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use \App\Question;
use \App\Topic;
use \App\QuestionRating;

class QuestionController extends Controller
{
    public function show(Question $question){
        return view('pages.question.show', compact('question'));
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
        return redirect()->route('question', $question);
      }

 public function isLikedByMe($id)
 {
    $question = Question::findOrFail($id)->first();
    if (QuestionRating::whereUserId(Auth::id())->wherePostId($question->id)->exists()){
        return 'true';
    }
    return 'false';
}

public function like(Question $question)
{
    $existing_like = QuestionRating::withTrashed()->wherePostId($question->id)->whereUserId(Auth::id())->first();

    if (is_null($existing_like)) {
        QuestionRating::create([
            'post_id' => $question->id,
            'user_id' => Auth::id(),
            'rate' => 1
        ]);
    } else {
        if (is_null($existing_like->deleted_at)) {
            $existing_like->delete();
        } else {
            $existing_like->restore();
        }
    }
}
}
