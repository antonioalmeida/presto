<?php

namespace App\Notifications;

use App\AnswerRating;
use App\Member;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;

class AnswerRated extends Notification implements ShouldQueue
{
    use Queueable;

    public $member;
    public $answer;
    public $rating;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $member, AnswerRating $rating)
    {
        $this->member = $member;
        $this->answer = $rating->answer;
        $this->rating = $rating;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['database', 'broadcast'];
    }

    public function toBroadcast($notifiable)
    {
        return new BroadcastMessage([
            'id' => $this->id,
            'type' => 'Rating',
            'read_at' => null,
            'data' => [
                'following_id' => $this->member->id,
                'following_name' => $this->member->name,
                'following_username' => $this->member->username,
                'following_picture' => $this->member->profile_picture,
                'question_id' => $this->answer->question->id,
                'answer_id' => $this->answer->id,
                'question_title' => $this->answer->question->title,
                'url' => 'questions/' . $this->answer->question->id
                    . '/answers/' . $this->answer->id,
                'rate' => $this->rating->rate,
            ],
        ]);
    }


    /**
     * Get the array representation of the notification.
     *
     * @param  mixed $notifiable
     * @return array
     */
    public function toArray($notifiable)
    {
        return [
            'type' => 'Rating',
            'following_id' => $this->member->id,
            'following_name' => $this->member->name,
            'following_username' => $this->member->username,
            'following_picture' => $this->member->profile_picture,
            'question_id' => $this->answer->question->id,
            'answer_id' => $this->answer->id,
            'question_title' => $this->answer->question->title,
            'url' => 'questions/' . $this->answer->question->id
                . '/answers/' . $this->answer->id,
            'rate' => $this->rating->rate,
        ];
    }
}
