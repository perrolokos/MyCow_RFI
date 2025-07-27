<?php
namespace App\Notifications;

use App\Models\Alert;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Messages\MailMessage;

class AnimalAlertNotification extends Notification
{
    use Queueable;

    public $alert;

    public function __construct(Alert $alert)
    {
        $this->alert = $alert;
    }

    public function via($notifiable)
    {
        return ['mail'];
    }

    public function toMail($notifiable)
    {
        return (new MailMessage)
            ->subject('Animal Alert')
            ->line($this->alert->message);
    }
}
