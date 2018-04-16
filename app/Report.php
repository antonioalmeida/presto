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
class Report extends Model
{
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'question_report';

    /**
     * @var array
     */
    protected $fillable = ['date', 'reason'];

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
        return $this->belongsTo('App\Member');
    }
}
