<?php

namespace App\Notifications;

use App\Member;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;

class MemberMention extends Notification implements ShouldQueue
{
    use Queueable;

    public $follower;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Member $follower)
    {
        $this->follower = $follower;
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
                'url' => 'profile/' . $this->follower->username, //TODO: switch url to comment
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
            'url' => 'profile/' . $this->follower->username,
        ];
    }

}
