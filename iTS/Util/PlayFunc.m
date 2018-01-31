//
//  PlayFunc.m
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PlayFunc.h"

#import "CSScreenRecorder.h"
#import "IDFileManager.h"

#include <mach/mach_time.h>
#import <objc/message.h>
#import <dlfcn.h>

@import MediaPlayer;

@interface PlayFunc ()<CSScreenRecorderDelegate>
{
    BOOL bRecording;
    CSScreenRecorder *_screenRecorder;
    MPVolumeView *volumeView;
    id routerController;
    NSString *airplayName;
    
    BOOL shouldConnect;
}
@end
@implementation PlayFunc
- (void)setupAirplayMonitoring
{
    if (!routerController) {
        routerController = [NSClassFromString(@"MPAVRoutingController") new];
        [routerController setValue:self forKey:@"delegate"];
        [routerController setValue:[NSNumber numberWithLong:2] forKey:@"discoveryMode"];
    }
}

/*
 -(void)routingControllerAvailableRoutesDidChange:(id)arg1{
 if (airplayName == nil) {
 return;
 }
 NSArray *availableRoutes = [routerController valueForKey:@"availableRoutes"];
 for (id router in availableRoutes) {
 NSString *routerName = [router valueForKey:@"routeName"];
 if ([routerName rangeOfString:airplayName].length >0) {
 BOOL picked = [[router valueForKey:@"picked"] boolValue];
 if (picked == NO) {
 [routerController performSelector:@selector(pickRoute:) withObject:router];
 }
 return;
 }
 }
 }
 */

-(void)routingControllerAvailableRoutesDidChange:(id)arg1{
    NSLog(@"arg1-%@",arg1);
    if (airplayName == nil) {
        return;
    }
    
    NSArray *availableRoutes = [routerController valueForKey:@"availableRoutes"];
    for (id router in availableRoutes) {
        NSString *routerName = [router valueForKey:@"routeName"];
        NSLog(@"routername -%@",routerName);
        if ([routerName rangeOfString:airplayName].length >0) {
            BOOL picked = [[router valueForKey:@"picked"] boolValue];
            if (picked == NO && !shouldConnect) {
                shouldConnect = YES;
                NSLog(@"connect once");
                NSString *one = @"p";
                NSString *two = @"ickR";
                NSString *three = @"oute:";
                NSString *path = [[one stringByAppendingString:two] stringByAppendingString:three];
                [routerController performSelector:NSSelectorFromString(path) withObject:router];
                //objc_msgSend(self.routerController,NSSelectorFromString(path),router);
            }
            return;
        }
    }
}



- (NSString*)generateMP4Name
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSString *fname = [NSString stringWithFormat:@"%@", currentTime];
    
    return [IDFileManager inDocumentsDirectory:fname];
    
}
- (void)startRecord :(NSString *) path
{
    
    shouldConnect = FALSE;
    airplayName = @"XBMC-GAMEBOX(XinDawn)";
    NSLog(@"path = %@",path);
    _screenRecorder.videoOutPath = path;
    NSLog(@"start Cha");
    [_screenRecorder startRecordingScreen];
    NSLog(@"end Cha");
    bRecording = YES;
    
}

- (void)stopRecord
{
    NSLog(@"stop record");
    shouldConnect = FALSE;
    airplayName = @"iPhone";
    
    [_screenRecorder stopRecordingScreen];
    bRecording = NO;
    NSLog(@"stopstop record");
    
    //  [self.mpView setHidden:NO];
    
    
    /*
     NSString *airplayNameiPhone = @"iPhone";
     NSArray *availableRoutes = [routerController valueForKey:@"availableRoutes"];
     for (id router in availableRoutes) {
     NSString *routerName = [router valueForKey:@"routeName"];
     if ([routerName rangeOfString:airplayNameiPhone].length >0) {
     BOOL picked = [[router valueForKey:@"picked"] boolValue];
     //usleep(1000*1000);
     if (picked == NO) {
     [routerController performSelector:@selector(pickRoute:) withObject:router];
     }
     return;
     }
     }*/
}

//- (IBAction)toggleRecord:(id)sender {
//    if(bRecording)
//    {
//        [self stopRecord];
//    }
//    else
//    {
//        [self startRecord];
//    }
//}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    [_screenRecorder setDelegate:self];
//
//    //    [self startRecord];
//}

- (id)init{
    // Create the request.
    NSLog(@"init");
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        //NSData receivedData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    // automatic airplay connection
    shouldConnect = FALSE;
    airplayName = @"XBMC-GAMEBOX(XinDawn)";
    [self setupAirplayMonitoring];
    
    
    bRecording = NO;
    
    volumeView = [ [MPVolumeView alloc] init] ;
    
    _screenRecorder.delegate = self;
    
    
    return self;
}

- (void)screenRecorderDidStartRecording:(CSScreenRecorder *)recorder
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"KDD, DID START");
    });
}

- (void)screenRecorderDidStopRecording:(CSScreenRecorder *)recorder
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"KDD, DID STOP");
        
    });
    
}


- (void)screenRecorder:(CSScreenRecorder *)recorder recordingTimeChanged:(NSTimeInterval)recordingTime
{// time in seconds since start of capture
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *string = [NSString stringWithFormat:@"%02li:%02li:%02li",
                            lround(floor(recordingTime / 3600.)) % 100,
                            lround(floor(recordingTime / 60.)) % 60,
                            lround(floor(recordingTime)) % 60];
        
        //        [self.mpView setHidden:NO];
        
        NSLog(@"KDD, DID SET TIME");
    });
    
}


@end
