figlet "Restart VPP"
vppctl delete interface memif memif1/0
vppctl delete interface memif memif1/1
systemctl restart vpp
ping -c 2 192.168.122.90
echo "Creating Interfaces"
vppctl create memif socket id 1 filename /tmp/memif1.sock
vppctl create interface memif id 0 socket-id 1 ring-size 1024 buffer-size 2048 master rx-queues 1 tx-queues 1
vppctl create interface memif id 1 socket-id 1 ring-size 1024 buffer-size 2048 master rx-queues 1 tx-queues 1
vppctl set interface state GigabitEthernet0/5/0 up
vppctl set interface state GigabitEthernet0/4/0 up
vppctl set interface state memif1/0 up
vppctl set interface state memif1/1 up

figlet "L2 Cross Connects"
vppctl set interface l2 xconnect GigabitEthernet0/4/0 memif1/0
vppctl set interface l2 xconnect memif1/0 GigabitEthernet0/4/0

vppctl set interface l2 xconnect memif1/1 GigabitEthernet0/5/0
vppctl set interface l2 xconnect GigabitEthernet0/5/0 memif1/1

figlet "VPP in container"
docker restart ns-client-2
docker exec -it ns-client-2 vppctl delete interface memif memif1/0
docker exec -it ns-client-2 vppctl delete interface memif memif1/1
docker exec -it ns-client-2 vppctl create memif socket id 1 filename /tmp/memif1.sock
docker exec -it ns-client-2 vppctl create interface memif id 0 socket-id 1 ring-size 1024 buffer-size 2048 slave rx-queues 1 tx-queues 1
docker exec -it ns-client-2 vppctl create interface memif id 1 socket-id 1 ring-size 1024 buffer-size 2048 slave rx-queues 1 tx-queues 1
docker exec -it ns-client-2 vppctl set interface state memif1/0 up
docker exec -it ns-client-2 vppctl set interface state memif1/1 up
docker exec -it ns-client-2 vppctl set interface l2 xconnect memif1/0 memif1/1
docker exec -it ns-client-2 vppctl set interface l2 xconnect memif1/1 memif1/0
figlet "Done"
