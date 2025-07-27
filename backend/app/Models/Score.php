<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Score extends Model
{
    protected $fillable = [
        'animal_id',
        'score_template_id',
        'values', // JSON field of raw values
        'total',
    ];

    protected $casts = [
        'values' => 'array',
    ];

    public function animal()
    {
        return $this->belongsTo(Animal::class);
    }

    public function template()
    {
        return $this->belongsTo(ScoreTemplate::class, 'score_template_id');
    }
}
