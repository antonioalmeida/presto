<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;

use App\Question;
use App\Member;

class NewQuestion extends Notification implements ShouldQueue
{
    use Queueable;

    protected $following;
    protected $question;

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
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['database', 'broadcast'];
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
            'following_id' => $this->following->id,
            'following_name' => $this->following->name,
            'question_id' => $this->question->id,
        ];
    }
}
