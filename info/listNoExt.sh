# List directories that DON'T contain a file extension

if [ $# -eq 0 ]; then
    echo "File extension was not provided as argument..."
else
    echo "Directories that do not contain file extension *.""$1"
    find . -type d | while read dir ; do 
        ls ${dir}/*."$1" > /dev/null 2>&1
        if [ $? -ne 0 ] ; then
             echo "$dir"
        fi
    done
fi

# Alternative in one line...
# find . -type d | while read dir; do if [ ! -f $dir/*.txt ]; then echo $dir; fi; done; 
