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
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'comment';

    /**
     * @var array
     */
    protected $fillable = ['question_id', 'answer_id', 'author_id', 'content', 'date'];

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function question()
    {
        return $this->belongsTo('App\Question');
    }

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
    public function answer()
    {
        return $this->belongsTo('App\Answer');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function commentRatings()
    {
        return $this->hasMany('App\CommentRating');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function commentReports()
    {
        return $this->hasMany('App\CommentReport');
    }
}
