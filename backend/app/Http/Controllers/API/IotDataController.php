<?php
namespace App\Http\Controllers\API;

use App\Models\IotData;
use App\Jobs\ProcessIotData;

class IotDataController
{
    public function store()
    {
        $data = json_decode(file_get_contents('php://input'), true) ?? [];
        $iot = IotData::create([
            'animal_id' => $data['animal_id'] ?? null,
            'temperature' => $data['temperature'] ?? null,
            'activity' => $data['activity'] ?? null,
            'recorded_at' => $data['recorded_at'] ?? date('c'),
        ]);
        ProcessIotData::dispatch($iot);
        return ['status' => 'queued'];
    }
}
