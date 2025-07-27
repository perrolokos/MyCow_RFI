<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IotData extends Model
{
    protected $fillable = [
        'animal_id',
        'temperature',
        'activity',
        'recorded_at',
    ];

    public $timestamps = false;

    protected $casts = [
        'recorded_at' => 'datetime',
    ];

    public function animal()
    {
        return $this->belongsTo(Animal::class);
    }
}
