<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Observers\QuestionObserver;
use App\Question;
use App\Observers\AnswerObserver;
use App\Answer;
use App\Observers\CommentObserver;
use App\Comment;

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
        Answer::observe(AnswerObserver::class);
        Comment::observe(CommentObserver::class);
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
