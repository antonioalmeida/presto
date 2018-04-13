<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int $author_id
 * @property string $title
 * @property string $content
 * @property string $date
 * @property int $views
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
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'question';

    /**
     * @var array
     */
    protected $fillable = ['author_id', 'title', 'content', 'date', 'views', 'solved', 'search'];

    /**
     * Queries
     */

    public function getTopics() {
        return $this->topics;
    }

    public function getAnswers() {
        return $this->answers;
    }

    public function getNumAnswers() {
        return count($this->answers);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function member()
    {
        return $this->belongsTo('App\Member', 'author_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function questionReports()
    {
        return $this->hasMany('App\QuestionReport');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function topics()
    {
        return $this->belongsToMany('App\Topic');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function answers()
    {
        return $this->hasMany('App\Answer');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function comments()
    {
        return $this->hasMany('App\Comment');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function questionRatings()
    {
        return $this->hasMany('App\QuestionRating');
    }
}
