rename 's/^musicbox.//' *.wav
rename 's/([A-Z])([0-9])(.*)/$2$1$3/' *.wav
find . -name "*.wav" | xargs -I % afconvert -f caff -d LEI16@44100 -c 1 %