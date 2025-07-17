<?php

namespace App\Http\Controllers;

use App\Models\Ejemplar;
use App\Models\Clasificacion;
use Illuminate\Http\Request;
use PDF;
use SimpleSoftwareIO\QrCode\Facades\QrCode;

class ReporteController extends Controller
{
    public function generatePdfReport(string $ejemplarId)
    {
        $ejemplar = Ejemplar::with('clasificaciones')->findOrFail($ejemplarId);

        $data = [
            'ejemplar' => $ejemplar,
        ];

        $pdf = PDF::loadView('reports.ejemplar_report', $data);

        return $pdf->download('reporte_' . $ejemplar->codigo_arete . '.pdf');
    }

    public function generateQrCode(string $ejemplarId)
    {
        $ejemplar = Ejemplar::findOrFail($ejemplarId);
        $qrCode = QrCode::size(300)->generate(json_encode([
            'id' => $ejemplar->id,
            'codigo_arete' => $ejemplar->codigo_arete,
            'nombre' => $ejemplar->nombre,
        ]));

        return response($qrCode)->header('Content-Type', 'image/png');
    }

    public function getHistorialClasificaciones(string $ejemplarId)
    {
        $ejemplar = Ejemplar::findOrFail($ejemplarId);
        $clasificaciones = $ejemplar->clasificaciones()->orderBy('fecha_clasificacion', 'desc')->get();

        return response()->json($clasificaciones);
    }
}
