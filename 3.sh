n=1     # number of lines
a=()    # a[i] is the number of 1s in column i
l=0     # length of a line
lines=()

# to get the length of the line and initialize an array of 0s of the same size
read line
l=${#line}
lines+=($line)
for ((i = 0; i <= $l; i++)); do
    c=$(echo "$line" | head -c $i | tail -c 1)
    a+=($c)
done

# populate a
while read line; do
    ((n++))
    lines+=($line)
    for ((i = 0; i < $l; i++)); do
        c=${line:$i:1}
        a[$i]=$(expr ${a[i]} + $c)
    done
done

gamma=0
epsilon=0

for ((i = 0; i < $l; i++)); do
    zeroes=$(expr $n - ${a[i]})
    or_value=0
    if ((${a[i]} > $zeroes)); then
        or_value=1
    fi
    # use bit shifting to construct the decimal values of gamma and epsilon
    gamma=$(((gamma << 1) | or_value))
    epsilon=$(((epsilon << 1) | !or_value))
done

echo "Part 1: $((gamma * epsilon))"

# Part 2
oxy_lines=("${lines[@]}")
co2_lines=("${lines[@]}")
oxygen=0
co2=0
ll=${#lines[@]}

# get the oxygen rating
for ((i = 0; i < $l; i++)); do
    if [[ ${#oxy_lines[@]} -eq 1 ]]; then
        break
    fi

    a_oxy=()

    for ((q = 0; q < $l; q++)); do
        a_oxy+=(0)
    done

    for ((q = 0; q < $ll; q++)); do
        for ((j = 0; j < $l; j++)); do
            line=${oxy_lines[q]}
            c=${line:$j:1}
            if [[ -z $c ]]; then
                c=0
            fi
            a_oxy[$j]=$(expr ${a_oxy[j]} + $c)
        done
    done

    zeroes_oxy=$(expr "${#oxy_lines[@]}" - "${a_oxy[i]}")

    if [[ ${a_oxy[i]} -ge $zeroes_oxy ]]; then # if there are more 1s
        for ((j = 0; j < $ll; j++)); do
            line=${oxy_lines[j]}
            char=${line:$i:1}
            if [[ $char == "0" ]]; then
                unset oxy_lines[$j]
            fi
        done
    else # if there are more 0s
        for ((j = 0; j < $ll; j++)); do
            line=${oxy_lines[j]}
            # echo $line
            char=${line:$i:1}
            if [[ $char == "1" ]]; then
                unset oxy_lines[$j]
            fi
        done
    fi
done

# get the co2 rating
for ((i = 0; i < $l; i++)); do
    if [[ ${#co2_lines[@]} -eq 1 ]]; then
        break
    fi

    a_co2=()

    for ((q = 0; q < $l; q++)); do
        a_co2+=(0)
    done

    for ((q = 0; q < $ll; q++)); do
        for ((j = 0; j < $l; j++)); do
            line=${co2_lines[q]}
            c=${line:$j:1}
            if [[ -z $c ]]; then
                c=0
            fi
            a_co2[$j]=$(expr ${a_co2[j]} + $c)
        done
    done

    zeroes_co2=$(expr "${#co2_lines[@]}" - "${a_co2[i]}")

    if [[ ${a_co2[i]} -lt $zeroes_co2 ]]; then # if there are more 1s
        # echo 'mahame nuli'
        for ((j = 0; j < $ll; j++)); do
            line=${co2_lines[j]}
            char=${line:$i:1}
            if [[ $char == "0" ]]; then
                unset co2_lines[$j]
            fi
        done
    else # if there are more 0s
        for ((j = 0; j < $ll; j++)); do
            line=${co2_lines[j]}
            # echo $line
            char=${line:$i:1}
            if [[ $char == "1" ]]; then
                unset co2_lines[$j]
            fi
        done
    fi
done

oxy_lines=("${oxy_lines[@]}")
co2_lines=("${co2_lines[@]}")

oxy_rating=0
co2_rating=0

oxy_bin=${oxy_lines[0]}
co2_bin=${co2_lines[0]}

# convert to decimal
for ((i = 0; i < $l; i++)); do
    oxy_or=${oxy_bin:i:1}
    co2_or=${co2_bin:i:1}
    oxy_rating=$(((oxy_rating << 1) | oxy_or))
    co2_rating=$(((co2_rating << 1) | co2_or))
done

echo "Part 2: $((oxy_rating * co2_rating))"
