<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use DB;

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

        return ['number' => $no_answers, 'views' => $no_views];
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
