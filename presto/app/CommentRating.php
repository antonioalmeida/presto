<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @property int $comment_id
 * @property int $member_id
 * @property int $rate
 * @property Comment $comment
 * @property Member $member
 */
class CommentRating extends Model
{

    use SoftDeletes;

    /**
     * The attributes that should be mutated to dates.
     *
     * @var array
     */
    protected $dates = ['deleted_at'];

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'comment_rating';

    protected $fillable = ['comment_id','member_id','rate'];

    
    public function comment()
    {
        return $this->belongsTo('App\Comment');
    }

    public function member()
    {
        return $this->belongsTo('App\Member', 'author_id');
    }
}
