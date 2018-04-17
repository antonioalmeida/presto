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
    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'question_rating';

    protected $fillable = ['rate'];

    
    public function question()
    {
        return $this->belongsTo('App\Question');
    }

    public function member()
    {
        return $this->belongsTo('App\Member');
    }
}
