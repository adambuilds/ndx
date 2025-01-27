<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LaborType extends Model
{
    // Specify the table name
    protected $table = 'LaborTypes';

    // Optionally, specify the primary key if it's not the default 'id'
    protected $primaryKey = 'idStatusCodes';

    // If the table does not have the default timestamp columns
    public $timestamps = false;
}
