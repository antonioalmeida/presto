<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int $question_id
 * @property int $author_id
 * @property string $content
 * @property string $date
 * @property int $views
 * @property string $search
 * @property Member $member
 * @property Question $question
 * @property AnswerReport[] $answerReports
 * @property Comment[] $comments
 * @property AnswerRating[] $answerRatings
 */
class Answer extends Model
{
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'answer';

    /**
     * @var array
     */
    protected $fillable = ['question_id', 'author_id', 'content', 'date', 'views', 'search'];

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function member()
    {
        return $this->belongsTo('App\Member', 'author_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function question()
    {
        return $this->belongsTo('App\Question');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function answerReports()
    {
        return $this->hasMany('App\AnswerReport');
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
    public function answerRatings()
    {
        return $this->hasMany('App\AnswerRating');
    }
}
