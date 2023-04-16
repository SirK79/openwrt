# ZTE MF286R - OpenWRT - lte check

This script will restart your wan if it fails to ping given host e.g. `8.8.8.8`

```
./check_network.sh 8.8.8.8
```

### Configuration options:

```
# How many pings to try in a row before marking as a failure
pingCount=3
# How many failed retries before restarting WAN interface
maxRetry=15
# Phone number to send text message when outage detected
sendTextTo=48602xxxxxx
```

### Cron
Try every minute with Cron:
```
crontab -e
```
within the crontab:
```
* * * * * /root/check_network.sh 8.8.8.8 >> /tmp/network_check_cron.log 2>&1
```