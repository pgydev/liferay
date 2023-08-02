#!/bin/bash

tools=("docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin")


is_tool_installed(){
if [ -x "$(command -v dpkg-query)" ]; then
  dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
else
  echo "Unsupported"
  exit 1
fi

}

install_tool(){
   echo "Installing $1"
  if [ -x "$(command -v apt)" ]; then
     sudo apt-get install -y "$1"
  elif [ -x "$(command -v yum)" ]; then
      sudo yum install -y "$1"
  else
     echo "This package manager is not supported"
     exit 1
  fi
}

missing_tools=()

for tool in "${tools[@]}"; do
 if ! is_tool_installed "$tool"; then
      missing_tools+=("$tool")
 fi
done

if [ ${#missing_tools[@]} -eq 0 ]; then
   echo "All tools are installed."
else
   echo "Missing tools: ${missing_tools[*]}";

   for tool in "${missing_tools[@]}"; do
      install_tool "$tool"
      if [ $? -ne 0 ]; then
        echo "Error occured while installing $tool"
        exit 1
      fi
    done
fi

sudo docker run hello-world
if [ $? -ne 0 ]; then 
   echo "Docker is not functioning"
   exit 1
else
 echo "Script completed"
fi
