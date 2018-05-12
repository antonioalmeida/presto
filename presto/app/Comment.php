<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int $question_id
 * @property int $answer_id
 * @property int $author_id
 * @property string $content
 * @property string $date
 * @property Question $question
 * @property Member $member
 * @property Answer $answer
 * @property CommentRating[] $commentRatings
 * @property CommentReport[] $commentReports
 */
class Comment extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'comment';

    protected $fillable = ['question_id', 'answer_id', 'author_id', 'content', 'date'];

    public function question()
    {
        return $this->belongsTo('App\Question', 'question_id');
    }

    public function member()
    {
        return $this->belongsTo('App\Member', 'author_id');
    }

    public function answer()
    {
        return $this->belongsTo('App\Answer', 'answer_id');
    }

    public function commentRatings()
    {
        return $this->hasMany('App\CommentRating');
    }

    public function commentReports()
    {
        return $this->hasMany('App\CommentReport');
    }
}
