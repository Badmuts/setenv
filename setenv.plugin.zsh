
_setenv_run() {
    if [ -x ".setenv" || -x "setenv" ] ; then 
        execute=1
        current_dir=`pwd`
        grep -Fx "$current_dir" ~/.setenv-whitelist &> /dev/null
        
        if [ 1 -eq $? ] ; then
        	echo "Directory $current_dir is not in setenv whitelist, but contains a .setenv file, do you still want to execute it? (y/n): "
        	read choice 

            if [ "$choice" != "y" ] ; then 
                execute=0
            fi
        fi

        if [ 1 -eq $execute ] ; then
            echo "File .setenv exists and is executable, will execute it."
            if [ -x ".setenv" ] ; then 
                source `pwd`/.setenv
            elif [ -x "setenv" ]; then
                source `pwd`/setenv
            fi
        fi
    fi
}

function setenv_run () {
    if [ ! -f ~/.setenv-whitelist ]; then
        touch ~/.setenv-whitelist
    fi

    _setenv_run
}

function setenv_whitelist () {
    current_dir=`pwd`
    grep -Fx "$current_dir" ~/.setenv-whitelist &> /dev/null

    if [ 1 -eq $? ];
    then
        pwd >> ~/.setenv-whitelist
    else 
        echo "Directory $current_dir is already in whitelist."
    fi
}

function setenv_whitelist_remove () {
    current_dir=`pwd`
    tmpfile=$(mktemp)
    grep -vFx "$current_dir" ~/.setenv-whitelist > $tmpfile
    cp $tmpfile ~/.setenv-whitelist
}  

function setenv_show_whitelist () {
    cat ~/.setenv-whitelist
} 

test_fn="setenv_run"
if [[ -z ${(M)chpwd_functions:#${test_fn}} ]]; then
    chpwd_functions+=(setenv_run)
fi

