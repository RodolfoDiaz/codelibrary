# https://medium.com/faun/useful-docker-commands-and-aliases-9ea79191832f
# Update all docker images
docker images | awk '!/REPOSITORY/ {print $1}' | xargs -L1 docker pull
echo "Show all the dangling images (untagged images)"
docker images -f "dangling=true" -q
echo "Remove all unused (dangling) images"
# [LEGACY METHOD] docker rmi $(docker images -f "dangling=true" -q)
docker system prune --force
# Remove all stopped containers, unused networks, all images, all build cache
# docker system prune -a
# This will remove all local volumes not used by at least one container.
docker volume prune --force
