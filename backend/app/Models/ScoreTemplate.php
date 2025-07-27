<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ScoreTemplate extends Model
{
    protected $fillable = [
        'name',
        'weights', // JSON field storing criteria weights
    ];

    protected $casts = [
        'weights' => 'array',
    ];

    public function scores()
    {
        return $this->hasMany(Score::class);
    }
}
