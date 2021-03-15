
# What is this?
This is a systemd service that blocks time-sync.target until time has been fully synchronized. As default, this is fired when the timesync service starts -- which is not useful. Newer systemd versions (> 239) have a built-in method for this.

For details see:
[https://github.com/systemd/systemd/issues/5097](https://github.com/systemd/systemd/issues/5097)

# Installation

* Copy the dist folder on a P100.
* Execute  `sudo ./install.sh` in the dist directory.

This script does the following:
* Places preconfigured binaries at the correct place
* Creates a real system user for systemd-timesync (socket communication does not work with dynamic users)
* Delays iotedge runtime until NTP synchronization has been reached by adding a drop-in systemd config.

**Reboot after installation**

# Testing
Turn timesync off.

    sudo timedatectl set-ntp false

Reboot. Check that the target has not been reached now.

    systemctl check time-sync.target

Check the status of the wait-service.

    systemctl status systemd-timesyncd-wait.service

Check the status of iotedge.

    systemctl status iotedge

Sync time and check everything again.

    sudo timedatectl set-ntp true

Target should be active now, service is not waiting anymore and Iotedge is running.





