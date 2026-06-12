#!/bin/bash

# Get the values of the CMD arguments (ignore the name of the script which is $0)
workspaceRootPath=$1
packageName=$2

# Make sure all argumants where provided
if [ -z "$packageName" ]; then
	echo "ERROR: Missing name of the package. In order to build all packages use *"
	exit 1
fi
if [ -z "$workspaceRootPath" ]; then
	echo "ERROR: Missing path to the root of the workspace"
	exit 2
fi

# Make sure the package as well as the workspace exist
if [ ! -d "$workspaceRootPath" ]; then
	echo "ERROR: Unable to find the workspace"
	exit 3
fi
if [ ! -d "${workspaceRootPath}/${packageName}" ]; then
	echo "ERROR: Unable to find the package"
	exit 4
fi

# Try to build the package
cd "$workspaceRootPath"
if [ "$packageName" = "*" ]; then
	colcon build || {
		echo "ERROR: Unable to build the whole package"
		exit 5
	}
else
	colcon build --packages-select "$packageName" || {
		echo "ERROR: Unable to build ${packageName}"
		exit 6
	}
fi

# Source the workspace in order to apply the changes
source "${workspaceRootPath}/install/setup.bash"

# Close with success
echo "Success"
