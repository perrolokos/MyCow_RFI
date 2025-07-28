# Backend Setup

This directory is intended to host the Laravel backend for **MyCows_RFI**. Due to the environment lacking network access, the actual Laravel framework is not installed. Instead, the configuration files required for Laravel Sail and environment variables are included so that the project can be set up locally with Docker.

## Quick start (outside Codex)
1. Install [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/).
2. Clone this repository.
3. Run `composer create-project laravel/laravel .` within this `backend` folder to install Laravel.
4. Copy `.env.example` to `.env` and adjust credentials if necessary.
5. Run `./vendor/bin/sail up -d` to start the development environment.
6. Execute the migrations and seeders:

   ```bash
   ./vendor/bin/sail artisan migrate --seed
   ```

   This seeds an admin user with email `admin@example.com` and password `password`.

The provided `docker-compose.yml` mirrors the default services offered by Laravel Sail: an app container, PostgreSQL, Redis and Mailpit.

### Authentication Stub
This sprint also includes placeholder models and migrations for Sanctum-based authentication and role management using `spatie/laravel-permission`. When Laravel is installed, run the migrations and a seeder to create the base roles.

### Scoring Templates
Run the `ScoreTemplateSeeder` to load default scoring templates for the Brown Swiss, Holstein and Jersey breeds. These templates define the weight distribution used by the `ScoringService`.
The `/api/score-templates` endpoint exposes these templates for the frontend.

### Reports
The backend requires `barryvdh/laravel-dompdf` (declared in `composer.json`) to generate PDF reports. The `GeneratePdfReport` job saves reports under `storage/app/reports` when dispatched by the `/api/reports` endpoint.
