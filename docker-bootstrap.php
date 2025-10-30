<?php

// Guarda esto como docker-bootstrap.php

// 1. Cargar el autoloader de Composer (LA LÍNEA QUE FALTABA)
require "vendor/autoload.php";

// 2. Cargar el autoloader de la aplicación
require "autoloader.php";

// 3. Cargar el gestor de errores
require "error_handler.php";