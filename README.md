 > Notice: The latest versions of systemd in git (after v238) have
 > systemd-time-wait-sync.service; presumably it will be present in
 > systemd-239.  If you have systemd v239 or greater, you should use
 > systemd-time-sync-wait instead.

Proper time-sync.target support for systemd-timesyncd

This package essentially just works around
  https://github.com/systemd/systemd/issues/5097

systemd.special(7) tells us that "All services where correct time is
essential should be ordered after [time-sync.target]".  However,
systemd-timesyncd allows time-sync.target to be reached before
timesyncd has actually synchronized the time.  This is because it
sends READY=1 as soon as the daemon has initialized, rather that
waiting until it has successfully synchronized to an NTP server.

It would be trivial to patch timesyncd to wait, but that would
introduce some other problems.

So, I'm introducing systemd-timesyncd-wait.  It is a service that
listens for messages from systemd-timesyncd, and blocks until it sees
a message indicating that systemd-timesyncd has synchronized the time.

# Installation

To compile systemd-timesyncd-wait, you will need the following

 - Go >= 1.4
 - GNU Make

The only run-time dependencies are systemd (obviously), and the `rm`
program.

To install, simply grab a copy of the repo, and run `make install`,
with any configuration options specified as arguments:

	make prefix=/usr install

Of course, the desired value `prefix=` depends on your system.  Arch
and Parabola users will be most happy with `prefix=/usr`,
Ubuntu Xenial users will want to set `prefix=/`.
