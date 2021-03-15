#!/bin/bash
cp systemd/{systemd-timesyncd-wait,systemd-timesyncd-wrap} /tmp/lib/systemd/
chmod 755 /tmp/lib/systemd/systemd-timesyncd-wait /tmp/lib/systemd/systemd-timesyncd-wrap

cp systemd/system/{systemd-timesyncd-wait.socket,systemd-timesyncd-wait.service} /tmp/lib/systemd/system
chmod 644 /tmp/lib/systemd/system/systemd-timesyncd-wait.socket /tmp/lib/systemd/system/systemd-timesyncd-wait.service

mkdir /tmp/lib/systemd/system/systemd-timesyncd.service.d/
cp systemd/system/systemd-timesyncd.service.d/wait.conf /tmp/lib/systemd/system/systemd-timesyncd.service.d/wait.conf
chmod 644 /tmp/lib/systemd/system/systemd-timesyncd.service.d/wait.conf


systemctl stop systemd-timesyncd
useradd --system systemd-timesync -s /sbin/nologin -d /run/systemd

mkdir /etc/systemd/system/iotedge.service.d/
cp wait_for_time_sync.conf /etc/systemd/system/iotedge.service.d/