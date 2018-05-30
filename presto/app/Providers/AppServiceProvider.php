<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Http\Resources\Json\Resource;
use App\Observers\QuestionObserver;
use App\Question;
use App\Observers\AnswerObserver;
use App\Answer;
use App\Observers\CommentObserver;
use App\Comment;
use App\Observers\AnswerRatingObserver;
use App\AnswerRating;
use App\Observers\CommentRatingObserver;
use App\CommentRating;
use App\Observers\QuestionRatingObserver;
use App\QuestionRating;
use App\Observers\MemberObserver;
use App\Member;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        // Removes top-level 'data' attribute
        // from JSON responses
        Resource::withoutWrapping();
        Question::observe(QuestionObserver::class);
        Answer::observe(AnswerObserver::class);
        Comment::observe(CommentObserver::class);
        AnswerRating::observe(AnswerRatingObserver::class);
        QuestionRating::observe(QuestionRatingObserver::class);
        CommentRating::observe(CommentRatingObserver::class);
        Member::observe(MemberObserver::class);

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
