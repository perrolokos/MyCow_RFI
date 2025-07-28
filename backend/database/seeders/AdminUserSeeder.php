<?php
namespace Database\Seeders;

use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder
{
    public function run()
    {
        User::create([
            'name' => 'Admin',
            'email' => 'admin@example.com',
            'password' => Hash::make('password'),
        ]);
    }
}
