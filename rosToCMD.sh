#! /bin/bash
# Get the CMD arguments
firstArgument=$1
secondArgument=$2
thirdArgument=$3
fourthArgument=$4

# Constant values
PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELP_MESSAGE="This is a list of all possible subcommands and their arguments:
1. --cn <directoy_path> <file_name> <programming_language>:
	Create a new python/cpp node
2. --cbp <path_for_the_package> <name_of_the_package> <programming_language>:
	Create a new package for python/cpp nodes
3. --cip <path_for_the_package> <name_of_the _package>:
	Create a new package for interfaces
4. --cw <path_of_the_workspace> <name_of_the_workspace> <source_the_workspace>:
	Create a new workspace and source it if <source_the_workspace> is true.
5. --bp <path_to_workspace> <workspace_name>:
	Build a certain package by providing a name. Otherwise enter *
"

# Check the arguments and start the sub scripts
if [ -z "$firstArgument" ]; then
	echo "ERROR: Missing arguments. Type --help to see more"
	exit -1
fi

# Handle the first argument
if [ "$firstArgument" = "--help" ]; then
	echo "$HELP_MESSAGE"
elif [ "$firstArgument" = "--bp" ]; then
	"$PARENT_DIR"/rosToCMD/build_package.sh "$secondArgument" "$thirdArgument" "$fourthArgument"
elif [ "firstArgument" = "--cip" ]; then
	"$PARENT_DIR"/rosToCMD/create_interface_package.sh "$secondArgument" "$thirdArgument" "$fourthArgument"
elif [ "$firstArgument" = "--cn" ]; then
	"$PARENT_DIR"/rosToCMD/create_node.sh "$secondArgument" "$thirdArgument" "$fourthArgument"
elif [ "$firstArgument" = "--cbp" ]; then
	"$PARENT_DIR"/rosToCMD/create_node_package.sh "$secondArgument" "$thirdArgument" "$fourthArgument"
elif [ "$firstArgument" = "-cw" ]; then
	"$PARENT_DIR"/rosToCMD/create_workspace.sh "$secondArgument" "$thirdArgument" "$fourthArgument"
else
	echo "ERROR: Unknown argument. Enter --help for help."
	exit -2
fi
	 
