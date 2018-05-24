<?php

namespace App;

use DB;
use Illuminate\Database\Eloquent\Model;

require_once app_path() . '/Utils.php';

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
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'topic';

    protected $fillable = ['name', 'description', 'picture'];

    protected $hidden = ['pivot'];

    public function getRouteKeyName()
    {
        return 'name';
    }

    public function getNumFollowers()
    {
        return $this->followers->count();
    }

    public function getNumViews()
    {
        $nrViews = 0.0;

        foreach ($this->questions as $question)
            $nrViews += $question->answers->sum('views');

        return print_number_count($nrViews);
    }

    public function getAnswersStats()
    {
        $no_answers = 0.0;
        $no_views = 0.0;

        foreach ($this->questions as $question) {
            $no_answers += $question->answers->count();
            $no_views += $question->answers->sum('views');
        }

        return ['number' => $no_answers, 'views' => print_number_count($no_views)];
    }

    public function getRelatedTopics()
    {
        $sub_query = DB::table('question_topic')
            ->where('topic_id', $this->id)
            ->pluck('question_id');

        $query = DB::table('topic')
            ->select(DB::raw('count(*) as nrTimes, name'))
            ->join('question_topic', function ($join) {
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

    public function questions()
    {
        return $this->belongsToMany('App\Question');
    }

    public function followers()
    {
        return $this->belongsToMany(Member::class, 'follow_topic', 'topic_id', 'member_id');
    }

}
