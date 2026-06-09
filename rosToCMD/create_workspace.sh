#!/bin/bash

# Get the values of the CMD arguments (ignore the name of the script which is $0)
workspacePath=$1
workspaceName=$2
sourceWorkspace=$3

# Verify the path isn't empty
if [ -z "$workspacePath" ]; then
	echo "ERROR: You need to provide the directory path"
	exit 1
# Verify the path exists
elif [ ! -d "$workspacePath" ]; then
	echo "ERROR: Unable to find the directory. Make sure it exists"
	exit 2
fi

# Verify the name isn't empty
if [ -z "$workspaceName" ]; then
	echo "ERROR: You need to provide the name for the workspace"
	exit 3
fi

# Create the workspace and build it
mkdir -p "$workspacePath/$workspaceName" || {
	echo "ERROR: Unable to create the directory"
	exit 4
}
cd "$workspacePath/$workspaceName"
colcon build || {
	echo "ERROR: Unable to build the workspace"
	exit 5
}

# If wanted source the workspace
if [ "$sourceWorkspace" = "true" ]; then
	source "${workspacePath}/${workspaceName}/install/setup.bash"
fi

# Finish and return success
echo "Success"
