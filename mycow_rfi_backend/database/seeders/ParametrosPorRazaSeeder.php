<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\ParametrosPorRaza;

class ParametrosPorRazaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        ParametrosPorRaza::create([
            'raza' => 'Holstein',
            'parametros' => [
                'categorias' => [
                    ['nombre' => 'Sistema Mamario', 'peso' => 40],
                    ['nombre' => 'Fuerza Lechera', 'peso' => 20],
                    ['nombre' => 'Patas y Pezuñas', 'peso' => 20],
                    ['nombre' => 'Estructura Corporal', 'peso' => 20],
                ],
            ],
        ]);

        ParametrosPorRaza::create([
            'raza' => 'Jersey',
            'parametros' => [
                'categorias' => [
                    ['nombre' => 'Sistema Mamario', 'peso' => 35],
                    ['nombre' => 'Capacidad Lechera', 'peso' => 25],
                    ['nombre' => 'Patas y Pezuñas', 'peso' => 20],
                    ['nombre' => 'Carácter de Raza', 'peso' => 20],
                ],
            ],
        ]);

        ParametrosPorRaza::create([
            'raza' => 'Brown Swiss',
            'parametros' => [
                'categorias' => [
                    ['nombre' => 'Sistema Mamario', 'peso' => 35],
                    ['nombre' => 'Capacidad Lechera', 'peso' => 25],
                    ['nombre' => 'Patas y Pezuñas', 'peso' => 20],
                    ['nombre' => 'Carácter de Raza', 'peso' => 20],
                ],
            ],
        ]);
    }
}
