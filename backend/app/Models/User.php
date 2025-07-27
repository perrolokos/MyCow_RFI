<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    // In real Laravel, use HasApiTokens, HasFactory, Notifiable traits
    protected $fillable = ['name', 'email', 'password'];
}
