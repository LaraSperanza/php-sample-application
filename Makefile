install-dev: composer.phar
	./composer.phar install
	ln --symbolic --no-dereference --force config-dev config

composer.phar:
	wget https://getcomposer.org/composer.phar
	chmod u+x composer.phar

# Objetivo para construir la imagen de AWS
install-aws: composer.phar
	# 1. Instala dependencias de composer sin paquetes de desarrollo (buena práctica)
	./composer.phar install --no-dev
	# 2. (La clave) Crea el enlace simbólico 'config' apuntando a nuestra nueva carpeta 'config-aws'
	ln --symbolic --no-dereference --force config-aws config