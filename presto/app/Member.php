<?php

namespace App;

use DB;
use App\Presto\Follow;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use \App\Topic;

require_once app_path().'/Utils.php';

/**
 * @property int $id
 * @property int $country_id
 * @property string $username
 * @property string $email
 * @property string $password
 * @property string $name
 * @property string $bio
 * @property string $profile_picture
 * @property int $positive_votes
 * @property int $total_votes
 * @property int $nr_questions
 * @property int $nr_answers
 * @property int $score
 * @property boolean $is_banned
 * @property boolean $is_moderator
 * @property boolean $is_certified
 * @property Country $country
 * @property Notification[] $notifications
 * @property Topic[] $topics
 * @property CommentRating[] $commentRatings
 * @property QuestionReport[] $questionReports
 * @property AnswerReport[] $answerReports
 * @property CommentReport[] $commentReports
 * @property Flag[] $flags
 * @property Question[] $questions
 * @property Answer[] $answers
 * @property Comment[] $comments
 * @property QuestionRating[] $questionRatings
 * @property AnswerRating[] $answerRatings
 * @property Member[] $members
 */
class Member extends Authenticatable
{
    use Notifiable, Follow;

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The table associated with the model.
     */
    protected $table = 'member';

    protected $fillable = ['country_id', 'username', 'email', 'password', 'name', 'bio', 'profile_picture', 'positive_votes', 'total_votes', 'nr_questions', 'nr_answers', 'score', 'is_banned', 'is_moderator', 'is_certified'];

    /**
     * The attributes that should be hidden for arrays.
     */
    protected $hidden = [
        'password', 'remember_token', 'positive_votes', 'total_votes', 'is_banned', 
//        'password', 'remember_token', 'email', 'positive_votes', 'total_votes', 'is_banned', 'is_moderator','pivot' 
    ];

    public function getRouteKeyName(){
        return 'username';
    }
    
    /**
     * Queries
     */

     public function getAnswerViews() {
        return print_number_count($this->answers->sum('views'));
     }

    /*
    * Relations
    */

     public function country()
    {
        return $this->belongsTo('App\Country');
    }

    // public function notifications()
    // {
    //     return $this->hasMany('App\Notification');
    // }

    public function commentRatings()
    {
        return $this->hasMany('App\CommentRating');
    }

    public function questionReports()
    {
        return $this->hasMany('App\QuestionReport');
    }

    public function answerReports()
    {
        return $this->hasMany('App\AnswerReport');
    }

    public function commentReports()
    {
        return $this->hasMany('App\CommentReport');
    }

    public function flags()
    {
        return $this->hasMany('App\Flag');
    }

    public function questions()
    {
        return $this->hasMany('App\Question', 'author_id');
    }

    public function answers()
    {
        return $this->hasMany('App\Answer', 'author_id');
    }

    public function comments()
    {
        return $this->hasMany('App\Comment', 'author_id');
    }

    public function questionRatings()
    {
        return $this->hasMany('App\QuestionRating', 'member_id', 'question_id');
    }

    public function answerRatings()
    {
        return $this->hasMany('App\AnswerRating', 'member_id', 'answer_id');
    }

    public function followers()
    {
        return $this->belongsToMany(Member::class, 'follow_member', 'following_id', 'follower_id');
    }

    public function followings()
    {
        return $this->belongsToMany(Member::class, 'follow_member', 'follower_id', 'following_id');
    }

    public function topics()
    {
        return $this->belongsToMany('App\Topic', 'follow_topic', 'member_id', 'topic_id');
    }

}
