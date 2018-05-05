<?php
namespace App\Presto;

use App\Member;
use App\Topic;

use App\Notifications\MemberFollowed;

trait Follow
{

    //Follow members

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
            $member->notify(new MemberFollowed($this));
            
            return $this->followings()->attach($member);
        }

        return false;
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

    public function followTopic(Topic $topic)
    {
        if (! $this->isFollowingTopic($topic)) {
            $this->topics()->attach($topic);
            return true;
        }
        
        return false;
    }

    public function isFollowingTopic(Topic $topic)
    {
        return !! $this->topics()->where('topic_id', $topic->id)->count();
    }

    public function unFollowTopic(Topic $topic)
    {
        return $this->topics()->detach($topic);
    }
}