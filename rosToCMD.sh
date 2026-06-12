#! /bin/bash
# Get the CMD arguments
firstArgument=$1
secondArgument=$2
thirdArgument=$3
fourthArgument=$4

# Constant values
PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELP_MESSAGE="This is a list of all possible subcommands and their arguments:
1. --bp <workspace_name> <path_to_workspace>:
	Build a certain package by providing a name. Otherwise enter *
2. --cip <path_for_the_package> <name_of_the _package>:
	Create a new package for interfaces
3. --cn <directoy_path> <file_name> <programming_language>:
	Create a new python/cpp node
4. --cbp <programming_language> <path_for_the_package> <name_of_the_package>:
	Create a new package for python/cpp nodes
5. --cw <path_of_the_workspace> <name_of_the_workspace> <source_the_workspace>:
	Create a new package and source it (if true)
"

# Check the arguments and start the sub scripts
if [ -z "$firstArgument" ]; then
	echo "ERROR: Missing arguments. Type --help to see more"
	exit -1
fi

# Handle the first argument
if [ "$firstArgument" = "--help" ]; then
	echo "$HELP_MESSAGE"
	exit 0
elif [ "$firstArgument" = "--bp" ]; then
	"$PARENT_DIR"/rosToCMD/build_package.sh
	exit 0
elif [ "firstArgument" = "--cip" ]; then
	"$PARENT_DIR"/rosToCMD/create_interface_package.sh
	exit 0
elif [ "$firstArgument" = "--cn" ]; then
	"$PARENT_DIR"/rosToCMD/create_node.sh
elif [ "$firstArgument" = "--cbp" ]; then
	"$PARENT_DIR"/rosToCMD/create_package.sh
elif [ "$firstArgument" = "-cw" ]; then
	"$PARENT_DIR"/rosToCMD/create_workspace.sh
else
	echo "ERROR: Unknown argument. Enter --help for help."
	exit -2
fi
	 
