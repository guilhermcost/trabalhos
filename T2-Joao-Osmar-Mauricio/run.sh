#!/bin/bash

Out_file()  # Define diretorio da saída automaticamente
{
	in_path="$(dirname "$1")"
	in_name="$(basename "$1")"

	if [[ "${in_path,,}" == *"input"* ]]; then  # Caso entrada esteja em pasta de inputs
		out_path="$(dirname "${in_path}")"
		out_path="${out_path}/outputs"
		mkdir -p "${out_path}" # Cria pasta de outputs
	else
		out_path="${in_path}"
	fi

	out_name=${in_name%.*}.out

	if [[ "${out_path}" == "." ]]; then
		echo "${out_name}"
	else
		echo "${out_path}/${out_name}"
	fi
}

arg1="$1"
arg2="${2:-$(Out_file "$arg1")}"

echo "$arg2"

echo
echo "> executando compilador cm com entrada $arg1 e saída $arg2 ..." 
./cm < "$arg1" > "$arg2"

echo
echo "> saída está no arquivo $arg2 para programa $arg1 (em C-v1.1): " 
echo
cat "$arg2"
echo


