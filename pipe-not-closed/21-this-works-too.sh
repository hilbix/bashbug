#!/bin/bash

producer()
{
  while	printf '%(%Y%m%d-%H%M%S)T\n'
  do sleep 1; done
}

consumer()
{
  sleep $[RANDOM / 10000]
  echo "$*"
}

run()
{
  let n=${1:-10}
  exec 6<&-
  while	read -ru6 data
  do
	consumer "$n" "$data" 6<&- &
	let n-- || break
  done 6< <(producer)
  exec 6<&-

  echo WAIT
  wait	# this works, too
}

for a in 10 15 5
do
	run "$a"
done

echo DONE

