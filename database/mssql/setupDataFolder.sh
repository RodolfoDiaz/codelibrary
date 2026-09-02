export DB_FOLDER=./dbdata

sudo rm -rf ${DB_FOLDER}
sudo mkdir ${DB_FOLDER} ${DB_FOLDER}/sqldata ${DB_FOLDER}/sqllog ${DB_FOLDER}/secrets ${DB_FOLDER}/sqlbackup
# Modern versions of SQL Server run as a non-root user (mssql, UID 10001) by default to minimize host security
sudo chown -R 10001:0 ${DB_FOLDER}
