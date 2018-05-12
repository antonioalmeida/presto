<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Messages\BroadcastMessage;

use App\Answer;
use App\Member;

class NewAnswer extends Notification implements ShouldQueue
{
    use Queueable;

    public $following;
    public $answer;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $following, Answer $answer)
    {
        $this->following = $following;
        $this->answer = $answer;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
                return ['database', 'broadcast'];
                // return ['database'];
    }

    public function toBroadcast($notifiable)
{
    return new BroadcastMessage([
        'id' => $this->id,
        'type' =>'Answer',
        'read_at' => null,
        'data' => [
            'following_id' => $this->following->id,
            'following_name' => $this->following->name,
            'following_username' => $this->following->username,
            'following_picture' => $this->following->profile_picture,
            'question_id' => $this->answer->question->id,
            'answer_id' => $this->answer->id,
            'question_title' => $this->answer->question->title,
            'url' => 'questions/' . $this->answer->question->id 
            . '/answers/' . $this->answer->id,
        ],
    ]);
}


    /**
     * Get the array representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function toArray($notifiable)
    {
        return [
        'type' =>'Answer',
            'following_id' => $this->following->id,
            'following_name' => $this->following->name,
            'following_username' => $this->following->username,
            'following_picture' => $this->following->profile_picture,
            'question_id' => $this->answer->question->id,
            'answer_id' => $this->answer->id,
            'question_title' => $this->answer->question->title,
            'url' => 'questions/' . $this->answer->question->id 
            . '/answers/' . $this->answer->id,
    ];
    }
}
