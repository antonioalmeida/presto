<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

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
