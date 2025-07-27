<?php
namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Barryvdh\DomPDF\Facade\Pdf;

class GeneratePdfReport implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $data;
    public $path;

    public function __construct(array $data, $path)
    {
        $this->data = $data;
        $this->path = $path;
    }

    public function handle()
    {
        // In a real app, render a view and save to storage
        $pdf = Pdf::loadHtml('<h1>Report</h1>');
        file_put_contents($this->path, $pdf->output());
    }
}
