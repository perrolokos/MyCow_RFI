<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Ejemplar extends Model
{
    protected $table = 'ejemplares';

    protected $fillable = [
        'codigo_arete',
        'foto',
        'nombre',
        'fecha_nacimiento',
        'raza',
    ];

    public function clasificaciones(): HasMany
    {
        return $this->hasMany(Clasificacion::class);
    }
}
