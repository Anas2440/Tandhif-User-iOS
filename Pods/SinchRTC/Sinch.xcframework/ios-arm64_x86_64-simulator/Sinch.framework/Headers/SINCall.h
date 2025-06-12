/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>

@protocol SINCallDelegate;
@protocol SINCallDetails;
@protocol SINCallQualityWarningEvent;

#pragma mark - Call State

/// Describes states call can be in
typedef NS_ENUM(NSInteger, SINCallState) {
  SINCallStateInitiating = 0,
  SINCallStateProgressing,  // only applicable to outgoing calls
  SINCallStateRinging,      // only applicable to outgoing calls
  SINCallStateAnswered,
  SINCallStateEstablished,
  SINCallStateEnded
};

#pragma mark - Call Direction

/// Describes direction of the call
typedef NS_ENUM(NSInteger, SINCallDirection) { SINCallDirectionIncoming = 0, SINCallDirectionOutgoing };

#pragma mark - SINCall

/**
 * The SINCall represents a call.
 */
@protocol SINCall <NSObject>

/**
 * The object that acts as the delegate of the call.
 *
 * The delegate object handles call state change events and must
 * adopt the SINCallDelegate protocol.
 *
 * @see `SINCallDelegate`
 */
@property (atomic, weak) id<SINCallDelegate> delegate;

/** String that is used as an identifier for this particular call. */
@property (atomic, readonly, copy) NSString *callId;

/** The id of the remote participant in the call. */
@property (atomic, readonly, copy) NSString *remoteUserId;

/**
 * Metadata about a call, such as start time.
 *
 * When a call has ended, the details object contains information
 * about the reason the call ended and error information if the
 * call ended unexpectedly.
 *
 * @see `SINCallDetails`
 */
@property (atomic, readonly, strong) id<SINCallDetails> details;

/**
 * The state the call is currently in. It may be one of the following:
 *
 *  - `SINCallStateInitiating`
 *  - `SINCallStateProgressing`
 *  - `SINCallStateRinging`
 *  - `SINCallStateAnswered`
 *  - `SINCallStateEstablished`
 *  - `SINCallStateEnded`
 *
 * Initially, the call will be in the `SINCallStateInitiating` state.
 */
@property (atomic, readonly, assign) SINCallState state;

/**
 * The direction of the call. It may be one of the following:
 *
 *  - `SINCallDirectionIncoming`
 *  - `SINCallDirectionOutgoing`
 */
@property (atomic, readonly, assign) SINCallDirection direction;

/**
 * Call headers.
 *
 * Any application-defined call meta-data can be passed via headers.
 *
 * E.g. a human-readable "display name / username" can be convenient
 * to send as an application-defined header.
 *
 * - IMPORTANT: If a call is initially received via remote push
 * notifications, headers may not be immediately available due to
 * push payload size limitations (especially pre- iOS 8).
 * If it's not immediately available, it will be available after the
 * event callbacks `-[SINCallDelegate callDidProgress:]` or
 * `-[SINCallDelegate callDidEstablish:]` .
 *
 **/
@property (atomic, readonly) NSDictionary *headers;

/**
 * The user data property may be used to associate an arbitrary
 * contextual object with a particular instance of a call.
 */
@property (atomic, strong) id userInfo;

/** Answer an incoming call.
 */
- (void)answer;

/**
 * Ends the call, regardless of what state it is in. If the call is
 * an incoming call that has not yet been answered, the call will
 * be reported as denied to the caller.
 */
- (void)hangup;

/**
 * Sends a DTMF tone for tone dialing. (Only applicable for calls terminated
 * to PSTN (Publicly Switched Telephone Network)).
 *
 * @param key DTMF key must be in [0-9, #, *, A-D].
 *
 * @return YES if DTMF was sent correctly, NO otherwise
 */
- (BOOL)sendDTMF:(NSString *)key;

/**
 * Pause video track for this call
 */
- (void)pauseVideo;

/**
 * Start video track for this call
 */
- (void)resumeVideo;

@end

#pragma mark - SINCallDelegate

