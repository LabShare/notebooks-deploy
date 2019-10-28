for nb in source_nbs/user/*.ipynb; do
    filename=${nb%.ipynb}
    jupyter nbconvert --to rst $filename --output ../../source/user/${filename##*/}
done
