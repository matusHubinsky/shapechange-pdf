#! /bin/sh

start=$(date +%s)

echo " ███████╗██╗  ██╗ █████╗ ██████╗ ███████╗ ██████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗    ██████╗ ██████╗ ███████╗ ";
echo " ██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔════╝    ██╔══██╗██╔══██╗██╔════╝ ";
echo " ███████╗███████║███████║██████╔╝█████╗  ██║     ███████║███████║██╔██╗ ██║██║  ███╗█████╗      ██████╔╝██║  ██║█████╗   ";
echo " ╚════██║██╔══██║██╔══██║██╔═══╝ ██╔══╝  ██║     ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══╝      ██╔═══╝ ██║  ██║██╔══╝   ";
echo " ███████║██║  ██║██║  ██║██║     ███████╗╚██████╗██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████╗    ██║     ██████╔╝██║      ";
echo " ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝    ╚═╝     ╚═════╝ ╚═╝      ";

if !command -v magick &>/dev/null; then
    echo 'magick needs to be installed'
    exit 1
fi

if !command -v pdfunite &>/dev/null; then
    echo 'pdfunite needs to be installed'
    exit 1
fi

if !command -v pdfseparate &>/dev/null; then
    echo 'pdfseparate needs to be installed'
    exit 1
fi


if [[ -d $1 ]]; then
    dir=$1
elif [[ -f $1 ]]; then
    echo "$1 is a file, you under estamate my power..."
    bash "./powerword-pdf.sh" "$1"
else
    echo "$1 is not valid file path / directory, bye."
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

