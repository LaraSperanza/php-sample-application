<?php

return new Service\TweetsService(
    require "config-aws/db-connection.php"
);
