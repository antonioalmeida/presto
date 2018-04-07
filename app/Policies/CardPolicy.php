<?php

namespace App\Policies;

use App\Member;
use App\Card;

use Illuminate\Auth\Access\HandlesAuthorization;
use Illuminate\Support\Facades\Auth;

class CardPolicy
{
    use HandlesAuthorization;

    public function show(Member $user, Card $card)
    {
      // Only a card owner can see it
      return $user->id == $card->user_id;
    }

    public function list(Member $user)
    {
      // Any user can list its own cards
      return Auth::check();
    }

    public function create(Member $user)
    {
      // Any user can create a new card
      return Auth::check();
    }

    public function delete(Member $user, Card $card)
    {
      // Only a card owner can delete it
      return $user->id == $card->user_id;
    }
}
