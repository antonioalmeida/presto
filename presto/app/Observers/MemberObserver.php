<?php

namespace App\Observers;

use App\Mail\Welcome;
use App\Member;


class MemberObserver
{
    public function created(Member $member)
    {
        \Mail::to($member)->send(new Welcome($member));
    }
}
 