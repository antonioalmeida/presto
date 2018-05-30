<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $question_id
 * @property int $member_id
 * @property string $date
 * @property string $reason
 * @property Comment $comment
 * @property Member $member
 */
class CommentReport extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'comment_report';

    protected $fillable = ['comment_id', 'member_id', 'date', 'reason'];

    public function comment()
    {
        return $this->belongsTo('App\Comment');
    }

    public function member()
    {
        return $this->belongsTo('App\Member');
    }
}
