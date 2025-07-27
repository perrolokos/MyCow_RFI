<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Alert extends Model
{
    protected $fillable = [
        'animal_id',
        'message',
    ];

    public function animal()
    {
        return $this->belongsTo(Animal::class);
    }
}
