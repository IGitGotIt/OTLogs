# OTLogs

Opentok iOS SDK gathers tons of log behind the scene. 

If you want to see detail logs you can do the following:
(This are private API's subject to change and refers our HelloWorld sample app)

```
ViewController.m beginning

@interface OpenTokObjC : NSObject
+ (void)setLogBlockQueue:(dispatch_queue_t)queue;
+ (void)setLogBlock:(void (^)(NSString* message, void* arg))logBlock;
@end

//in viewDidLoad before OT calls

[OpenTokObjC setLogBlock:^(NSString* message, void* arg) {NSLog(@"MY_LOGS %@", message);}];
[OpenTokObjC setLogBlockQueue:dispatch_get_main_queue()];
```
The above code will spew lots of logs. You can always copy paste these logs from the console and filter to search whatever you want.

Sometimes you want something extra like:
1. Real time logs which would filter out only sdp fields/value or say a `particular` sdp field or value and compare those fields to a saved instance of the previous session which you just disconnected from your app.
2. You want to have emoji demaracations in the log to browse them easily.
3. You want to have a lifecycle flow in your logs - say a peer connection start to finish. The current logs will give you this information but you don't know what to look for. 
4. You want to do a regex serach
5. You want to add the videoSentBytes or want a list of values in a csv format, for a particular stream.

and so on....

This is just a project to get started for power debugging of your app. 
You also need the ability to store the logs in a file, on a server etc. 

# So what we did:

We created a facade called Logger which you invoke as follows:

```
myLog = [Logger sharedInstance];
```

The Logger inteface is as follows:

```
@interface Logger : NSObject

+ (instancetype)sharedInstance;
-(void) statsReport:(NSString *) s;
-(void) peerConnectionsPublisher : (BOOL) isPublisher;
-(void) sdpPublisher: (BOOL) isPublisher;
-(void) search: (NSString *) s ;
@end

```

Same sample output:

1. Serach for the string `turn`

```
2021-01-08 16:39:25.898695-0800 TestApp[13522:4997705] LOGS found for turn: [DEBUG] otk_http.c:202 - body_cb[http_parser *p=0x7facfc81d610,otk_http_connection* http_conn=0x7facfc81d600,const char *buf=[{"properties":{"p2p":{"preference":{"value":"disabled"}},"reconnection":true,"renegotiation":true,"peerRegeneration":true,"h264":false,"vp9":false,"vp8":true,"priorityVideoCodec":"vp8","clientLogging":true,"clientCandidates":"all","aes256":false,"facetimeEncoder":false},"session_id":"1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4","project_id":"100","partner_id":"100","create_dt":"1607984111261","session_status":"INFLIGHT","status_invalid":null,"media_server_hostname":"mantis003-dev.tokbox.com","messaging_server_url":"mantis003-dev.tokbox.com","messaging_url":"wss://mantis003-dev.tokbox.com:443/rumorwebsocketsv2","symphony_address":"symphony.mantis003-dev.tokbox.com","ice_server":"turn002-dev.tokbox.com","session_segment_id":"67d77cc2-fe95-4e4e-a56c-24d65afa675a","ice_servers":[{"url":"turn:54.68.140.100:3478?transport=udp","username":"1610239164:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.47D6E026-8C3B-486B-99E1-D245A5C6D002","credential":"U9xgbNYyLDqfYGQ9PDmIRjZv950="},{"url":"stun:54.68.140.100:3478","username":null,"credential":null},{"url":"turn:54.68.140.100:443?transport=tcp","username":"1610239164:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.47D6E026-8C3B-486B-99E1-D245A5C6D002","credential":"U9xgbNYyLDqfYGQ9PDmIRjZv950="},{"url":"turns:turn002-dev.tokbox.com:443?transport=tcp","username":"1610239164:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.47D6E026-8C3B-486B-99E1-D245A5C6D002","credential":"U9xgbNYyLDqfYGQ9PDmIRjZv950="}],"ice_credential_expiration":86100}],size_t len=1584]
2021-01-08 16:39:25.900811-0800 TestApp[13522:4997705] LOGS found for turn: [LOG] rumor_message_v1.c:133 - [RUMOR] INBOUND-00000003 PAYLOAD: {"content":{"iceServers":[{"url":"turn:54.68.140.100:3478?transport=udp","credential":"lEz+/npkW4hM2JuM8hEmqgcbPKk=","username":"1610230472:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.CEA73BB2-2B13-463A-9568-4097FA336559.B8B8BC87-9199-4EF3-B57B-AA6839FE7DED"},{"url":"stun:54.68.140.100:3478","credential":null,"username":null},{"url":"turn:54.68.140.100:443?transport=tcp","credential":"lEz+/npkW4hM2JuM8hEmqgcbPKk=","username":"1610230472:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.CEA73BB2-2B13-463A-9568-4097FA336559.B8B8BC87-9199-4EF3-B57B-AA6839FE7DED"},{"url":"turns:turn002-dev.tokbox.com:443?transport=tcp","credential":"lEz+/npkW4hM2JuM8hEmqgcbPKk=","username":"1610230472:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.CEA73BB2-2B13-463A-9568-4097FA336559.B8B8BC87-9199-4EF3-B57B-AA6839FE7DED"}]}}
```



