#!/bin/bash

# ----------------------------------------------------------------------------------------
# Global variables
# ----------------------------------------------------------------------------------------
# Get the values of the CMD arguments (ignore the name of the script which is $0)
packagePath=$1
packageName=$2

# ----------------------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------
# The skript itself
# ----------------------------------------------------------------------------------------
# Check the arguments
if [ -z "$packagePath" ]; then
	echo "ERROR: You have to provide a path of the workspace"
	exit 1
fi
if [ -z "$packageName" ]; then
	echo "ERROR: You have to provide a name for the package"
	exit 2
fi
if [ ! -d "$packagePath" ]; then
	echo "ERROR: Unable to locate the workspace"
	exit 3
fi

# Create a new package and clean it up
cd "$packagePath"
ros2 pkg create "$packageName"
rm -r "${packagePath}/${packageName}/src/" "${packagePath}/${packageName}/include/"
cd "$packageName"
mkdir "msg" "srv" "action"

# TODO: Replace the package.xml and the CMakeLists.txt by the templates
PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"

# Replace the package.xml by the template
if [ -f "${PARENT_DIR}/schemas/interface_package-xml.txt" ]; then
	template=$(cat "${PARENT_DIR}/schemas/interface_package-xml.txt") || {
		echo "ERROR: Can't open the package.xml template file"
		exit 5
	}
	cd "${packagePath}/${packageName}"
	echo "$template" > "package.xml"
else
	echo "ERROR: Unable to locate the package.xml template"
	exit 4
fi

# Replace the CMakeLists.txt by the template
if [ -f "${PARENT_DIR}/schemas/interface_cmakelists.txt" ]; then
	template=$(cat "${PARENT_DIR}/schemas/interface_cmakelists.txt") || {
		echo "ERROR: Can't open the CMakeLists.txt template file"
		exit 7
	}
	cd "${packagePath}/${packageName}"
	echo "$template" > "CMakeLists.txt"
else
	echo "ERROR: Unable to locate the CMakeLists.txt template"
	exit 6
fi

# Close with success
echo "Success"
