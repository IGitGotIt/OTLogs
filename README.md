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
2. You want to have emoji demarcations in the console log to browse them easily.
3. You want to have a lifecycle flow in your logs - say a peer connection start to finish. The current logs will give you this information but you don't know what to look for. Then later on you want to filter by streamID. 
4. You want to do a regex search.
5. You want to add the videoSentBytes or want a list of values in a csv format, for a particular stream.
6. You want the logs to be sent to a server on a failure.

and so on....

This is just a project to get started for power debugging of your app. 


# So what we did:

We created a facade called Logger which you invoke as follows:

```
myLog = [Logger sharedInstance];
```

The Logger interface is as follows:

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

1. Search for the string `turn`

```
 [myLog search:@"turn"];
 ```

Output with search string TURN:
```
2021-01-08 16:39:25.898695-0800 TestApp[13522:4997705] LOGS found for turn: [DEBUG] otk_http.c:202 - body_cb[http_parser *p=0x7facfc81d610,otk_http_connection* http_conn=0x7facfc81d600,const char *buf=[{"properties":{"p2p":{"preference":{"value":"disabled"}},"reconnection":true,"renegotiation":true,"peerRegeneration":true,"h264":false,"vp9":false,"vp8":true,"priorityVideoCodec":"vp8","clientLogging":true,"clientCandidates":"all","aes256":false,"facetimeEncoder":false},"session_id":"1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4","project_id":"100","partner_id":"100","create_dt":"1607984111261","session_status":"INFLIGHT","status_invalid":null,"media_server_hostname":"mantis003-dev.tokbox.com","messaging_server_url":"mantis003-dev.tokbox.com","messaging_url":"wss://mantis003-dev.tokbox.com:443/rumorwebsocketsv2","symphony_address":"symphony.mantis003-dev.tokbox.com","ice_server":"turn002-dev.tokbox.com","session_segment_id":"67d77cc2-fe95-4e4e-a56c-24d65afa675a","ice_servers":[{"url":"turn:54.68.140.100:3478?transport=udp","username":"1610239164:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.47D6E026-8C3B-486B-99E1-D245A5C6D002","credential":"U9xgbNYyLDqfYGQ9PDmIRjZv950="},{"url":"stun:54.68.140.100:3478","username":null,"credential":null},{"url":"turn:54.68.140.100:443?transport=tcp","username":"1610239164:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.47D6E026-8C3B-486B-99E1-D245A5C6D002","credential":"U9xgbNYyLDqfYGQ9PDmIRjZv950="},{"url":"turns:turn002-dev.tokbox.com:443?transport=tcp","username":"1610239164:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.47D6E026-8C3B-486B-99E1-D245A5C6D002","credential":"U9xgbNYyLDqfYGQ9PDmIRjZv950="}],"ice_credential_expiration":86100}],size_t len=1584]
2021-01-08 16:39:25.900811-0800 TestApp[13522:4997705] LOGS found for turn: [LOG] rumor_message_v1.c:133 - [RUMOR] INBOUND-00000003 PAYLOAD: {"content":{"iceServers":[{"url":"turn:54.68.140.100:3478?transport=udp","credential":"lEz+/npkW4hM2JuM8hEmqgcbPKk=","username":"1610230472:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.CEA73BB2-2B13-463A-9568-4097FA336559.B8B8BC87-9199-4EF3-B57B-AA6839FE7DED"},{"url":"stun:54.68.140.100:3478","credential":null,"username":null},{"url":"turn:54.68.140.100:443?transport=tcp","credential":"lEz+/npkW4hM2JuM8hEmqgcbPKk=","username":"1610230472:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.CEA73BB2-2B13-463A-9568-4097FA336559.B8B8BC87-9199-4EF3-B57B-AA6839FE7DED"},{"url":"turns:turn002-dev.tokbox.com:443?transport=tcp","credential":"lEz+/npkW4hM2JuM8hEmqgcbPKk=","username":"1610230472:1.1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4.CEA73BB2-2B13-463A-9568-4097FA336559.B8B8BC87-9199-4EF3-B57B-AA6839FE7DED"}]}}
```

2. Get peer connection timing logs for Subscribers only

