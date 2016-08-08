# stealth-tor-docker
## NOT WORKING YET DO NOT USE

## GOAL   
spin up a new ubuntu based tor-enabled hidden ssh server & client quickly and easily

## WHAT I GOT WORKING

1. server torrc correctly configured with `HiddenServiceAuthorityClient
2. client torrc correctly configured with HidServAuth 
3. ssh configured with ~/.ssh/config and host hidden2
CheckHostIP no
Compression yes
Port 22
user root
hostname blahblahblahserver.onion
proxyCommand ncat --proxy 127.0.0.1:9050 --proxy-type socks5 %h %p # ubuntu
