<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Messages\BroadcastMessage;

use App\Comment;
use App\Member;

class NewComment extends Notification implements ShouldQueue
{
    use Queueable;

    public $following;
    public $comment;
    public $type;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $following, Comment $comment)
    {
        $this->following = $following;
        $this->comment = $comment;
        if($this->comment->question->count() > 0){
            $this->type = 'Question';
        } else {
            $this->type = 'Answer';
        }
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

    public function toBroadcast($notifiable)
{
    return new BroadcastMessage([
        'id' => $this->id,
        'type' =>'Comment',
        'read_at' => null,
        'data' => [
            'following_id' => $this->following->id,
            'following_name' => $this->following->name,
            'following_username' => $this->following->username,
            'following_picture' => $this->following->profile_picture,
            'question_id' => ($this->type == 'Question'? $this->question->id : $this->answer->question->id ),
            'question_title' => ($this->type == 'Question'? $this->question->title : $this->answer->question->title ),
            'type' => $this->type,
            'answer_id' => ($this->type == 'Answer'? $this->answer->id : null ),
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
        'type' =>'Comment',
        'data' => [
            'following_id' => $this->following->id,
            'following_name' => $this->following->name,
            'following_username' => $this->following->username,
            'following_picture' => $this->following->profile_picture,
            'question_id' => ($this->type == 'Question'? $this->question->id : $this->answer->question->id ),
            'question_title' => ($this->type == 'Question'? $this->question->title : $this->answer->question->title ),
            'type' => $this->type,
            'answer_id' => ($this->type == 'Answer'? $this->answer->id : null ),
        ],
    ];
    }
}
