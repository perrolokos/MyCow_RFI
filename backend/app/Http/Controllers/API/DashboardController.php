<?php
namespace App\Http\Controllers\API;

use App\Models\Animal;
use App\Models\Alert;
use App\Models\Score;

class DashboardController
{
    public function index()
    {
        // Return simple aggregate metrics
        return [
            'animals' => Animal::count(),
            'alerts' => Alert::count(),
            'average_score' => Score::avg('value'),
        ];
    }
}
