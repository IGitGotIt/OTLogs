//
//  Logger.m
//  TestApp
//
//  Created by Jaideep Shah on 1/8/21.
//  Copyright © 2021 TokBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Logger.h"

@interface OpenTokObjC : NSObject
+ (void)setLogBlockQueue:(dispatch_queue_t)queue;
+ (void)setLogBlock:(void (^)(NSString* message, void* arg))logBlock;
@end




@interface Logger ()
@end

@implementation Logger {
    NSMutableArray* logs;
    NSMutableArray* logs_peer;
    NSMutableArray* logs_sdp;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
       
        [OpenTokObjC setLogBlockQueue:dispatch_get_main_queue()];

    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        logs = [[NSMutableArray alloc] init];
        logs_peer = [[NSMutableArray alloc] init];
        logs_sdp = [[NSMutableArray alloc] init];
        
        [OpenTokObjC setLogBlock:^(NSString* message, void* arg) {
            [logs addObject:message];
            if ([message containsString:@"OT_TIMING"]) {
                [logs_peer addObject:message];
            }
            if ([message containsString:@"sdp=v=0"]) {
                [logs_sdp addObject:message];
            }
        }];
    }
    return self;
}
- (void) statsReport:(NSString *) s {
    NSLog(@"statsReport %@",s);
}

-(void) peerConnectionsPublisher : (BOOL) isPublisher
{
    if (logs_peer.count == 0) {
        NSLog(@"LOGS PEER: No logs at present.");
    }
    for (NSString* s in logs_peer) {
        if(isPublisher && [s containsString:@"publisher"]) {
            NSLog(@"LOGS PEER(Pub): %@",s);
        } else if(!isPublisher && [s containsString:@"subscriber"]) {
            NSLog(@"LOGS PEER(Sub): %@",s);
        }
    }
}

-(void) sdpPublisher: (BOOL) isPublisher 
{
    if (logs_sdp.count == 0) {
        NSLog(@"LOGS SDP: No logs at present.");
    }
    for (NSString* s in logs_sdp) {
        if(isPublisher && [s containsString:@"publisher"]) {
            NSLog(@"---------------------------------------------------------------\n");
            NSLog(@"📘📘📘📘📘 LOGS SDP(Pub): %@",s);
            NSLog(@"---------------------------------------------------------------\n");
        } else if(!isPublisher && [s containsString:@"subscriber"]) {
            NSLog(@"---------------------------------------------------------------\n");
            NSLog(@"📘📘📘📘📘 LOGS SDP(Pub): %@",s);
            NSLog(@"---------------------------------------------------------------\n");
        }
    }
}

-(void) search: (NSString *) s {
    BOOL found = FALSE;
    for (NSString* message in logs) {
        if([message containsString:s]) {
            NSLog(@"LOGS found for %@: %@",s, message);
            found = TRUE;
        }
    }
    if(!found) {
        NSLog(@"No LOGS found for %@",s);
    }
}
@end
