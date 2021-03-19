# infra
Sharedstake mainnet infra and validator settings. 

Current infra is a AWS C5.xlarge. Checked daily. 
Ticking along fine with the following resource consumption:
```

Tasks: 114 total,   1 running, 113 sleeping,   0 stopped,   0 zombie
%Cpu(s):  1.5 us,  0.2 sy,  0.0 ni, 98.2 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
MiB Mem :   7666.1 total,   2221.2 free,   3426.6 used,   2018.3 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.   6336.6 avail Mem
```
## Beacon chain run cmd:
```
screen -d -m ./prysm.sh beacon-chain --p2p-host-ip=$(curl -s v4.ident.me) --config-file=./config.yaml
```

## Validator run cmd:
```
screen -d -m ./prysm.sh validator --config-file=./config.yaml
```

## For updates:
Run first before restart:
```
./prysm.sh beacon-chain --download-only
```

## Creating new validator keys
```
./deposit existing-mnemonic --num_validators 10 --chain mainnet
```

## Running Beacon and Validator as services 
```
useradd -s /bin/false -r prysm
chown -R /opt/prysm/ prysm
cp ./servicefiles/* /etc/systemd/system/
systemctl start beacon.service && systemctl enable beacon.service
systemctl start validator.service && systemctl enable validator.service
```
