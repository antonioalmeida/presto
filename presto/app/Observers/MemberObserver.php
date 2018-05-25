<?php

namespace App\Observers;

use App\Member;
use App\Mail\Welcome;


class MemberObserver
{
    public function created(Member $member)
    {
        \Mail::to($member)->send(new Welcome($member));
    }
}
 