<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Member;
use App\Rules\BannedMember;
use Auth;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Socialite;

class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    public function redirectToProvider($provider)
    {
        return Socialite::driver($provider)->redirect()->getTargetUrl();
    }

    public function handleProviderCallback($provider)
    {
        $user = Socialite::driver($provider)->user();

        $authUser = $this->findOrCreateUser($user, $provider);
        Auth::login($authUser, true);

        return redirect($this->redirectTo);
    }

    public function findOrCreateUser($user, $provider)
    {
        $authUser = Member::where('provider_id', $user->id)->first();
        if ($authUser) {
            return $authUser;
        }
        return Member::create([
            'username' => $user->name,
            'email' => $user->email,
            'provider' => $provider,
            'provider_id' => $user->id,
            'profile_picture' => 'https://dummyimage.com/250/11214b/ffffff.png&text=' . $user->email
        ]);
    }

    protected function validateLogin($request)
    {
        $this->validate($request, [
            $this->username() => ['required','string', new BannedMember],
            'password' => 'required|string',
        ]);
    }
}
