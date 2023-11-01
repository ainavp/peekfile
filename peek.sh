if [[ -z $2 ]]; then var=3; else var=$2; fi
if [[ $(wc -l < $1) -le $((2*$var)) ]]; then cat $1; else echo Warning: Too many lines; head -n $var $1; echo ...; tail -n $var $1; fi
