<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\AnswerResource;
use App\Http\Resources\AnswerPartialResource;
use App\Http\Resources\FullQuestionResource;
use App\Http\Resources\QuestionResource;
use App\Question;
use App\QuestionRating;
use App\QuestionReport;
use App\Topic;
use App\Answer;

class QuestionController extends Controller
{

    public function __construct()
    {
        $this->middleware('auth')->except(['get', 'getAnswers']);
    }

    public function get(Question $question)
    {
        return new FullQuestionResource($question);
    }

    public function getAnswers(Question $question)
    {
        return AnswerPartialResource::collection($question->answers);
    }

    public function store()
    {
        $this->validate(request(), [
            'title' => 'required',
            'tags' => 'required'
        ]);

        $question = new Question();
        $question->title = request('title');
        $date = new \DateTime("now", new \DateTimeZone('Europe/Lisbon'));
        $question->date = $date->format('Y-m-d H:i:s');
        request()->user()->questions()->save($question);

        $tags = request('tags');
        DB::transaction(function () use ($tags, $question) {
            foreach ($tags as $tag) {
                $topic = Topic::whereRaw('lower(name) ILIKE ?', array(trim($tag)))->get();

                if ($topic->isEmpty()) {
                    $newTopic = new Topic();
                    $newTopic->name = $tag;
                    $newTopic->picture = 'http://identicon.org/?t=' . $tag . '&s=256';
                    $newTopic->save();
                    $question->topics()->attach($newTopic);
                } else {
                    try {
                        $question->addTopic($topic->first());
                    } catch (\Illuminate \Database\QueryException $e) {

                    }
                }
            }
        });

        return new QuestionResource($question);
    }

    public function update(Question $question) {

        $this->validate(request(), [
            'title' => 'required',
            'content' => 'required',
            'topics' => 'required'
        ]);

        $question->title = request('title');
        $question->content = request('content');

        $tags = request('topics');
        $question->topics()->delete();

        DB::transaction(function () use ($tags, $question) {
            foreach ($tags as $tag) {
                $topic = Topic::whereRaw('lower(name) ILIKE ?', array(trim($tag)))->get();

                if ($topic->isEmpty()) {
                    $newTopic = new Topic();
                    $newTopic->name = $tag;
                    $newTopic->picture = 'http://identicon.org/?t=' . $tag . '&s=256';
                    $newTopic->save();
                    $question->topics()->attach($newTopic);
                } else {
                    try {
                        $question->addTopic($topic->first());
                    } catch (\Illuminate \Database\QueryException $e) {

                    }
                }
            }
        });

        $question->save();

        $response = [
            'title' => $question->title,
            'content' => $question->content,
            'topics' => $question->topics
        ];

        return $response;
    }

    public function delete(Question $question) {
        $result = false;
        if($question->delete())
            $result = true;

        return compact('result');
    }

    public function rate(Question $question)
    {
        $this->authorize('rate', $question);

        $existing_rate = QuestionRating::withTrashed()->whereQuestionId($question->id)->whereMemberId(Auth::id())->first();
        $finalValue = request('rate');

        if (is_null($existing_rate)) {
            QuestionRating::create([
                'question_id' => $question->id,
                'member_id' => Auth::id(),
                'rate' => request('rate')
            ]);
        } else {
            if (is_null($existing_rate->deleted_at)) {
                if ($existing_rate->rate == request('rate')) {
                    $existing_rate->delete();
                    $finalValue = 0;
                } else {
                    $existing_rate->rate = request('rate');
                    $existing_rate->save();
                }
            } else {
                $existing_rate->restore();
                $existing_rate->rate = request('rate');
                $existing_rate->save();
            }
        }

          $response = [
            'isUpvoted' => $finalValue == 1 ? true : false,
            'isDownvoted' => $finalValue == -1 ? true : false,
            'upvotes' => $question->questionRatings->where('rate', 1)->count(),
            'downvotes' => $question->questionRatings->where('rate', -1)->count()
        ];

        return $response;
    }

    public function solve(Question $question)
    {
        $this->authorize('solve', $question);

        $this->validate(request(), [
            'answerId' => 'required|numeric'
        ]);

        $question->solved = true;
        $question->save();

        $answer = Answer::find(request('answerId'));
        $answer->is_chosen_answer = true;
        $answer->save();
    }

    public function unsolve(Question $question)
    {
        $this->authorize('solve', $question);

        $question->solved = false;
        $question->save();
    }

    public function report(Question $question) {
        $this->validate(request(), [
            'reason' => 'required|min:5'
        ]);

        $result = QuestionReport::create([
            'question_id' => $question->id,
            'member_id' => Auth::id(),
            'reason' => request('reason'),
            'date' => now()
        ]);

        return compact('result');
    }
}
