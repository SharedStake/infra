# infra
Sharedstake mainnet infra and validator settings

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
