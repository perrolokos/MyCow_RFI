<?php
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\API\AnimalController;
use App\Http\Controllers\API\ScoreController;
use App\Http\Controllers\API\IotDataController;
use App\Http\Controllers\API\AlertController;
use App\Http\Controllers\API\DashboardController;
use App\Http\Controllers\API\ReportController;

return [
    ['POST', '/register', [RegisterController::class, 'register']],
    ['POST', '/login', [LoginController::class, 'login']],
    ['POST', '/logout', [LoginController::class, 'logout']],
    // Animal resource routes
    ['GET', '/animals', [AnimalController::class, 'index']],
    ['POST', '/animals', [AnimalController::class, 'store']],
    ['GET', '/animals/{id}', [AnimalController::class, 'show']],
    ['PUT', '/animals/{id}', [AnimalController::class, 'update']],
    ['DELETE', '/animals/{id}', [AnimalController::class, 'destroy']],
    // Scoring routes
    ['GET', '/score-templates', [ScoreController::class, 'templates']],
    ['GET', '/animals/{id}/score', [ScoreController::class, 'show']],
    ['POST', '/animals/{id}/score', [ScoreController::class, 'store']],
    // IoT data ingestion
    ['POST', '/iot', [IotDataController::class, 'store']],
    // Alerts
    ['GET', '/alerts', [AlertController::class, 'index']],
    // Dashboard metrics
    ['GET', '/dashboard', [DashboardController::class, 'index']],
    // Reports
    ['POST', '/reports', [ReportController::class, 'store']],
];
