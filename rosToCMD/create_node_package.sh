#!/bin/bash

# Get the values of the CMD arguments (ignore the name of the script which is $0)
packagePath=$1
packageName=$2
packageLanguage=$3

# Check the arguments
if [ ! -d "$packagePath" ]; then
	echo "ERROR: Unable to locate the provided path"
	exit 2
fi
if [ -z "$packageName" ]; then
	echo "ERROR: You have to provide a name for the package"
	exit 3
fi
if [ -z "$packageLanguage" ]; then
	echo "ERROR: You have to provide a language for the package (python/cpp)"
	exit 1
fi

# Enter the correct directory
cd "$packagePath"
# Create the package depending on the language
if [ "$packageLanguage" = "python" ]; then
	ros2 pkg create "$packageName" --build-type ament_python --dependencies rclpy || {
		echo "ERROR: Couldn't create a python new package"
		exit 4
	}
	# Apply the template of the setup.py
	PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
	if [ -f "${PARENT_DIR}/schemas/node_setup-py.txt" ]; then
		template=$(cat "${PARENT_DIR}/schemas/node_setup-py.txt") || {
			echo "ERROR: Can't open the template file"
			exit 8
		}
		cd "${packagePath}/${packageName}"
		echo "$template" > "setup.py"
	else
		echo "ERROR: Unable to locate the setup.py template"
		exit 7
	fi
elif [ "$packageLanguage" = "cpp" ]; then
	ros2 pkg create "$packageName" --build-type ament_cmake --dependencies rclcpp || {
		echo "ERROR: Couldn't create a cpp new package"
		exit 5
	}
	# Apply the template of the CMakeLists.txt
	PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
	if [ -f "${PARENT_DIR}/schemas/node_cmakelists.txt" ]; then
		template=$(cat "${PARENT_DIR}/schemas/node_cmakelists.txt") || {
			echo "ERROR: Can't open the template file"
			exit 8
		}
		cd "${packagePath}/${packageName}"
		echo "$template" > "CMakeLists.txt"
	else
		echo "ERROR: Unable to locate the CMakeLists template"
		exit 7
	fi
else
	echo "ERROR: Unsupported language. You can either use python or cpp"
	exit 6
fi

# Close with success
echo "Success"
