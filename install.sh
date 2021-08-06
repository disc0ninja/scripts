#! /bin/sh

# Install all the shell scripts to .local/bin so they can be run as commands.

for script in $(find . -type d -not -wholename './.' -not -wholename './.*')
do
  if [ $script != '.' ]
  then
    script_name=`echo $script | tr -d '.,/'`
    ln $script_name/$script_name.sh ~/.local/bin/$script_name
  fi
done

