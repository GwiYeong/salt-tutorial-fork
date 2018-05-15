## Build & Run

```bash
docker build -t salt-stack:2017.7.6 .
docker run -it salt-stack:2017.7.6 /bin/bash
```

## Configs & Resources
* Salt Master  
[/master](/master)  

* Salt API  
[/master](/master)  

* Salt Minion  
minion1 : [/minion1](/minion1)  
minion2 : [/minion2](/minion2)  
minion3 : [/minion3](/minion3)  

* Salt Custom Module  
[/salt\_extmods/base/\_modules](/salt_extmods/base/_modules)  
[/salt\_extmods/dev/\_modules](/salt_extmods/dev/_modules)  
[/salt\_extmods/prod/\_modules](/salt_extmods/prod/_modules)  

* Salt Custom State  
[/salt\_extmods/base](/salt_extmods/base)  
[/salt\_extmods/dev](/salt_extmods/dev)  
[/salt\_extmods/prod](/salt_extmods/prod)  

* Salt Custom Pillar  
[/salt\_pillar/base](/salt_pillar/base)  

## Run Salt Master, Salt API, Salt Minion

```bash
cd /root
./start_salt_stack.sh
```

## Test Native Salt Stack Module

```bash
salt '*' cmd.run 'whoami' runas=test
salt -L 'minion1, minion2' cmd.run 'echo TEST'
salt -G 'os:centos' cmd.run 'echo test'
salt '*' grains.ls
salt '*' grains.item os osrelease oscodename
salt minion2 pkg.install httpd
```

Detailed documentation : https://docs.saltstack.com/en/latest/ref/modules/all/index.html

## Test Native Salt API

* Get an authentication token

```bash
curl -XPOST localhost:32001/login \
  -H 'Content-Type: application/json' \
  -d '
{
 "eauth": "pam",
 "username":"test",
 "password":"test"
}
'
```

```json
{
 "return": [
  {
   "perms": [".*", "@runner"],
   "start": 1526355255.599695,
   "token": "[TOKEN]",
   "expire": 1526398455.599696,
   "user": "test",
   "eauth": "pam"
  }
 ]
}
```

* Run 'local' client through API

```bash
curl -XPOST localhost:32001/run \
  -H 'Content-Type: application/json' \
  -H 'X-Auth-Token: [TOKEN]' \
  -d '
{
 "tgt_type": "glob",
  "tgt": "*",
  "client":"local",
  "fun": "cmd.run",
  "arg":["echo whoami", "runas=test"]
}
'
```

* Run 'local' client, 'list' tgt  through API

```bash
curl -XPOST localhost:32001/run \
  -H 'Content-Type: application/json' \
  -H 'X-Auth-Token: [TOKEN]' \
  -d '
{
 "tgt_type": "list",
 "tgt": ["minion1", "minion2"],
 "client":"local",
 "fun": "cmd.run",
 "arg":["echo whoami", "runas=test"]
}
'
```


* Run 'local_async' client, 'list' tgt  through API

```bash
curl -XPOST localhost:32001/run \
  -H 'Content-Type: application/json' \
  -H 'X-Auth-Token: [TOKEN]' \
  -d '
{
 "tgt_type": "list",
 "tgt": ["minion1", "minion2"],
 "client":"local_async",
 "fun": "cmd.run",
 "arg":["echo whoami", "runas=test"]
}
'
```

```json
{
 "return": [
  {
   "jid": "[JID]",
   "minions": ["minion1", "minion2"]
  }
 ]
}
```

```bash
curl -XGET localhost:32001/jobs/[JID] \
  -H 'Content-Type: application/json' \
  -H 'X-Auth-Token: [TOKEN]'
```


## Salt Stack Custom Module, State, Pillar

### Sync to Salt Minion

* Sync 'base' saltenv
```bash
salt '*' saltutil.sync_modules
salt '*' saltutil.sync_states
salt '*' saltutil.refresh_pillar
```

* Sync 'other' saltenv
```bash
salt '*' saltutil.sync_modules saltenv=other
salt '*' saltutil.sync_states saltenv=other
```

### Test Salt Stack Custom Module

```bash
salt '*' nhn.test
salt '*' nhn.test_param d=123 a b c
salt '*' nhn.dunder_salt test
salt '*' nhn.dunder_pillar
```

### Test Salt Stack Custom Pillar

```bash
salt '*' pillar.get location
salt '*' pillar.get pkgs
salt '*' pillar.get pkgs:apache
salt '*' pillar.raw
```

### Test Salt Stack Custom State

```bash
salt '*' state.apply state_test.run_cmd
salt '*' state.apply state_test.run_cmd pillar='{"pkgs":{"apache":"parameterized pillar"}}'
salt '*' state.apply state_test.apache
```

```bash
salt minion1 schedule.list
salt '*' state.apply state_test.monitor
salt '*' schedule.list
salt minion1 schedule.delete write_to_file

tail -f /tmp/scheduled_writing
```

### Test Salt Stack Custom Module by saltenv

```bash
salt '*' nhn.test
salt '*' saltutil.sync_modules saltenv=dev
salt '*' nhn.test
```
