USER_NAME=$1
USER_SECRET=$2

if [ -z "$USER_NAME" ]
  then
    echo "error:  user name not provided"
fi

if [ -z "$USER_SECRET" ]
  then
    echo "error: user secret not provided"
fi

docker exec minio mc admin user add local $USER_NAME $USER_SECRET
docker exec minio mc admin policy attach local readwrite --user $USER_NAME 

