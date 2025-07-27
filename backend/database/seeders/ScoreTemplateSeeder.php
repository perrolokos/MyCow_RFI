<?php
namespace Database\Seeders;

use App\Models\ScoreTemplate;

class ScoreTemplateSeeder
{
    public function run()
    {
        $weights = [
            // Sistema Mamario (40%) -> weight ~4.44 each
            1 => 4.44,
            2 => 4.44,
            3 => 4.44,
            4 => 4.44,
            5 => 4.44,
            6 => 4.44,
            7 => 4.44,
            8 => 4.44,
            9 => 4.44,
            // Fuerza Lechera (20%) -> 10 each
            10 => 10.0,
            11 => 10.0,
            // Patas y Pezuñas (20%) -> 4 each
            12 => 4.0,
            13 => 4.0,
            14 => 4.0,
            15 => 4.0,
            16 => 4.0,
            // Tren Anterior (15%) -> 5 each
            17 => 5.0,
            18 => 5.0,
            19 => 5.0,
            // Grupa (5%) -> 2.5 each
            20 => 2.5,
            21 => 2.5,
        ];

        foreach (['Brown Swiss', 'Holstein', 'Jersey'] as $breed) {
            ScoreTemplate::create([
                'name' => $breed,
                'weights' => $weights,
            ]);
        }
    }
}
