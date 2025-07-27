<?php
namespace App\Http\Controllers\API;

use App\Jobs\GeneratePdfReport;
use Illuminate\Support\Str;

class ReportController
{
    public function store()
    {
        $path = storage_path('app/reports/'.Str::uuid().'.pdf');
        GeneratePdfReport::dispatch([], $path);
        return ['status' => 'queued'];
    }
}
