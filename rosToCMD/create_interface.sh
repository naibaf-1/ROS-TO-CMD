#!/bin/bash

# Get the arguments
packagePath=$1
interfaceName=$2
interfaceType=$3

# Check the arguments
if [ -z "$packagePath" ]; then
	echo "ERROR: You have to provide the path to the package"
	exit 1
fi
if [ -z "$interfaceName" ]; then
	echo "ERROR: You have to provide a name for the new interface"
	exit 2
fi
if [ -z "$interfaceType" ]; then
	echo "ERROR: You have to provide an interface type (msg/srv/action)"
	exit 3
fi
if [ ! -d "$packagePath" ]; then
	echo "ERROR: Unable to locate the given package"
	exit 4
fi
if [[ "$interfaceType" != "msg" && "$interfaceType" != "svg" && "$interfaceType" != "action" ]]; then
	echo "ERROR: Unsupportet interface type"
	exit 5
fi

# Generate a new file with the correct ending
cd "${packagePath}/${interfaceType}"
touch "${interfaceName}.${interfaceType}"
if [ ! -f "${interfaceName}.${interfaceType}" ]; then
		echo "ERROR: Unable to locate the new interface file"
		exit 6
fi

# Receive the interface schema
nano "${interfaceName}.${interfaceType}"

# Make sure the CMakeLists.txt exists
cd "$packagePath"
if [ ! -f "CMakeLists.txt" ]; then
	echo "ERROR: Unable to find the CMakeLists.txt file"
	exit 7
fi

# Create the entry and share it with perl
entry="  ${interfaceType}/${interfaceName}.${interfaceType}"
export ENTRY="$entry"

# Write the entry into the CMakeLists.txt
perl -0777 -i.bak -pe 's/(rosidl_generate_interfaces\(.*?)\n(\s*\))/ $1 . "\n" . $ENV{ENTRY} . "\n" . $2 /sge' CMakeLists.txt || {
	echo "ERROR: An error occured while adding the new interface to the CMakeLists.txt"
	exit 8
}
rm "CMakeLists.txt.bak"

# Build the package
WORKSPACE_PATH="$( cd "${packagePath}/.." && pwd )"
PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
"$PARENT_DIR"/rosToCMD/build_package.sh "$WORKSPACE_PATH" "*"

# Describe how to implement the interface
echo "You can implement the new interface by adding it as an dependency of your node."

# Close with success
echo "Success"
