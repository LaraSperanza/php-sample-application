<?php

// Guarda esto como docker-db-connection.php

// Usamos 'db' como host, porque así se llama el servicio
// en nuestro docker-compose.yml
return new PDO("mysql:host=db;dbname=sample", "sampleuser", "samplepass", [PDO::ATTR_PERSISTENT => true]);