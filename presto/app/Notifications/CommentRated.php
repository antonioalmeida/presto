<?php

namespace App\Notifications;

use App\Answer;
use App\Comment;
use App\CommentRating;
use App\Member;
use App\Question;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;

class CommentRated extends Notification implements ShouldQueue
{
    use Queueable;

    public $member;
    public $comment;
    public $rating;
    public $type;
    public $question;
    public $answer;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $member, CommentRating $rating)
    {
        $this->member = $member;
        $this->comment = Comment::find($rating->comment_id);
        $this->rating = $rating;
        if ($this->comment->question_id != null) {
            $this->type = 'Question';
            $this->question = Question::find($this->comment->question_id);
        } else {
            $this->type = 'Answer';
            $this->answer = Answer::find($this->comment->answer_id);
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
                'question_id' => ($this->type == 'Question' ? $this->question->id : $this->answer->question->id),
                'question_title' => ($this->type == 'Question' ? $this->question->title : $this->answer->question->title),
                'type_comment' => $this->type,
                'answer_id' => ($this->type == 'Answer' ? $this->answer->id : null),
                'url' => 'questions/' . ($this->type == 'Question' ? $this->question->id : $this->answer->question->id)
                    . ($this->type == 'Answer' ? '/answers/' . $this->answer->id : ''),
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
            'question_id' => ($this->type == 'Question' ? $this->question->id : $this->answer->question->id),
            'question_title' => ($this->type == 'Question' ? $this->question->title : $this->answer->question->title),
            'type_comment' => $this->type,
            'answer_id' => ($this->type == 'Answer' ? $this->answer->id : null),
            'url' => 'questions/' . ($this->type == 'Question' ? $this->question->id : $this->answer->question->id)
                . ($this->type == 'Answer' ? '/answers/' . $this->answer->id : ''),
            'rate' => $this->rating->rate,
        ];
    }
}
