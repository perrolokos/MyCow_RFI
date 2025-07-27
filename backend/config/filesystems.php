<?php
// Simplified filesystem configuration
return [
    'default' => 'local',
    'disks' => [
        'local' => [
            'driver' => 'local',
            'root' => storage_path('app'),
        ],
        'animals' => [
            'driver' => 'local',
            'root' => storage_path('app/public/animals'),
            'url' => env('APP_URL').'/storage/animals',
            'visibility' => 'public',
        ],
    ],
];
