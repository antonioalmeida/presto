<?php

namespace App\Notifications;

use App\Member;
use App\QuestionRating;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;

class QuestionRated extends Notification implements ShouldQueue
{
    use Queueable;

    public $member;
    public $question;
    public $rating;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $member, QuestionRating $rating)
    {
        $this->member = $member;
        $this->question = $rating->question;
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
                'question_id' => $this->question->id,
                'question_title' => $this->question->title,
                'url' => 'questions/' . $this->question->id,
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
            'question_id' => $this->question->id,
            'question_title' => $this->question->title,
            'url' => 'questions/' . $this->question->id,
            'rate' => $this->rating->rate,
        ];
    }
}
