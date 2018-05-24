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
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     */
    // protected $table = 'notification';

    // protected $fillable = ['member_id', 'type', 'date', 'content', 'read'];

    // public function member()
    // {
    //     return $this->belongsTo('App\Member');
    // }
}
