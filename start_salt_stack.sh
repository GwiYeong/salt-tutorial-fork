pkill salt-minion
pkill salt-api
pkill salt-master
salt-master -l info -d
salt-api -l info -d
salt-minion -l info -c /root/minion1-config -d
salt-minion -l info -c /root/minion2-config -d
salt-minion -l info -c /root/minion3-config -d
