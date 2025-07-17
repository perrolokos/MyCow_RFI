<?php

namespace App\Http\Controllers;

use App\Models\Clasificacion;
use App\Models\Ejemplar;
use App\Models\ParametrosPorRaza;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ClasificacionController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $ejemplarId = $request->query('ejemplar_id');

        if ($ejemplarId) {
            $clasificaciones = Clasificacion::where('ejemplar_id', $ejemplarId)->get();
        } else {
            $clasificaciones = Clasificacion::all();
        }

        return response()->json($clasificaciones);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'ejemplar_id' => 'required|exists:ejemplares,id',
            'fecha_clasificacion' => 'required|date',
            'datos_clasificacion' => 'required|array',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $ejemplar = Ejemplar::findOrFail($request->ejemplar_id);
        $parametrosRaza = ParametrosPorRaza::where('raza', $ejemplar->raza)->first();

        if (!$parametrosRaza) {
            return response()->json(['message' => 'Parámetros de clasificación no encontrados para esta raza.'], 404);
        }

        // Lógica de validación en tiempo real y cálculo de puntaje final
        $puntajeFinal = $this->calculateFinalScore(
            $request->datos_clasificacion,
            $parametrosRaza->parametros
        );

        $clasificacion = Clasificacion::create([
            'ejemplar_id' => $request->ejemplar_id,
            'fecha_clasificacion' => $request->fecha_clasificacion,
            'datos_clasificacion' => $request->datos_clasificacion,
            'puntaje_final' => $puntajeFinal,
        ]);

        return response()->json($clasificacion, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $clasificacion = Clasificacion::findOrFail($id);
        return response()->json($clasificacion);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $clasificacion = Clasificacion::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'ejemplar_id' => 'required|exists:ejemplares,id',
            'fecha_clasificacion' => 'required|date',
            'datos_clasificacion' => 'required|array',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $ejemplar = Ejemplar::findOrFail($request->ejemplar_id);
        $parametrosRaza = ParametrosPorRaza::where('raza', $ejemplar->raza)->first();

        if (!$parametrosRaza) {
            return response()->json(['message' => 'Parámetros de clasificación no encontrados para esta raza.'], 404);
        }

        $puntajeFinal = $this->calculateFinalScore(
            $request->datos_clasificacion,
            $parametrosRaza->parametros
        );

        $clasificacion->update([
            'ejemplar_id' => $request->ejemplar_id,
            'fecha_clasificacion' => $request->fecha_clasificacion,
            'datos_clasificacion' => $request->datos_clasificacion,
            'puntaje_final' => $puntajeFinal,
        ]);

        return response()->json($clasificacion);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $clasificacion = Clasificacion::findOrFail($id);
        $clasificacion->delete();

        return response()->json(null, 204);
    }

    /**
     * Calculate the final score based on classification data and breed parameters.
     *
     * @param array $datosClasificacion
     * @param array $parametrosRaza
     * @return float
     */
    private function calculateFinalScore(array $datosClasificacion, array $parametrosRaza): float
    {
        $totalScore = 0;
        $totalWeight = 0;

        foreach ($parametrosRaza['categorias'] as $categoria) {
            $categoryName = $categoria['nombre'];
            $categoryWeight = $categoria['peso'];

            if (isset($datosClasificacion[$categoryName])) {
                $score = $datosClasificacion[$categoryName];
                // Aquí puedes añadir lógica de validación de rangos si es necesario
                // Por ejemplo, si el score debe estar entre 1 y 100
                $totalScore += ($score * $categoryWeight);
                $totalWeight += $categoryWeight;
            }
        }

        return $totalWeight > 0 ? $totalScore / $totalWeight : 0;
    }
}
