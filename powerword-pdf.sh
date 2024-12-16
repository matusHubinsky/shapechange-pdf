#! /bin/sh

###############################################################################
# Global variables
###############################################################################

input_pdf=$1

[ -f "${input_pdf}" ] || exit 1

parts=4
pages=$(pdfinfo "$input_pdf" | grep Pages | awk '{print $2}')
pages_real=$((pages  / 2 - 1))
split_pages=$((pages / parts))
total_pages=$((pages * 4))
new=$(echo $1 | rev | cut -d "/" -f 1 | rev | cut -d "." -f 1)
start=$(date +%s)
progress=$((0))

density=$((900))
page_width=$(pdfinfo "$input_pdf" | grep "Page size" | awk '{print $3}')
page_height=$(pdfinfo "$input_pdf" | grep "Page size" | awk '{print $5}')
page_width_px=$(echo "($page_width * $density / 72)/1" | bc)
page_height_px=$(echo "($page_height * $density / 72)/1" | bc)
half_width=$((page_width_px / 2))
half_height=$((page_height_px / 2))

###############################################################################
# Functions
###############################################################################

# update progress bar by yapping
function yap() {
    if [ "$progress" -lt 32 ]; then
        echo -n "#"
        progress=$((progress + 1))
    fi
}

# remove all the tmp files like .pdf and .png
# please be carefull wtih this shit
function no_betas() {
    yap
    rm cropped_part*.pdf &> /dev/null
    rm part*-*.pdf &> /dev/null
    rm *.png &> /dev/null
    rm [0-9]*.pdf &> /dev/null
    rm "$new" &> /dev/null
}

###############################################################################
# Main
###############################################################################

echo -n "$new:  ["
no_betas
yap

start_page=$((0))
end_page=$(($((pages))+2))

pdfseparate -f "$start_page" -l "$end_page" "$input_pdf" "part-%d.pdf" &> /dev/null 
yap

for i in $(seq 0 $total_pages); do
    magick -density "$density" "part-${i}.pdf" "part-${i}.png" &> /dev/null
    yap
done

k=$((0))

if [ -n "$2" ]; then
    if [[ "$2" == "-half" ]]; then
        # if argument -half is provided, we need to split the page into half
        for i in $(seq 0 $total_pages); do
            img="part-${i}.png"
            magick "$img" -crop "50%x100%+0+0" "$k.png"  &> /dev/null
            k=$((k+1))
            magick "$img" -crop "50%x100%+$(echo "scale=0; $page_height_px / 2" | bc)+0" "$k.png"  &> /dev/null
            k=$((k+1))
            yap
        done
    fi
else
    for i in $(seq 0 $total_pages); do
        img="part-${i}.png"
        magick "$img" -crop "50%x50%+0+0" "$k.png"  &> /dev/null
        k=$((k+1))
        magick "$img" -crop "50%x50%+$half_width+0" "$k.png"  &> /dev/null
        k=$((k+1))
        magick "$img" -crop "50%x50%+0+$half_height" "$k.png"  &> /dev/null
        k=$((k+1))
        magick "$img" -crop "50%x50%+$half_width+$half_height" "$k.png" &> /dev/null
        k=$((k+1))
        yap
    done
fi

for i in $(seq 0 $total_pages); do
    # echo "${i}.png ${i}.pdf"
    magick convert -page "${page_width}x${page_height}" -resize 100% "${i}.png" "${i}.pdf"  &> /dev/null
    yap
done

# unite all cropped PDFs pages (dont forget to sort)
pdfunite $(ls -v [0-9]*.pdf | sort -n) "$new.pdf" &> /dev/null
yap
no_betas

# keep yaping
for i in $(seq 0 $total_pages); do
    yap
done

echo "] $(( $(date +%s) - start )) s"
