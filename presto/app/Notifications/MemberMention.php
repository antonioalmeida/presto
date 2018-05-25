<?php

namespace App\Notifications;

use App\Member;
use App\Comment;
use App\Question;
use App\Answer;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;

class MemberMention extends Notification implements ShouldQueue
{
    use Queueable;

    public $follower;
    public $type;
    public $question;
    public $answer;
    public $comment;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $follower, Comment $comment)
    {
        $this->follower = $follower;
        $this->comment = $comment;
        if ($this->comment->question_id != null) {
            $this->type = 'Question';
            $this->question = Question::find($comment->question_id);
        } else {
            $this->type = 'Answer';
            $this->answer = Answer::find($comment->answer_id);
        }
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
        // return ['database'];
    }

    public function toBroadcast($notifiable)
    {
        return new BroadcastMessage([
            'id' => $this->id,
            'type' => 'Mention',
            'read_at' => null,
            'data' => [
                'follower_id' => $this->follower->id,
                'follower_name' => $this->follower->name,
                'follower_username' => $this->follower->username,
                'follower_picture' => $this->follower->profile_picture,
                'type_comment' => $this->type,
                'question_title' => ($this->type == 'Question' ? $this->question->title : $this->answer->question->title),
                'url' => 'questions/' . ($this->type == 'Question' ? $this->question->id : $this->answer->question->id)
                    . ($this->type == 'Answer' ? '/answers/' . $this->answer->id : '')
            ],
        ]);
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param  mixed $notifiable
     * @return \Illuminate\Notifications\Messages\MailMessage
     */
    public function toArray($notifiable)
    {
        return [
            'type' => 'Mention',
            'follower_id' => $this->follower->id,
            'follower_name' => $this->follower->name,
            'follower_username' => $this->follower->username,
            'follower_picture' => $this->follower->profile_picture,
            'type_comment' => $this->type,
            'question_title' => ($this->type == 'Question' ? $this->question->title : $this->answer->question->title),
            'url' => 'questions/' . ($this->type == 'Question' ? $this->question->id : $this->answer->question->id)
                . ($this->type == 'Answer' ? '/answers/' . $this->answer->id : '')
        ];
    }

}
