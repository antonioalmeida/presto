<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Pusher\Pusher;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth')->except(['index', 'about', 'error']);
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('pages.index');
    }

    public function search(){

        return view('pages.search');
    }

    public function about(){

        return view('pages.about');
    }

    public function error(){

        return view('pages.404');
    }

    public function cenas(){

        return view('cenas');
    }

    public function sendNotification()
    {
        $options = array(
            'cluster' => 'eu',
            'encrypted' => true
          );
          $pusher = new Pusher(
            'b9238648fe8769320bdf',
            'db38c5e095b16b7fe027',
            '516724',
            $options
          );

          $data['message'] = 'hello world';
          $pusher->trigger('my-channel', 'my-event', $data);
            
    }

}