```
[myLog peerConnectionsPublisher:FALSE];
```
Peer connection only Output:
```
2021-01-08 17:59:25.858945-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:2566 - OT_TIMING: PUBLISHER-INIT-STARTED 0x7fbb39d0b120 NULL T=1610157565007
2021-01-08 17:59:25.859148-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:2708 - OT_TIMING: PUBLISHER-INIT-COMPLETED 0x7fbb39d0b120 NULL T=1610157565011
2021-01-08 17:59:25.859317-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:1925 - OT_TIMING: PUBLISHER-GENERATEOFFERREQUESTRECEIVED 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565310
2021-01-08 17:59:25.859483-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:1000 - OT_TIMING: PUBLISHER-SENDOFFER-SETLOCALDESCRIPTION 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565321
2021-01-08 17:59:25.859617-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:934 - OT_TIMING: PUBLISHER-SENDICECANDIDATE 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565322
2021-01-08 17:59:25.859732-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:934 - OT_TIMING: PUBLISHER-SENDICECANDIDATE 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565323
2021-01-08 17:59:25.859831-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:934 - OT_TIMING: PUBLISHER-SENDICECANDIDATE 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565323
2021-01-08 17:59:25.859934-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:934 - OT_TIMING: PUBLISHER-SENDICECANDIDATE 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565323
2021-01-08 17:59:25.860059-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:934 - OT_TIMING: PUBLISHER-SENDICECANDIDATE 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565324
2021-01-08 17:59:25.860154-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:934 - OT_TIMING: PUBLISHER-SENDICECANDIDATE 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565324
2021-01-08 17:59:25.860260-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:934 - OT_TIMING: PUBLISHER-SENDICECANDIDATE 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565365
2021-01-08 17:59:25.860349-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:934 - OT_TIMING: PUBLISHER-SENDICECANDIDATE 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565366
2021-01-08 17:59:25.860443-0800 TestApp[14789:5036096] LOGS PEER(Pub): [DEBUG] otk_publisher_private.cpp:1700 - OT_TIMING: PUBLISHER-ANSWERPROCESSED-REMOTEDESCSET 0x7fbb39d0b120 DADAA0F2-1C92-495B-BCE4-6B76E7B16944 T=1610157565617
```

3. SDP with emoji demarcation

```
[myLog sdpPublisher:TRUE];
```

SDP Only Output:
```
2021-01-08 18:01:30.598502-0800 TestApp[14908:5039561] ---------------------------------------------------------------
2021-01-08 18:01:30.598617-0800 TestApp[14908:5039561] 📘📘📘📘📘 LOGS SDP(Pub): [DEBUG] otk_publisher_private.cpp:1672 - otk_publisher_on_answer[otk_publisher* publisher=0x7f8e8e50e790,struct otk_session* session=0x7f8e9e404f20,const char* sdp=v=0
o=- 3309551663 670364199 IN IP4 44.230.120.50
s=-
c=IN IP4 44.230.120.50
t=0 0
a=ice-lite
a=msid-semantic:WMS *
a=fingerprint:sha-256 D0:F7:EE:63:96:C9:8D:A4:E7:48:88:00:6A:F6:67:BF:EA:EC:C8:CD:1B:AB:B6:7E:90:05:58:A9:BD:64:9B:9F
a=group:BUNDLE audio video
m=audio 36808 UDP/TLS/RTP/SAVPF 111 110 112 113 126
c=IN IP4 44.230.120.50
a=rtpmap:111 opus/48000/2
a=rtpmap:110 telephone-event/48000
a=rtpmap:112 telephone-event/32000
a=rtpmap:113 telephone-event/16000
a=rtpmap:126 telephone-event/8000
a=rtcp:36808
a=recvonly
a=ice-ufrag:E0GI
a=ice-pwd:+hT7Nm/jkF1jleXi1O/L2b
a=candidate:1796272311 1 UDP 2130706431 44.230.120.50 36808 typ host generation 0
a=end-of-candidates
a=mid:audio
a=ssrc:11 cname:A61C2FF0-C23B-43BA-82B3-CDC740CA91D4
a=ssrc:11 msid:FD6A331F-7C0D-468F-A687-FD6DB37537E7 a0
a
2021-01-08 18:01:30.598905-0800 TestApp[14908:5039561] ---------------------------------------------------------------
2021-01-08 18:01:30.8
```

