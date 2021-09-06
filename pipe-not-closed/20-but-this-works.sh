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

#for a in 10 15 5
#do
	let n=${a:-10}
	exec 6<&-
	while	read -ru6 data
	do
		consumer "$n" "$data" 6<&- &
		let n-- || break
	done 6< <(producer)
	exec 6<&-

	echo WAIT
	wait	# works without for loop?!?
#done

echo DONE