/**
 * The delegate of a SINCall object must adopt the SINCallDelegate
 * protocol. The required methods handle call state changes.
 *
  ### Call State Progression
 *
 * For a complete outgoing call, the delegate methods will be called
 * in the following order:
 *
 *  - `callDidProgress:`
 *  - `callDidRing:`
 *  - `callDidAnswer:`
 *  - `callDidEstablish:`
 *  - `callDidEnd:`
 *
 * For a complete incoming call, the delegate methods will be called
 * in the following order, after the client delegate method
 * `[SINClientDelegate client:didReceiveIncomingCall:]` has been called:
 *
 *  - `callDidAnswer:`
 *  - `callDidEstablish:`
 *  - `callDidEnd:`
 */
@protocol SINCallDelegate <NSObject>

@optional

/**
 * Tells the delegate that the call ended.
 *
 * The call has entered the `SINCallStateEnded` state.
 * This method is invoked on the queue specified via `-[Sinch setCallbackQueue:]`, which defaults to the main queue.
 *
 * @param call The call that ended.
 *
 * @see `SINCall`
 */
- (void)callDidEnd:(id<SINCall>)call;

/**
 * Tells the delegate that the outgoing call is progressing and a progress tone can be played.
 *
 * The call has entered the `SINCallStateProgressing` state.
 * This method is invoked on the queue specified via `-[Sinch setCallbackQueue:]`, which defaults to the main queue.
 *
 * @param call The outgoing call to the client on the other end.
 *
 * @see `SINCall`
 */
- (void)callDidProgress:(id<SINCall>)call;

/**
 * Tells the delegate that the B side received the call.
 *
 * The call has entered the `SINCallStateRinging` state.
 * This method is invoked on the queue specified via `-[Sinch setCallbackQueue:]`, which defaults to the main queue.
 *
 * @param call The outgoing call to the client on the other end.
 *
 * @see `SINCall`
 */
- (void)callDidRing:(id<SINCall>)call;

/**
 * Tells the delegate that the call was answered.
 *
 * The call has entered the `SINCallStateAnswered` state.
 * Note that it might take some time after this callback is invoked for media stream to connect.
 * This method is invoked on the queue specified via `-[Sinch setCallbackQueue:]`, which defaults to the main queue.
 *
 * @param call The call that was answered.
 *
 * @see `SINCall`
 */
- (void)callDidAnswer:(id<SINCall>)call;

/**
 * Tells the delegate that the call was established.
 *
 * This means both peers should be able to hear and communicate with each other. This callback ideally is invoked
 * shortly after [callDidAnswer], however for various reasons (e.g bad network conditions) it might take few seconds to
 * fully establish a connection after the call is answered. This method is invoked on the queue specified via `-[Sinch
 * setCallbackQueue:]`, which defaults to the main queue.
 *
 * @param call The call that was established.
 *
 * @see `SINCall`
 */
- (void)callDidEstablish:(id<SINCall>)call;

/**
 * Tells the delegate that a video track has been added to the call.
 * A delegate can use `SINVideoController` to manage rendering views.
 * This method is invoked on the queue specified via `-[Sinch setCallbackQueue:]`, which defaults to the main queue.
 *
 * @see `SINVideoController`
 */
- (void)callDidAddVideoTrack:(id<SINCall>)call;

/**
 * Tells the delegate that a video track has been paused in the call.
 * A delegate can use `SINVideoController` to manage rendering views.
 * This method is invoked on the queue specified via `-[Sinch setCallbackQueue:]`, which defaults to the main queue.
 *
 * @see `SINVideoController`
 */
- (void)callDidPauseVideoTrack:(id<SINCall>)call;

/**
 * Tells the delegate that a video track has been resumed in the call.
 * (A delegate can use `SINVideoController` to manage rendering views.)
 * This method is invoked on the queue specified via `-[Sinch setCallbackQueue:]`, which defaults to the main queue.
 *
 * @see `SINVideoController`
 */
- (void)callDidResumeVideoTrack:(id<SINCall>)call;

/**
 * Tells the delegate that the call emitted call quality warning event.
 *
 * This method is invoked on the queue specified via `-[Sinch setCallbackQueue:]`, which defaults to the main queue.
 *
 * @param call The call that emitted event.
 * @param event The event emitted during the call..
 *
 * @see `SINCall`
 */
- (void)call:(id<SINCall>)call didEmitCallQualityWarningEvent:(id<SINCallQualityWarningEvent>)event;

@end
