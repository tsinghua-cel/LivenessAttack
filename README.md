# LivenessAttack
Liveness attack on multi server.

# Requirements
- 5 servers with aws c6a.xlarge instance type
- 100GB SSD storage on each server
- Ubuntu 24.04 LTS installed on all servers
- Docker installed on all servers
- Open ports 22, 2377, 3500, 8545, 10000, 13000 on all servers

# Setup
### 1. Clone the repository.
Clone the repository to `/opt/liveness` directory on all servers:
```shell
git clone -b multiserver  https://github.com/tsinghua-cel/LivenessAttack /opt/liveness
cd /opt/liveness
```

### 2. Init Docker Swarm

Execute the command on the first server to initialize the Docker Swarm:
```shell
docker swarm init --advertise-addr <FIRST_SERVER_IP>
```

### 3. Join to Docker Swarm

Execute the command on the other servers to join the Docker Swarm:
```shell
docker swarm join --token <SWARM_JOIN_TOKEN> <FIRST_SERVER_IP>:2377
```

### 4. Start the multi-server liveness attack
Execute the command on the first server to start the multi-server liveness attack:
```shell
./start.sh
```

### 5. Check results
After about 2 hours, you can check the results on the third server:
```shell
./fetchdata.sh
grep "Chain reorg" ./data/liveness_beacon3_data/_data/d.log
```
You can get the result like this:
```
time="2025-12-08 08:37:52" level=info msg="Chain reorg occurred" commonAncestorRoot=0xe7f9292bb6e203a0ae3963eee70f5e0e8cc42f1ef8af9dfb06570ef2b0ce82f9 depth=95 distance=124 newRoot=0xe30c57f49abbea81801f2b3c0cc9dfa5a358c90560f6872b5f811b9cca902cc6 newSlot=1053 newWeight=0 oldRoot=0x7356d36d7bac51379e40730ea53bc32e24d5328a9948ab63e1a4dadcf627d2c5 oldSlot=1119 oldWeight=102400000000 prefix=blockchain
time="2025-12-08 08:57:04" level=info msg="Chain reorg occurred" commonAncestorRoot=0xcebf29fa4ac7a527c99386473c592cb513fd85cb6d17b149c7e57ebeddc28bbf depth=95 distance=126 newRoot=0x2c148b437e96abccba4424926ffc5d559ea461e1f1754413b664e15eeda04261 newSlot=1151 newWeight=0 oldRoot=0xbc2529f60000b31fa84c205f3f355c23cb41831e00bc87cfe79e8a9c2b2d99f4 oldSlot=1215 oldWeight=102400000000 prefix=blockchain
time="2025-12-08 09:16:16" level=info msg="Chain reorg occurred" commonAncestorRoot=0x4842fb815d03c7eea658d43a88eedd09e3d90617074c4a5abeb88d5794ed7b61 depth=95 distance=126 newRoot=0x9ccc99efcf3cbdf2ebf7cfa0f0be68a70d70663afdaf144e06f101e6c3cafe36 newSlot=1247 newWeight=0 oldRoot=0xe0be9a93a97b584ac787a077b91eee348b5613165e538393ba3934caaa31d008 oldSlot=1311 oldWeight=102400000000 prefix=blockchain
time="2025-12-08 09:35:28" level=info msg="Chain reorg occurred" commonAncestorRoot=0xbb39f41ad32ba67f364a30a8077300df61b2674845d0db3c409cb7c813b87e16 depth=95 distance=123 newRoot=0x9d48b78838f31ad56807ac97e877e954979b9443fec39447161ab639a31ea75b newSlot=1340 newWeight=0 oldRoot=0xdc519de1ae3db96dfe1c950d376f05d71a0a1cdd7c05b5ea7fdd0e0430527b44 oldSlot=1407 oldWeight=102400000000 prefix=blockchain
time="2025-12-08 09:54:39" level=info msg="Chain reorg occurred" commonAncestorRoot=0xef47ef94813f48ea70a5f7dda3afafb4c1a1d34f792cbadc781828f68423c3b8 depth=93 distance=124 newRoot=0x739a1d7f986baafcd0b0c14f6bd095e9bab50c3e26e7b80e6b76cf345e5cd12b newSlot=1439 newWeight=0 oldRoot=0x108d908bae7c4fd4cea5382dfb337adb92af8b9b0f21efedeee8a35fbff3c4f6 oldSlot=1501 oldWeight=320000000000 prefix=blockchain
time="2025-12-08 10:13:51" level=info msg="Chain reorg occurred" commonAncestorRoot=0x4a5b927ef76254d76425aad5bcabefd71a24648cae1510e90be1b1825c86033f depth=94 distance=124 newRoot=0x5b87bc3f90b4bc9965e90ba2cf1f46ac900e55e0b0dc17ec51a1539d63a7703e newSlot=1534 newWeight=0 oldRoot=0x197bdd757491d77151f58b48e78e11f4c182b056758452d9ef5e8b75374d2f00 oldSlot=1598 oldWeight=294400000000 prefix=blockchain
```
### 6. Stop the multi-server liveness attack
##### a. Execute the command on the first server to stop the multi-server liveness attack:
```shell
./stop.sh
```

##### b. Execute the command on all servers to clear the volumes:
```shell
./clear.sh
```