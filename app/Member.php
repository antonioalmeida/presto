<?php

namespace App;

use DB;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
require app_path().'/Utils.php';

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
    use Notifiable;

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'member';

    /**
     * @var array
     */
    protected $fillable = ['country_id', 'username', 'email', 'password', 'name', 'bio', 'profile_picture', 'positive_votes', 'total_votes', 'nr_questions', 'nr_answers', 'score', 'is_banned', 'is_moderator'];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token'
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

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function country()
    {
        return $this->belongsTo('App\Country');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function notifications()
    {
        return $this->hasMany('App\Notification');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function topics()
    {
        return $this->belongsToMany('App\Topic', 'follow_topic');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function commentRatings()
    {
        return $this->hasMany('App\CommentRating');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function questionReports()
    {
        return $this->hasMany('App\QuestionReport');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function answerReports()
    {
        return $this->hasMany('App\AnswerReport');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function commentReports()
    {
        return $this->hasMany('App\CommentReport');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function flags()
    {
        return $this->hasMany('App\Flag');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
//    public function flags()
//    {
//        return $this->hasMany('App\Flag');
//    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function questions()
    {
        return $this->hasMany('App\Question', 'author_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function answers()
    {
        return $this->hasMany('App\Answer', 'author_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function comments()
    {
        return $this->hasMany('App\Comment', 'author_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function questionRatings()
    {
        return $this->hasMany('App\QuestionRating');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function answerRatings()
    {
        return $this->hasMany('App\AnswerRating');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    // public function members()
    // {
    //     return $this->belongsToMany('App\Member', 'follow_member', 'following_id', 'follower_id');
    // }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function followers()
    {
        return $this->belongsToMany(Member::class, 'follow_member', 'following_id', 'follower_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function followings()
    {
        return $this->belongsToMany(Member::class, 'follow_member', 'follower_id', 'following_id');
    }

    /**
     * Check if a given user is following this user.
     *
     * @param Member $member
     * @return bool
     */
    public function isFollowing(Member $member)
    {
        return !! $this->followings()->where('following_id', $member->id)->count();
    }

    /**
     * Check if a given user is being followed by this user.
     *
     * @param Member $member
     * @return bool
     */
    public function isFollowedBy(Member $member)
    {
        return !! $this->followers()->where('follower_id', $member->id)->count();
    }

    /**
     * Follow the given user.
     *
     * @param User $user
     * @return mixed
     */
    public function follow(Member $member)
    {
        if (! $this->isFollowing($member) && $this->id != $member->id)
        {
            $this->followings()->attach($member);
        }
    }

    /**
     * Unfollow the given user.
     *
     * @param User $user
     * @return mixed
     */
    public function unFollow(Member $member)
    {
        return $this->followings()->detach($member);
    }

}
