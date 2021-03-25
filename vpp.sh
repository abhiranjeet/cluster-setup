sudo vppctl delete interface memif memif1/0
sudo vppctl delete interface memif memif1/1
sudo systemctl restart vpp
ping -c 2 192.168.122.93
echo "Creating Interfaces"
sudo vppctl create memif socket id 1 filename /tmp/memif1.sock
sudo vppctl create interface memif id 0 socket-id 1 ring-size 1024 buffer-size 2048 master rx-queues 1 tx-queues 1
sudo vppctl create interface memif id 1 socket-id 1 ring-size 1024 buffer-size 2048 master rx-queues 1 tx-queues 1
sudo vppctl set interface state GigabitEthernet0/5/0 up
sudo vppctl set interface state GigabitEthernet0/4/0 up
sudo vppctl set interface state memif1/0 up
sudo vppctl set interface state memif1/1 up

echo "L2 Cross Connects"
sudo vppctl set interface l2 xconnect GigabitEthernet0/4/0 memif1/0
sudo vppctl set interface l2 xconnect memif1/0 GigabitEthernet0/4/0

sudo vppctl set interface l2 xconnect memif1/1 GigabitEthernet0/5/0
sudo vppctl set interface l2 xconnect GigabitEthernet0/5/0 memif1/1

echo "VPP in container"
sudo docker restart ns-client-1
ping -c 4 192.168.122.93
sudo docker exec -it ns-client-1 vppctl delete interface memif memif1/0
sudo docker exec -it ns-client-1 vppctl delete interface memif memif1/1
sudo docker exec -it ns-client-1 vppctl create memif socket id 1 filename /tmp/memif1.sock
sudo docker exec -it ns-client-1 vppctl create interface memif id 0 socket-id 1 ring-size 1024 buffer-size 2048 slave rx-queues 1 tx-queues 1
sudo docker exec -it ns-client-1 vppctl create interface memif id 1 socket-id 1 ring-size 1024 buffer-size 2048 slave rx-queues 1 tx-queues 1
sudo docker exec -it ns-client-1 vppctl set interface state memif1/0 up
sudo docker exec -it ns-client-1 vppctl set interface state memif1/1 up
sudo docker exec -it ns-client-1 vppctl set interface l2 xconnect memif1/0 memif1/1
sudo docker exec -it ns-client-1 vppctl set interface l2 xconnect memif1/1 memif1/0
figlet "Done"

set interface rx-placement memif1/0 queue 0 worker 0
set interface rx-placement GigabitEthernet0/4/0 queue 0 worker 0
set interface rx-placement memif1/0 queue 1 worker 1
set interface rx-placement GigabitEthernet0/4/0 queue 1 worker 1
set interface rx-placement memif1/1 queue 0 worker 2
set interface rx-placement GigabitEthernet0/5/0 queue 0 worker 2
set interface rx-placement memif1/1 queue 1 worker 3
set interface rx-placement GigabitEthernet0/5/0 queue 1 worker 3
