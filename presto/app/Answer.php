<?php

namespace App;

use Illuminate\Database\Eloquent\Model;


/**
 * @property int $id
 * @property int $question_id
 * @property int $author_id
 * @property string $content
 * @property string $date
 * @property string $search
 * @property Member $member
 * @property Question $question
 * @property AnswerReport[] $answerReports
 * @property Comment[] $comments
 * @property AnswerRating[] $answerRatings
 */
class Answer extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'answer';

    protected $hidden = ['search'];

    protected $fillable = ['question_id', 'author_id', 'content', 'date', 'search', 'is_chosen_answer'];

    public function member()
    {
        return $this->belongsTo('App\Member', 'author_id');
    }

    public function question()
    {
        return $this->belongsTo('App\Question');
    }

    public function answerReports()
    {
        return $this->hasMany('App\AnswerReport');
    }

    public function comments()
    {
        return $this->hasMany('App\Comment');
    }

    public function answerRatings()
    {
        return $this->hasMany('App\AnswerRating');
    }
}
