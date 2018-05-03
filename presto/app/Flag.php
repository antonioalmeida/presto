<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $member_id
 * @property int $moderator_id
 * @property string $date
 * @property string $reason
 * @property Member $member
 */
class Flag extends Model
{
     // Don't add create and update timestamps in database.
     public $timestamps  = false;
     
    /**
     * The table associated with the model.
     */
    protected $table = 'flag';

    protected $fillable = ['date', 'reason'];


    public function member()
    {
        return $this->belongsTo('App\Member','member_id');
    }


    public function moderator()
    {
        return $this->belongsTo('App\Member','moderator_id');
    }
}
