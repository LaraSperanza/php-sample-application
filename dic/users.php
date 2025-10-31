<?php

return new Service\UsersService(
    require "config-aws/db-connection.php"
);
