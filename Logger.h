//
//  Logger.h
//  TestApp
//
//  Created by Jaideep Shah on 1/8/21.
//  Copyright © 2021 TokBox. All rights reserved.
//

#ifndef Logger_h
#define Logger_h

@interface Logger : NSObject

+ (instancetype)sharedInstance;
-(void) statsReport:(NSString *) s;
-(void) peerConnectionsPublisher : (BOOL) isPublisher;
-(void) sdpPublisher: (BOOL) isPublisher;
-(void) search: (NSString *) s ;
@end


#endif /* Logger_h */
