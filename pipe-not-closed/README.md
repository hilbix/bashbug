# Pipe Not Closed

Usually file descriptors are closed when no more needed.

There seems to be some bug which keeps the file descriptors open
in certain situations like for loops.  Which comes very unexpected,
as previous working code may break if wrapped into a for loop.

Example for some working code:

	while read -ru6 data; do consume "$data" & ready "$data" && break; done 6< <(producer)
	wait	# wait for the producer to terminate

This stops the producer (closes STDIN) in case the `ready`-test breaks the loop.

However following no more works:

	for repeat in 1 2 3; do
	while read -ru6 data; do consume "$data" & ready "$data" && break; done 6< <(producer)
	wait	# wait for the producer to terminate
	done

Note that the while loop is not changed, it is just wrapped into some repeating `for` loop.

The problem is, that the producer never terminates as the `for` keeps FD 6 open.

> I think this is a bug

Note that following works:

	wrap() {
	while read -ru6 data; do consume "$data" & ready "$data" && break; done 6< <(producer)
	wait	# wait for the producer to terminate
	}
	for repeat in 1 2 3; do wrap; done

> I think this means, that the bug is in the parser.
> In nested loops, the FD can be associated to the wrong loop
> such that bash keeps it open when not necessary.

