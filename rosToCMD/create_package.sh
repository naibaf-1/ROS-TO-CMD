#!/bin/bash

# ----------------------------------------------------------------------------------------
# Global variables
# ----------------------------------------------------------------------------------------
# Get the values of the CMD arguments (ignore the name of the script which is $0)
packageLanguage=$1
packagePath=$2
packageName=$3

# ----------------------------------------------------------------------------------------
# The skript itself
# ----------------------------------------------------------------------------------------
# Enter the correct directory
cd "$packagePath"
# Create the package depending on the language
if [ "$packageLanguage" = "python" ]; then
	ros2 pkg create "$packageName" --build-type ament_python --dependencies rclpy || {
		echo "ERROR: Couldn't create a python new package"
		exit 1
	}
elif [ "$packageLanguage" = "cmake" ]; then
	ros2 pkg create "$packageName" --build-type ament_cmake --dependencies rclcpp || {
		echo "ERROR: Couldn't create a cmake new package"
		exit 2
	}
else
	echo "ERROR: Unsupported language. You can either use python or cmake"
	exit 3
fi

# Close with success
echo "Success"
