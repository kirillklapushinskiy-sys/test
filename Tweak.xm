#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

static BOOL FSHasExternalRoute(AVAudioSession *session) {
    AVAudioSessionRouteDescription *route = session.currentRoute;
    for (AVAudioSessionPortDescription *port in route.outputs) {
        NSString *type = port.portType;
        if ([type isEqualToString:AVAudioSessionPortHeadphones] ||
            [type isEqualToString:AVAudioSessionPortBluetoothA2DP] ||
            [type isEqualToString:AVAudioSessionPortBluetoothHFP] ||
            [type isEqualToString:AVAudioSessionPortBluetoothLE] ||
            [type isEqualToString:AVAudioSessionPortCarAudio] ||
            [type isEqualToString:AVAudioSessionPortAirPlay]) return YES;
    }
    return NO;
}

static void FSForceSpeaker(AVAudioSession *session) {
    if (!session) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (FSHasExternalRoute(session)) return;
        NSError *error = nil;
        BOOL result =
            [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        if (!result && error)
            NSLog(@"[ForceSpeaker] speaker override failed: %@", error);
    });
}

%hook AVAudioSession
- (BOOL)setActive:(BOOL)active error:(NSError **)error {
    BOOL result = %orig(active, error);
    if (active && result) {
        AVAudioSession *session = (AVAudioSession *)self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{ FSForceSpeaker(session); });
    }
    return result;
}
- (BOOL)setCategory:(AVAudioSessionCategory)category
               mode:(AVAudioSessionMode)mode
            options:(AVAudioSessionCategoryOptions)options
              error:(NSError **)error {
    BOOL result = %orig(category, mode, options, error);
    if (result && [category isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
        AVAudioSession *session = (AVAudioSession *)self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{ FSForceSpeaker(session); });
    }
    return result;
}
%end
