<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int $member_id
 * @property string $type
 * @property string $date
 * @property string $content
 * @property boolean $read
 * @property Member $member
 */
class Notification extends Model
{
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'notification';

    /**
     * @var array
     */
    protected $fillable = ['member_id', 'type', 'date', 'content', 'read'];

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function member()
    {
        return $this->belongsTo('App\Member');
    }
}
