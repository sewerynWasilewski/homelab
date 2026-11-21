source .env

docker exec minio mc alias set local http://localhost:9000 ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}
docker exec minio mc mb local/tfstate
docker exec minio mc mc version enable local/tfstate
