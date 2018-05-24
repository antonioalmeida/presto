<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @property int $question_id
 * @property int $member_id
 * @property int $rate
 * @property Question $question
 * @property Member $member
 */
class QuestionRating extends Model
{

    use SoftDeletes;

    public $timestamps = false;

    // Don't add create and update timestamps in database.
    /**
     * The attributes that should be mutated to dates.
     *
     * @var array
     */
    protected $dates = ['deleted_at'];
    /**
     * The table associated with the model.
     */
    protected $table = 'question_rating';

    protected $fillable = ['question_id', 'member_id', 'rate'];


    public function question()
    {
        return $this->belongsTo('App\Question');
    }

    public function member()
    {
        return $this->belongsTo('App\Member', 'author_id');
    }
}
