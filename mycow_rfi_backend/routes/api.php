<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EjemplarController;
use App\Http\Controllers\ClasificacionController;
use App\Http\Controllers\ParametrosPorRazaController;
use App\Http\Controllers\ReporteController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    Route::apiResource('ejemplares', EjemplarController::class);
    Route::apiResource('clasificaciones', ClasificacionController::class);
    Route::get('/parametros-por-raza/{raza}', [ParametrosPorRazaController::class, 'show']);
    Route::get('/reportes/pdf/{ejemplarId}', [ReporteController::class, 'generatePdfReport']);
    Route::get('/reportes/qr/{ejemplarId}', [ReporteController::class, 'generateQrCode']);
    Route::get('/reportes/historial/{ejemplarId}', [ReporteController::class, 'getHistorialClasificaciones']);
});
