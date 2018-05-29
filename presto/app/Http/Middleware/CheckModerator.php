<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;
use App\Member;
use App\ResponseUtil;
use Response;

class CheckModerator
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        $member = Auth::user();
        if(!$member->is_moderator) {
          return redirect('404');
        }

        return $next($request);
    }
}
