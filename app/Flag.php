<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $member_id
 * @property int $moderator_id
 * @property string $date
 * @property string $reason
 * @property Member $member
 * @property Member $member
 */
class Flag extends Model
{
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'flag';

    /**
     * @var array
     */
    protected $fillable = ['date', 'reason'];

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function member()
    {
        return $this->belongsTo('App\Member');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function member()
    {
        return $this->belongsTo('App\Member');
    }
}
