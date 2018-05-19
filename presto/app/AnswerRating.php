<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @property int $answer_id
 * @property int $member_id
 * @property int $rate
 * @property Answer $answer
 * @property Member $member
 */
class AnswerRating extends Model
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
    protected $table = 'answer_rating';

    protected $fillable = ['answer_id', 'member_id', 'rate'];


    public function answer()
    {
        return $this->belongsTo('App\Answer');
    }

    public function member()
    {
        return $this->belongsTo('App\Member', 'author_id');
    }
}
