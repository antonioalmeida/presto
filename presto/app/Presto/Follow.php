<?php
namespace App\Presto;

use App\Member;
use App\Topic;

trait Follow
{

    //Follow members

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

    //Follow topics
    public function isFollowingTopic(Topic $topic)
    {
        return !! $this->topics()->where('topic_id', $topic->id)->count();
    }
   
    public function followTopic(Topic $topic)
    {
        if (! $this->isFollowingTopic($topic))
        {
            $this->topics()->attach($topic);
        }
    }

    public function unFollowTopic(Topic $topic)
    {
        return $this->topics()->detach($topic);
    }
}