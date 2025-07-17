<?php

namespace App\Http\Controllers;

use App\Models\Ejemplar;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class EjemplarController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $ejemplares = Ejemplar::all();
        return response()->json($ejemplares);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'codigo_arete' => 'required|string|unique:ejemplares',
            'foto' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'nombre' => 'required|string',
            'fecha_nacimiento' => 'required|date',
            'raza' => 'required|string',
        ]);

        $ejemplar = new Ejemplar($request->except('foto'));

        if ($request->hasFile('foto')) {
            $path = $request->file('foto')->store('ejemplares_fotos', 'public');
            $ejemplar->foto = $path;
        }

        $ejemplar->save();

        return response()->json($ejemplar, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $ejemplar = Ejemplar::findOrFail($id);
        return response()->json($ejemplar);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $ejemplar = Ejemplar::findOrFail($id);

        $request->validate([
            'codigo_arete' => 'required|string|unique:ejemplares,codigo_arete,' . $id,
            'foto' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'nombre' => 'required|string',
            'fecha_nacimiento' => 'required|date',
            'raza' => 'required|string',
        ]);

        $ejemplar->fill($request->except('foto'));

        if ($request->hasFile('foto')) {
            // Eliminar la foto anterior si existe
            if ($ejemplar->foto) {
                Storage::disk('public')->delete($ejemplar->foto);
            }
            $path = $request->file('foto')->store('ejemplares_fotos', 'public');
            $ejemplar->foto = $path;
        }

        $ejemplar->save();

        return response()->json($ejemplar);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $ejemplar = Ejemplar::findOrFail($id);

        if ($ejemplar->foto) {
            Storage::disk('public')->delete($ejemplar->foto);
        }

        $ejemplar->delete();

        return response()->json(null, 204);
    }
}
