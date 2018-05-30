<?php

namespace App;

use Illuminate\Foundation\Auth\User as Authenticatable;

/**
 * @property int $id
 * @property string $email
 * @property string $password
 */
class Admin extends Authenticatable
{
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    protected $guard = 'admin';

    /**
     * The table associated with the model.
     */
    protected $table = 'admin';

    protected $fillable = ['email', 'password'];

}
