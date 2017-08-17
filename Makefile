prefix = /usr/local
rootprefix = $(prefix)
rootlibexecdir = $(rootprefix)/lib/systemd
systemunitdir=$(rootprefix)/lib/systemd/system

TIMESYNCD_PATH = $(rootlibexecdir)/systemd-timesyncd
RM = /bin/rm

####

files.out.all += systemd-timesyncd-wait
files.out.all += systemd-timesyncd-wrap
files.out.all += systemd-timesyncd.service.d-wait.conf
files.out.all += systemd-timesyncd-wait.service

files.sys.all += $(rootlibexecdir)/systemd-timesyncd-wait
files.sys.all += $(rootlibexecdir)/systemd-timesyncd-wrap
files.sys.all += $(systemunitdir)/systemd-timesyncd-wait.socket
files.sys.all += $(systemunitdir)/systemd-timesyncd-wait.service
files.sys.all += $(systemunitdir)/systemd-timesyncd.service.d/wait.conf

outdir = .
srcdir = .
all: $(addprefix $(outdir)/,$(files.out.all))
clean:
	rm -f -- $(addprefix $(outdir)/,$(files.out.all))
install: $(addprefix $(DESTDIR),$(files.sys.all))
.PHONY: all clean install

$(outdir)/%: $(srcdir)/%.go
	go build -o $@ $<

vars = rootlibexecdir TIMESYNCD_PATH RM
$(outdir)/%: $(srcdir)/%.in
	sed $(foreach v,$(vars),-e 's|@$v@|$($v)|g') < $< > $@

$(DESTDIR)$(rootlibexecdir)/%: $(outdir)/%
	install -DTm755 $< $@
$(DESTDIR)$(systemunitdir)/%: $(srcdir)/%
	install -DTm644 $< $@
$(DESTDIR)$(systemunitdir)/systemd-timesyncd.service.d/wait.conf: $(outdir)/systemd-timesyncd.service.d-wait.conf
	install -DTm644 $< $@

.SECONDARY:
.DELETE_ON_ERROR:
