<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Messages\BroadcastMessage;

use App\Comment;
use App\Question;
use App\Answer;
use App\Member;

class NewComment extends Notification implements ShouldQueue
{
    use Queueable;

    public $following;
    public $comment;
    public $type;
    public $question;
    public $answer;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $following, Comment $comment)
    {
        $this->following = $following;
        $this->comment = $comment;
        if($this->comment->question_id != null){
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
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
            //    return ['database', 'broadcast'];
               return ['database'];
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
            'type_comment' => $this->type,
            'answer_id' => ($this->type == 'Answer'? $this->answer->id : null ),
            'url' => 'questions/' . ($this->type == 'Question'? $this->question->id : $this->answer->question->id ) 
            . ($this->type == 'Answer' ? '/answers/' . $this->answer->id : '' ),

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
            'following_id' => $this->following->id,
            'following_name' => $this->following->name,
            'following_username' => $this->following->username,
            'following_picture' => $this->following->profile_picture,
            'question_id' => ($this->type == 'Question'? $this->question->id : $this->answer->question->id ),
            'question_title' => ($this->type == 'Question'? $this->question->title : $this->answer->question->title ),
            'type_comment' => $this->type,
            'answer_id' => ($this->type == 'Answer'? $this->answer->id : null ),
            'url' => 'questions/' . ($this->type == 'Question'? $this->question->id : $this->answer->question->id ) 
            . ($this->type == 'Answer' ? '/answers/' . $this->answer->id : '' ),
    ];
    }
}
