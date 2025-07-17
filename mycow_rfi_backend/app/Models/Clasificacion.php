<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Clasificacion extends Model
{
    protected $table = 'clasificaciones';

    protected $fillable = [
        'ejemplar_id',
        'fecha_clasificacion',
        'puntaje_final',
        'datos_clasificacion',
    ];

    protected $casts = [
        'datos_clasificacion' => 'array',
        'fecha_clasificacion' => 'date',
    ];

    public function ejemplar(): BelongsTo
    {
        return $this->belongsTo(Ejemplar::class);
    }
}
