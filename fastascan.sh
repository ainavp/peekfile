#Defining the arguments of the script.
if [[ -z $1 ]]; then
	folder=./
else folder=$1
fi
if [[ -z $2 ]]; then
	nlines=0
else nlines=$2
fi
#Finding all the fasta files, and counting the number of files and unique IDs. 
files=$(find $folder -type f -name "*.fasta" -or -name "*.fa")
if [[ $(echo "$files" | wc -l) -eq 1 ]]; then
	if [[ $(awk -F' ' '/^>/{print $1}' $files | sort | uniq | wc -l) -eq 1 ]]; then 
		echo There is 1 fasta file with 1 unique ID.
	else echo There is 1 fasta file with $(awk -F' ' '/^>/{print $1}' $files | sort | uniq | wc -l) unique IDs. 
	fi 
else if [[ $(awk -F' ' '/^>/{print $1}' $files | sort | uniq | wc -l) -eq 1 ]]; then 
		echo There are $(echo "$files" | wc -l) fasta files with 1 unique ID.
	else echo There are $(echo "$files" | wc -l) fasta files with $(awk -F' ' '/^>/{print $1}' $files | sort | uniq | wc -l) unique IDs. 
	fi
fi
#Iterating on every file
for file in $files; do
	echo $'\n'----- $file ----    #Printing the name of the file
	if [[ -h $file ]]; then 	#Checking wether it is a symlink or not.
		echo Symlink : Yes; 
	else echo Symlink: No ;
	fi 
	echo Number of sequences: $(grep -c '>' $file)
	if  grep -hv '>' $file | grep -q [DQEHILKMFPSWYV] ; then 
		if [[ $(grep -c '>' $file) -eq 1 ]]; then
			echo Type of sequence: aminoacidic sequence
		else echo Type of sequences: aminoacidic sequences
		fi
	else if [[ $(grep -c '>' $file) -eq 1 ]]; then
				echo Type of sequence: nucleotidic sequence
		else echo Type of sequences: nucleotidic sequences
		fi
	fi
done 
	
