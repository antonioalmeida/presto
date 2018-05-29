<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $question_id
 * @property int $member_id
 * @property string $date
 * @property string $reason
 * @property Question $question
 * @property Member $member
 */
class QuestionReport extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'question_report';

    protected $fillable = ['question_id', 'member_id', 'date', 'reason'];

    public function question()
    {
        return $this->belongsTo('App\Question');
    }

    public function member()
    {
        return $this->belongsTo('App\Member');
    }
}
