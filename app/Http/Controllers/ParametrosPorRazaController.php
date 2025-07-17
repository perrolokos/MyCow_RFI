<?php

namespace App\Http\Controllers;

use App\Models\ParametrosPorRaza;
use Illuminate\Http\Request;

class ParametrosPorRazaController extends Controller
{
    /**
     * Display the specified resource.
     */
    public function show(string $raza)
    {
        $parametros = ParametrosPorRaza::where('raza', $raza)->first();

        if (!$parametros) {
            return response()->json(['message' => 'Parámetros no encontrados para la raza especificada.'], 404);
        }

        return response()->json($parametros);
    }
}
