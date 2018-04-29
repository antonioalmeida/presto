<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Observers\QuestionObserver;
use App\Question;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Question::observe(QuestionObserver::class);
        //
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
}
