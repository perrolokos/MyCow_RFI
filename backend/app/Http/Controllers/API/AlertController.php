<?php
namespace App\Http\Controllers\API;

use App\Models\Alert;

class AlertController
{
    public function index()
    {
        return Alert::latest()->take(20)->get();
    }
}
