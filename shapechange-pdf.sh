#! /bin/sh

start=$(date +%s)
echo "I am shapechange PDF, nice to meet you."
echo ""

if [[ -d $1 ]]; then
    dir=$1
elif [[ -f $1 ]]; then
    echo "$1 is a file, you under estamate my power..."
    bash "./powerword-pdf.sh" "$1"
else
    echo "$1 is not valid, bye."
    exit 1
fi

echo "This is the list of PDF files that are going to be converted:"
ls "$dir"
echo "------------------------------------------------------------------------------------------------------"

files=$(ls "$dir")
for file in ${files}; do
    ## echo "./pdf-spit.sh" "${dir}/${file}"
    [ -f "${dir}/${file}" ] && bash "./powerword-pdf.sh" "${dir}/${file}"
done

echo "------------------------------------------------------------------------------------------------------"
echo "Done in $(( $(date +%s) - start )) s"

