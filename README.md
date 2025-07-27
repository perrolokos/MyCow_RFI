# MyCows_RFI

This repository bootstraps the initial architecture for the **MyCows_RFI** project. Due to the restricted environment the actual Laravel and Node dependencies are not installed, however the configuration files are provided so that the project can be set up locally.

## Contents

- **backend/** – Laravel backend placeholder with a `docker-compose.yml` ready for [Laravel Sail](https://laravel.com/docs/sail). Copy `.env.example` to `.env` and run `composer create-project` inside this folder to install Laravel.
- **frontend/** – React application scaffolded for Vite. After installing Node dependencies (`npm install`), run `npm run dev` to launch the frontend.
- **.gitignore** – Common ignores for Laravel and Node projects.

The aim of this sprint is to provide the basic structure required to start development once dependencies can be installed.

Sprint 1 introduces skeleton code for user authentication. The backend now contains models, migrations and route stubs for registering and logging in users with Laravel Sanctum, while the frontend provides a basic login form and a protected area.

Sprint 2 adds the core CRUD features for managing animals. An `Animal` model with a migration and API resource controller is included along with filesystem configuration for storing animal images. The React app now offers components to list, create and view animals.

Sprint 3 introduces a basic scoring system. Two new models, `ScoreTemplate` and `Score`, allow defining weighted templates and storing computed values for animals. A `ScoringService` performs the weighted average calculation, and API endpoints expose the ability to fetch or assign scores. The frontend now displays the last score for an animal and provides a simple form to submit new scores.
Default templates for the Brown Swiss, Holstein and Jersey breeds are seeded via `ScoreTemplateSeeder`. Each template distributes weights according to the official scoring scheme so that scores can be calculated consistently across breeds.
The `/api/score-templates` endpoint lists these templates so the frontend can present them in a dropdown.

Sprint 4 integrates IoT data processing. An endpoint accepts sensor readings which are queued to a `ProcessIotData` job. The job detects fever or heat cycles and dispatches notifications. Alerts can be fetched from the API and the frontend renders a simple trend graph with recent alert messages.

Sprint 5 consolidates the collected data. A new dashboard endpoint provides KPI metrics and a `GeneratePdfReport` job produces PDF reports using `laravel-dompdf`. React components render the dashboard and trigger background report generation.
