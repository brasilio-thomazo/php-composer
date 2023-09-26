build:
	docker build -t devoptimus/php-cli --target php_cli .
	docker build -t devoptimus/php-composer --target php_composer .
	docker build -t devoptimus/php-fpm --target php_fpm .
test:
	docker run --rm --name php-fpm-test -p 0:9000/tcp devoptimus/php-fpm