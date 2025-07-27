<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Animal extends Model
{
    // Basic fields for the animal
    protected $fillable = [
        'tag',
        'breed',
        'birth_date',
        'genetics',
        'image_path',
    ];
}
