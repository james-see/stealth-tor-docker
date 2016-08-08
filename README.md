# stealth-tor-docker
## NOT WORKING YET DO NOT USE

## GOAL   
spin up a new ubuntu based tor-enabled hidden ssh server & client quickly and easily

## WHAT I GOT WORKING

1. server torrc correctly configured with HiddenServiceAuthorizeClient
  ```
  HiddenServiceAuthorizeClient stealth somerandom16charkey    
  HiddenServiceDir /var/lib/tor/ssh_onion_service/   
  HiddenServicePort 22 127.0.0.1:51900   
  ```
2. client torrc correctly configured with HidServAuth 
  ```
  HidServAuth blahblahblahserver.onion cookiekey # client somerandom16charkey
  ```

3. ssh configured with ~/.ssh/config and 
  ```
  host hidden2   
  
  CheckHostIP no   
  
  Compression yes   
  
  Port 22 
  
  user root   
  
  hostname blahblahblahserver.onion   
  
  proxyCommand ncat --proxy 127.0.0.1:9050 --proxy-type socks5 %h %p # ubuntu
  ```
4. Hidden webserver only curl'able from the client authorized (tested using simple Hello World) `curl --socks5-hostname 127.0.0.1:9050 blahblahblahserver.onion`

## DETAILS
