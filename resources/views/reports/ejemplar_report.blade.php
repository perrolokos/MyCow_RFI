<!DOCTYPE html>
<html>
<head>
    <title>Reporte de Ejemplar</title>
    <style>
        body {
            font-family: sans-serif;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .header h1 {
            margin: 0;
        }
        .section-title {
            margin-top: 20px;
            margin-bottom: 10px;
            font-size: 1.2em;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Reporte de Ejemplar Bovino</h1>
        <h2>{{ $ejemplar->nombre }} ({{ $ejemplar->codigo_arete }})</h2>
    </div>

    <div class="section-title">Información del Ejemplar</div>
    <table>
        <tr>
            <th>Código de Arete</th>
            <td>{{ $ejemplar->codigo_arete }}</td>
        </tr>
        <tr>
            <th>Nombre</th>
            <td>{{ $ejemplar->nombre }}</td>
        </tr>
        <tr>
            <th>Raza</th>
            <td>{{ $ejemplar->raza }}</td>
        </tr>
        <tr>
            <th>Fecha de Nacimiento</th>
            <td>{{ \Carbon\Carbon::parse($ejemplar->fecha_nacimiento)->format('d/m/Y') }}</td>
        </tr>
        @if($ejemplar->foto)
        <tr>
            <th>Foto</th>
            <td><img src="{{ public_path('storage/' . $ejemplar->foto) }}" width="150"></td>
        </tr>
        @endif
    </table>

    <div class="section-title">Historial de Clasificaciones</div>
    @if($ejemplar->clasificaciones->isEmpty())
        <p>No hay clasificaciones registradas para este ejemplar.</p>
    @else
        <table>
            <thead>
                <tr>
                    <th>Fecha de Clasificación</th>
                    <th>Puntaje Final</th>
                    <th>Detalles de Clasificación</th>
                </tr>
            </thead>
            <tbody>
                @foreach($ejemplar->clasificaciones as $clasificacion)
                <tr>
                    <td>{{ \Carbon\Carbon::parse($clasificacion->fecha_clasificacion)->format('d/m/Y') }}</td>
                    <td>{{ number_format($clasificacion->puntaje_final, 2) }}</td>
                    <td>
                        <ul>
                            @foreach($clasificacion->datos_clasificacion as $key => $value)
                                <li><strong>{{ $key }}:</strong> {{ $value }}</li>
                            @endforeach
                        </ul>
                    </td>
                </tr>
                @endforeach
            </tbody>
        </table>
    @endif
</body>
</html>
