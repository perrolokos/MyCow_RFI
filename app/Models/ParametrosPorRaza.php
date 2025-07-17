<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ParametrosPorRaza extends Model
{
    protected $table = 'parametros_por_raza';

    protected $fillable = [
        'raza',
        'parametros',
    ];

    protected $casts = [
        'parametros' => 'array',
    ];
}
