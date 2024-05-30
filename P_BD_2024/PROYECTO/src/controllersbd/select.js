const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'Proyecto_Ron_2023_2024',
    password: 'joseluis0699',
    port: 5432,
});