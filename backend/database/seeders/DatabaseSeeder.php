<?php
namespace Database\Seeders;

class DatabaseSeeder
{
    public function run()
    {
        (new RoleSeeder)->run();
        (new ScoreTemplateSeeder)->run();
        (new AdminUserSeeder)->run();
    }
}
