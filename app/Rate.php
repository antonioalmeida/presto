<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $question_id
 * @property int $member_id
 * @property int $rate
 * @property Question $question
 * @property Member $member
 */
class Rate extends Model
{
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'question_rating';

    /**
     * @var array
     */
    protected $fillable = ['rate'];

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
