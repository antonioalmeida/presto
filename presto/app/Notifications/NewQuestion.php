<?php

namespace App\Notifications;

use App\Member;
use App\Question;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;

class NewQuestion extends Notification implements ShouldQueue
{
    use Queueable;

    public $following;
    public $question;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $following, Question $question)
    {
        $this->following = $following;
        $this->question = $question;
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
            'type' => 'Question',
            'read_at' => null,
            'data' => [
                'following_id' => $this->following->id,
                'following_name' => $this->following->name,
                'following_username' => $this->following->username,
                'following_picture' => $this->following->profile_picture,
                'question_id' => $this->question->id,
                'question_title' => $this->question->title,
                'url' => 'questions/' . $this->question->id,
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
            'type' => 'Question',
            'following_id' => $this->following->id,
            'following_name' => $this->following->name,
            'following_username' => $this->following->username,
            'following_picture' => $this->following->profile_picture,
            'question_id' => $this->question->id,
            'question_title' => $this->question->title,
            'url' => 'questions/' . $this->question->id,
        ];
    }
}
