<?php

namespace App\Policies;

use App\Member;
use App\Card;
use App\Item;

use Illuminate\Auth\Access\HandlesAuthorization;

class ItemPolicy
{
    use HandlesAuthorization;

    public function create(Member $user, Item $item)
    {
      // User can only create items in cards they own
      return $user->id == $item->card->user_id;
    }

    public function update(Member $user, Item $item)
    {
      // User can only update items in cards they own
      return $user->id == $item->card->user_id;
    }

    public function delete(Member $user, Item $item)
    {
      // User can only delete items in cards they own
      return $user->id == $item->card->user_id;
    }
}
