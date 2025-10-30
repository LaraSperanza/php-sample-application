<?php

// Guarda esto como config-aws/db-connection.php

// 1. Lee las variables de entorno inyectadas por ECS desde Parameter Store.
// (Usaremos los nombres de parámetro que ya creaste, pero sin el prefijo /app/)
$db_host = getenv('DB_HOST');
$db_name = getenv('DB_NAME');
$db_user = getenv('DB_USER');
$db_pass = getenv('DB_PASS');

// 2. Verificación de que las variables existen
if (empty($db_host) || empty($db_name) || empty($db_user) || empty($db_pass)) {
    // Si faltan, la app fallará y los logs de ECS mostrarán este error.
    error_log("Error: Faltan variables de entorno para la conexión a la DB.");
    // Detiene la ejecución si la conexión no es posible.
    header($_SERVER["SERVER_PROTOCOL"] . " 500 Internal Server Error", true, 500);
    exit("Error de configuración de la base de datos.");
}

// 3. Retorna el objeto PDO para la conexión.
// Los archivos dic/users.php y dic/tweets.php no necesitan cambios,
// ya que ellos simplemente hacen un 'require' de este archivo.
return new PDO(
    "mysql:host={$db_host};dbname={$db_name}",
    $db_user,
    $db_pass,
    [PDO::ATTR_PERSISTENT => true]
);
?>