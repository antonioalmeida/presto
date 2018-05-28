<?php

namespace App\Rules;

use Illuminate\Contracts\Validation\Rule;
use App\Member;

class BannedMember implements Rule
{
    /**
     * Create a new rule instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Determine if the validation rule passes.
     *
     * @param  string  $attribute
     * @param  mixed  $value
     * @return bool
     */
    public function passes($attribute, $value)
    {
        $member = Member::where('email', $value)->get()->first();
        if($member == null)
            return true;

        return !$member->is_banned;
    }

    /**
     * Get the validation error message.
     *
     * @return string
     */
    public function message()
    {
        return 'Member has already banned.';
    }
}
