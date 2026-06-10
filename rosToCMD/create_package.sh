#!/bin/bash

# Get the values of the CMD arguments (ignore the name of the script which is $0)
packageLanguage=$1
packagePath=$2
packageName=$3

# Check the arguments
if [ -z "$packageLanguage" ]; then
	echo "ERROR: You have to provide a language for the package (python/cmake)"
	exit 1
fi
if [ ! -d "$packagePath" ]; then
	echo "ERROR: Unable to locate the provided path"
	exit 2
fi
if [ -z "$packageName" ]; then
	echo "ERROR: You have to provide a name for the package"
	exit 3
fi

# Enter the correct directory
cd "$packagePath"
# Create the package depending on the language
if [ "$packageLanguage" = "python" ]; then
	ros2 pkg create "$packageName" --build-type ament_python --dependencies rclpy || {
		echo "ERROR: Couldn't create a python new package"
		exit 4
	}
elif [ "$packageLanguage" = "cmake" ]; then
	ros2 pkg create "$packageName" --build-type ament_cmake --dependencies rclcpp || {
		echo "ERROR: Couldn't create a cmake new package"
		exit 5
	}
else
	echo "ERROR: Unsupported language. You can either use python or cmake"
	exit 6
fi

# Close with success
echo "Success"
