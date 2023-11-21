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
	if grep -q '>' $file; then 
		if [[ -h $file ]]; then 	#Checking wether it is a symlink or not.
			echo Symlink : Yes; 
		else echo Symlink: No ;
		fi 
		if  grep -hv '>' $file | grep -q [VLKWHFIRMPSNQYDE] ; then #Checking wether it is a nucleotidic or aminoacidic sequence.
			echo Number of sequences:  $(grep -c '>' $file) #Counting the number of sequences of the file.
			echo Sequence type: amino acids
			echo Total sequence length: $(grep -v ">" $file| tr -d '-' | tr -d ' ' | tr -d '\n' | wc -c) aa #Getting the total length of the sequences. 
		else											                #Using the -d(delete) option of tr to remove gaps, newlines and spaces		
			echo Number of sequences: $(grep -c '>' $file)
			echo Sequence type: nucleotides
			echo Total sequence length: $(grep -v ">" $file| tr -d '-' | tr -d ' ' | tr -d '\n' | wc -c) pb
		fi
		
		#Printing the contents of the file
		
		if [[ $(($nlines*2)) -ge $(cat $file | wc -l) ]] && [[ $nlines -ne 0 ]] ; then 
			echo Content of the file:  
			cat $file
		elif [[ $nlines -eq 0 ]]; then 
			continue
		else 
			if [[ $nlines -eq 1 ]]; then 
				echo Warning: The file is too long to be fully displayed. Printing the first and the last line
			else
				echo Warning: the file is too long to be fully displayed. Printing the first and the last $nlines lines
			fi

			head -n $nlines $file
			echo $'\n'...$'\n'
			tail -n $nlines $file
		fi
	else
		echo "Warning: this file is in binary format. Its content can't be analized"
	fi
done 
	
