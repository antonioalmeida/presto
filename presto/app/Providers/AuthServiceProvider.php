<?php

namespace App\Providers;

use App\Answer;
use App\Comment;
use App\Member;
use App\Policies\AnswerPolicy;
use App\Policies\CommentPolicy;
use App\Policies\MemberPolicy;
use App\Policies\QuestionPolicy;
use App\Question;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The policy mappings for the application.
     *
     * @var array
     */
    protected $policies = [
        Member::class => MemberPolicy::class,
        Question::class => QuestionPolicy::class,
        Answer::class => AnswerPolicy::class,
        Comment::class => CommentPolicy::class,
    ];

    /**
     * Register any authentication / authorization services.
     *
     * @return void
     */
    public function boot()
    {
        $this->registerPolicies();
    }
}
