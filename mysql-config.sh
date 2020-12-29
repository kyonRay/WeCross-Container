# /bin/bash

mysql <<EOF
CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY 'admin123456';
GRANT ALL PRIVILEGES ON * . * TO 'root'@'127.0.0.1';
quit
EOF
service mysql restart