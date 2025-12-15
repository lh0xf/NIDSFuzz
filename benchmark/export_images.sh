#!/bin/bash -e

cd "$(dirname "$0")" || exit 1
set -eu

build_image() {
    local IMAGE_NAME="$1"
    local DOCKERFILE="$2"
    local CONTEXT="$3"

    local image_id=$(docker images -q ${IMAGE_NAME})
    if [ -n "$image_id" ]; then
        echo "Found image: $IMAGE_NAME $image_id"

        read -p "⏳ Do you want to rebuild ${IMAGE_NAME}? (No): " action
        action=$(echo "$action" | tr '[:upper:]' '[:lower:]')

        if [[ "$action" == "yes" || "$action" == "y" ]]; then
            echo "🧹 Deleting image: ${image_id}"
            docker rmi "${image_id}"

            echo "📦 Building image: ${IMAGE_NAME}"
            docker build -t "${IMAGE_NAME}" -f "$DOCKERFILE" "$CONTEXT"
        else
            echo "Do not rebuild image ${IMAGE_NAME}"
        fi
    else
        echo "📦 Building image: ${IMAGE_NAME}"
        docker build -t "${IMAGE_NAME}" -f "$DOCKERFILE" "$CONTEXT"
    fi

    echo "--------------------"
}

######################################
######################################

save_image() {
    local IMAGE_NAME="$1"
    local FILE_PATH="$2"

    mkdir -p "$(dirname "${FILE_PATH}")"
    file_name=$(basename "$FILE_PATH")

    if [ -f "${FILE_PATH}" ]; then
        echo "File already exists ${file_name}"

        read -p "⏳ Do you want to delete file ${file_name}? (No): " action
        if [[ "$action" == "yes" || "$action" == "y" ]]; then
            echo "🧹 Deleting ${file_name}"
            rm "$FILE_PATH"

            echo "📄 Exporting the docker image: ${IMAGE_NAME}"
            docker save -o "${FILE_PATH}" "${IMAGE_NAME}"
        else
            echo "Do not delete the file ${file_name}"
        fi
    else
        echo "📄 Exporting the docker image: ${IMAGE_NAME}"
        docker save -o "${FILE_PATH}" "${IMAGE_NAME}"
    fi

    echo "--------------------"
}

######################################
######################################

echo "==================="
build_image "nidsfuzz/nidsfuzz" "dockerfiles/Dockerfile.nidsfuzz" "../"
save_image "nidsfuzz/nidsfuzz" "docker-images/nidsfuzz.tar"
echo "🎉 Successfully exported image: nidsfuzz."

echo "==================="
build_image "nidsfuzz/mirror" "dockerfiles/Dockerfile.mirror" "."
save_image "nidsfuzz/mirror" "docker-images/mirror.tar"
echo "🎉 Successfully exported image: mirror."

echo "==================="
build_image "nidsfuzz/snort3" "dockerfiles/Dockerfile.snort3" "."
save_image "nidsfuzz/snort3" "docker-images/snort3.tar"
echo "🎉 Successfully exported image: snort3."

echo "==================="
build_image "nidsfuzz/suricata" "dockerfiles/Dockerfile.suricata" "."
save_image "nidsfuzz/suricata" "docker-images/suricata.tar"
echo "🎉 Successfully exported image: suricata."

echo "==================="
build_image "nidsfuzz/snort2" "dockerfiles/Dockerfile.snort2" "."
save_image "nidsfuzz/snort2" "docker-images/snort2.tar"
echo "🎉 Successfully exported image: snort2."

# Usage: docker load -i xxx.tar