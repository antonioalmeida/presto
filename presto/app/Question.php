<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @property int $id
 * @property int $author_id
 * @property string $title
 * @property string $content
 * @property string $date
 * @property boolean $solved
 * @property string $search
 * @property Member $member
 * @property QuestionReport[] $questionReports
 * @property Topic[] $topics
 * @property Answer[] $answers
 * @property Comment[] $comments
 * @property QuestionRating[] $questionRatings
 */
class Question extends Model
{
    use SoftDeletes;
    
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'question';

    /**
     * @var array
     */
    protected $fillable = ['author_id', 'title', 'content', 'date', 'solved', 'search', 'topics'];

    protected $hidden = ['search'];

    /**
     * Queries
     */

    public function getTopics()
    {
        return $this->topics;
    }

    public function getAnswers()
    {
        return $this->answers;
    }

    public function getNumAnswers()
    {
        return count($this->answers);
    }

    public function addComment($comment)
    {
        return $this->comments()->create($comment);
    }

    public function comments()
    {
        return $this->hasMany('App\Comment');
    }

    public function addTopic($topic)
    {
        return $this->topics()->attach($topic);
    }

    public function topics()
    {
        return $this->belongsToMany('App\Topic');
    }

    /**
     * Relations
     */
    public function member()
    {
        return $this->belongsTo('App\Member', 'author_id');
    }

    public function questionReports()
    {
        return $this->hasMany('App\QuestionReport');
    }

    public function answers()
    {
        return $this->hasMany('App\Answer');
    }

    public function questionRatings()
    {
        return $this->hasMany('App\QuestionRating');
    }
}
