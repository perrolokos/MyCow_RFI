<?php
namespace App\Jobs;

use App\Models\IotData;
use App\Models\Alert;
use App\Notifications\AnimalAlertNotification;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Notification;

class ProcessIotData implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $data;

    public function __construct(IotData $data)
    {
        $this->data = $data;
    }

    public function handle()
    {
        $alerts = [];
        if ($this->data->temperature > 39.5) {
            $alerts[] = 'Possible fever detected';
        }
        if ($this->data->activity > 80) {
            $alerts[] = 'Possible heat cycle detected';
        }
        foreach ($alerts as $message) {
            $alert = Alert::create([
                'animal_id' => $this->data->animal_id,
                'message' => $message,
            ]);
            Notification::route('mail', 'vet@example.com')
                ->notify(new AnimalAlertNotification($alert));
        }
    }
}
