<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use DB;
require_once app_path().'/Utils.php';

/**
 * @property int $id
 * @property string $name
 * @property string $description
 * @property string $picture
 * @property Member[] $members
 * @property Question[] $questions
 */
class Topic extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'topic';

    /**
     * @var array
     */
    protected $fillable = ['name', 'description', 'picture'];

    public function getRouteKeyName(){
        return 'name';
    }

    public function getNumFollowers(){
        return $this->members->count();
    }

    public function getAnswersStats(){
        $no_answers = 0.0;
        $no_views = 0.0;

        foreach ($this->questions as $question){
            $no_answers += $question->answers->count();
            $no_views += $question->answers->sum('views');
        }

        return ['number' => $no_answers, 'views' => print_number_count($no_views)];
    }

    public function getRelatedTopics(){
        $sub_query = DB::table('question_topic')
                        ->where('topic_id', $this->id)
                        ->pluck('question_id');

         $query = DB::table('topic')
		 ->select(DB::raw('count(*) as nrTimes, name'))
		 ->join('question_topic', function($join) {
		 	$join->on('topic.id', '=', 'question_topic.topic_id');
		 	})
		 ->whereIn('question_id', $sub_query)
		 ->where('topic_id', '<>', $this->id)
         ->groupBy('name')
         ->orderByRaw('nrTimes DESC')
         ->limit(5)
         ->get();
        
        return $query;
    }
    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function members()
    {
        return $this->belongsToMany('App\Member', 'follow_topic');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function questions()
    {
        return $this->belongsToMany('App\Question');
    }

}
