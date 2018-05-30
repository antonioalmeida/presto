<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $question_id
 * @property int $member_id
 * @property string $date
 * @property string $reason
 * @property Answer $answer
 * @property Member $member
 */
class AnswerReport extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'answer_report';

    protected $fillable = ['answer_id', 'member_id', 'date', 'reason'];

    public function answer()
    {
        return $this->belongsTo('App\Answer');
    }

    public function member()
    {
        return $this->belongsTo('App\Member');
    }
}