#!/bin/bash

# --------------------------------------------------------------------------------
# Global variables
# --------------------------------------------------------------------------------
# Get the values of the CMD arguments (ignore the name of the script which is $0)
directoryPath=$1
fileName=$2
language=$3

# --------------------------------------------------------------------------------
# Functions
# --------------------------------------------------------------------------------
createPythonNode() {
	# Create a .py file
	echo "Creating an empty python node"
	cd "$directoryPath"
	touch "${fileName}.py"
	chmod +x "${fileName}.py"
	if [ -f "${fileName}.py" ]; then
		echo "Done"
	else
		echo "ERROR: Unable to locate the file"
		exit 5
	fi
	
	# Paste the template
	echo "Adding the python template"
	PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
	if [ -f "${PARENT_DIR}/schemas/python_node.txt" ]; then
		template=$(cat "${PARENT_DIR}/schemas/python_node.txt") || {
			echo "ERROR: Can't open the template file"
			exit 7
		}
		cd "$directoryPath"
		echo "$template" > "${fileName}.py"
		echo "DONE"
	else
		echo "ERROR: Unable to locate the python template"
		exit 6
	fi
}

createCppNode() {
	# Create a .cpp file
	echo "Creating an empty C/C++ node"
	cd "$directoryPath"
	touch "${fileName}.cpp"
	chmod +x "${fileName}.cpp"
	if [ -f "${fileName}.cpp" ]; then
		echo "Done"
	else
		echo "ERROR: Unable to locate the file"
		exit 5
	fi
	
	# Paste the template
	echo "Adding the C/C++ template"
	PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
	if [ -f "${PARENT_DIR}/schemas/cpp_node.txt" ]; then
		template=$(cat "${PARENT_DIR}/schemas/cpp_node.txt") || {
			echo "ERROR: Can't open the template file"
			exit 7
		}
		cd "$directoryPath"
		echo "$template" > "${fileName}.cpp"
		echo "DONE"
	else
		echo "ERROR: Unable to locate the C/C++ template"
		exit 6
	fi
}

# --------------------------------------------------------------------------------
# The skript itself
# --------------------------------------------------------------------------------
# Check the CMD Arguments
if [ -z "$directoryPath" ]; then
	echo "ERROR: Missing directory path"
	exit 1
fi

if [ -z "$fileName" ]; then
	echo "ERROR: You need to provide a name for the node"
	exit 2
fi

if [ -z "$language" ]; then
	echo "ERROR: You need to specify a language (python/c++)"
	exit 3
fi

if [ ! -d "$directoryPath" ]; then
	echo "ERROR: Unable to locate the provided directory"
	exit 4
fi

# Create the node depending on the language
cd "$directoryPath"
if [ "$language" = "python" ]; then
	createPythonNode
else if [ "$language" = "cpp" ]; then
	createCppNode
else
	echo "ERROR: Unsupported language. You need to choose python or cpp"
	exit 8
fi

# Return success
echo "Success"
