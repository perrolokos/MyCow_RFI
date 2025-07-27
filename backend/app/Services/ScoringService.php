<?php
namespace App\Services;

use App\Models\ScoreTemplate;

class ScoringService
{
    public function calculate(ScoreTemplate $template, array $values): float
    {
        $weights = $template->weights ?: [];
        $totalWeight = array_sum($weights);
        if ($totalWeight == 0) return 0;
        $sum = 0;
        foreach ($weights as $key => $weight) {
            $value = $values[$key] ?? 0;
            $sum += $value * $weight;
        }
        return $sum / $totalWeight;
    }
}
