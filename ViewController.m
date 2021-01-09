//
//  ViewController.m
//  TestApp
//
//  Created by Cesar Guirao on 12/5/16.
//  Copyright © 2016 TokBox. All rights reserved.
//

#import "ViewController.h"
#import <OpenTok/OpenTok.h>
#import "Logger.h"

int otc_log_enable(int log_level);

@interface OTSession ()
    
- (void)setApiRootURL:(NSURL *)aURL;
    
@end

@interface ViewController ()
<OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate, OTSubscriberKitRtcStatsReportDelegate>

@end

@implementation ViewController {
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
    
}
static Logger* myLog;

static double widgetHeight = 240;
static double widgetWidth = 320;

static NSString* const kApiKey = @"100";
// Replace with your generated session ID
static NSString* const kSessionId = @"1_MX4xMDB-fjE2MDc5ODQxMTEyNjF-QnNaQmdpRVIwV1ZpSG5aa2puY053U2FEfn4";
// Replace with your generated token
static NSString* const kToken = @"T1==cGFydG5lcl9pZD0xMDAmc2RrX3ZlcnNpb249dGJwaHAtdjAuOTEuMjAxMS0wNy0wNSZzaWc9YzYxZmIxM2EzZmMzOTUyZGU1ODZkZmFmMWFkNmFiNzMzZjczMzBmNTpzZXNzaW9uX2lkPTFfTVg0eE1EQi1makUyTURjNU9EUXhNVEV5TmpGLVFuTmFRbWRwUlZJd1YxWnBTRzVhYTJwdVkwNTNVMkZFZm40JmNyZWF0ZV90aW1lPTE2MDc5ODQxMTEmcm9sZT1tb2RlcmF0b3Imbm9uY2U9MTYwNzk4NDExMS4zNzQyMTYyMDQwNzc2JmV4cGlyZV90aW1lPTE2MTA1NzYxMTE=";


// Change to NO to subscribe to streams other than your own.
static bool subscribeToSelf = YES;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myLog = [Logger sharedInstance];
    // otc_log_enable(0x7FFFFFFF);
    
    // Step 1: As the view comes into the foreground, initialize a new instance
    // of OTSession and begin the connection process.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];

    [self.view addGestureRecognizer:tapRecognizer];
    _session = [[OTSession alloc] initWithApiKey:kApiKey
                                       sessionId:kSessionId
                                        delegate:self];
    [self doConnect];
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [_subscriber getRtcStatsReport];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UIUserInterfaceIdiomPhone == [[UIDevice currentDevice]
                                      userInterfaceIdiom])
    {
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - OpenTok methods

/**
 * Asynchronously begins the session connect process. Some time later, we will
 * expect a delegate method to call us back with the results of this action.
 */
- (void)doConnect
{
    [_session setApiRootURL:[NSURL URLWithString:@"https://anvil-tbdev.opentok.com"]];
    
    OTError *error = nil;
    
    [_session connectWithToken:kToken error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

/**
 * Sets up an instance of OTPublisher to use with this session. OTPubilsher
 * binds to the device camera and microphone, and will provide A/V streams
 * to the OpenTok session.
 */
- (void)doPublish
{
    OTPublisherSettings *settings = [[OTPublisherSettings alloc] init];
    settings.audioTrack = YES;
    settings.videoTrack = YES;
    settings.name = [[UIDevice currentDevice] name];
    _publisher =
    [[OTPublisher alloc] initWithDelegate:self
                                 settings:settings];
    
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    
    [self.view addSubview:_publisher.view];
    [_publisher.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
}

/**
 * Cleans up the publisher and its view. At this point, the publisher should not
 * be attached to the session any more.
 */
- (void)cleanupPublisher {
    [_publisher.view removeFromSuperview];
    _publisher = nil;
    // this is a good place to notify the end-user that publishing has stopped.
}

/**
 * Instantiates a subscriber for the given stream and asynchronously begins the
 * process to begin receiving A/V content for this stream. Unlike doPublish,
 * this method does not add the subscriber to the view hierarchy. Instead, we
 * add the subscriber only after it has connected and begins receiving data.
 */
- (void)doSubscribe:(OTStream*)stream
{
    _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    _subscriber.rtcStatsReportDelegate = self;
    OTError *error = nil;
    [_session subscribe:_subscriber error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

/**
 * Cleans the subscriber from the view hierarchy, if any.
 * NB: You do *not* have to call unsubscribe in your controller in response to
 * a streamDestroyed event. Any subscribers (or the publisher) for a stream will
 * be automatically removed from the session during cleanup of the stream.
 */
- (void)cleanupSubscriber
{
    [_subscriber.view removeFromSuperview];
    _subscriber = nil;
}

# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    
    // Step 2: We have successfully connected, now instantiate a publisher and
    // begin pushing A/V streams into OpenTok.
    [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage =
    [NSString stringWithFormat:@"Session disconnected: (%@)",
     session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
    _session = nil;
    _publisher = nil;
    _subscriber = nil;
}


- (void)session:(OTSession*)mySession
  streamCreated:(OTStream *)stream
{
    NSLog(@"session streamCreated (%@)", stream.streamId);
    
    // Step 3a: (if NO == subscribeToSelf): Begin subscribing to a stream we
    // have seen on the OpenTok session.
    if (nil == _subscriber && !subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}

- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
}

- (void)  session:(OTSession *)session
connectionCreated:(OTConnection *)connection
{
    NSLog(@"session connectionCreated (%@)", connection.connectionId);
}

- (void)    session:(OTSession *)session
connectionDestroyed:(OTConnection *)connection
{
    NSLog(@"session connectionDestroyed (%@)", connection.connectionId);
    if ([_subscriber.stream.connection.connectionId
         isEqualToString:connection.connectionId])
    {
        [self cleanupSubscriber];
    }
}

- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
    NSLog(@"didFailWithError: (%@)", error);
}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)",
          subscriber.stream.connection.connectionId);
    assert(_subscriber == subscriber);
    [_subscriber.view setFrame:CGRectMake(0, widgetHeight, widgetWidth,
                                          widgetHeight)];
    [self.view addSubview:_subscriber.view];
}

- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@",
          subscriber.stream.streamId,
          error);
}
-(void) subscriber:(OTSubscriberKit *)subscriber rtcStatsReport:(NSString *)jsonArrayOfReports {
    [myLog statsReport:@"found something"];
   
}

# pragma mark - OTPublisher delegate callbacks

- (void)publisher:(OTPublisherKit *)publisher
    streamCreated:(OTStream *)stream
{
    //[myLog peerConnectionsPublisher:TRUE];
    [myLog sdpPublisher:TRUE];
    //[myLog search:@"turn"];
    if (nil == _subscriber && subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}

- (void)publisher:(OTPublisherKit*)publisher
  streamDestroyed:(OTStream *)stream
{
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
    
    [self cleanupPublisher];
}

- (void)publisher:(OTPublisherKit*)publisher
 didFailWithError:(OTError*) error
{
    NSLog(@"publisher didFailWithError %@", error);
    [self cleanupPublisher];
}

- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                        message:string
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show];
    });
}
- (IBAction)buttonAction:(id)sender {
    [_session disconnect:nil];
}

@end
