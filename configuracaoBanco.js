const credenciais = {
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    database: process.env.DB_NAME || 'cleenkr',
    password: process.env.DB_PASSWORD || '48344834',
    port: process.env.DB_PORT || 5432,
};
module.exports = credenciais;