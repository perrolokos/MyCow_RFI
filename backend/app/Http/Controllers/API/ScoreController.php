<?php
namespace App\Http\Controllers\API;

use App\Models\Animal;
use App\Models\ScoreTemplate;
use App\Models\Score;
use App\Services\ScoringService;

class ScoreController
{
    protected $service;

    public function __construct()
    {
        $this->service = new ScoringService();
    }

    /**
     * List available score templates.
     */
    public function templates()
    {
        return ScoreTemplate::all();
    }

    public function show($animalId)
    {
        // Return last score for the animal
        return Score::where('animal_id', $animalId)->latest()->first();
    }

    public function store($animalId)
    {
        $data = json_decode(file_get_contents('php://input'), true) ?? [];
        $templateId = $data['template_id'] ?? null;
        $values = $data['values'] ?? [];
        $template = ScoreTemplate::find($templateId);
        if (!$template) {
            http_response_code(404);
            return ['error' => 'Template not found'];
        }
        $total = $this->service->calculate($template, $values);
        $score = Score::create([
            'animal_id' => $animalId,
            'score_template_id' => $templateId,
            'values' => $values,
            'total' => $total,
        ]);
        return $score;
    }
}
