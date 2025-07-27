<?php
// Placeholder entry file mimicking Laravel's public/index.php
// In a real setup this would bootstrap the Laravel framework via autoload.php.

header('Content-Type: application/json');

$requestUri = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

switch ("$method $requestUri") {
    case 'GET /api/health':
        echo json_encode(['status' => 'ok']);
        break;
    default:
        http_response_code(404);
        echo json_encode(['error' => 'Not Found']);
}

