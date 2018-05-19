<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property string $name
 * @property Member[] $members
 */
class Country extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'country';

    protected $fillable = ['name'];

    public function members()
    {
        return $this->hasMany('App\Member');
    }
}
