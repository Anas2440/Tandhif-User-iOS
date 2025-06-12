/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Call End Cause

/// Describes possbile causes for call end
typedef NS_ENUM(NSInteger, SINCallEndCause) {
  SINCallEndCauseNone = 0,
  SINCallEndCauseTimeout = 1,
  SINCallEndCauseDenied = 2,
  SINCallEndCauseNoAnswer = 3,
  SINCallEndCauseError = 4,
  SINCallEndCauseHungUp = 5,
  SINCallEndCauseCanceled = 6,
  SINCallEndCauseOtherDeviceAnswered = 7,
  SINCallEndCauseInactive = 8,
  SINCallEndCauseVoIPCallDetected = 9,
  SINCallEndCauseGSMCallDetected = 10
};

#pragma mark - SINCallDetails

/**
 * The SINCallDetails holds metadata about a call (SINCall).
 */
@protocol SINCallDetails <NSObject>

/**
 * The start time of the call.
 *
 * Before the call has started, the value of the startedTime property is `nil`.
 */
@property (atomic, readonly, strong) NSDate *startedTime;

/**
 * The time where the call did progress, if it reached progressing state.
 *
 * Before the call has reached progressing state, the value of the progressedTime property is `nil`.
 */
@property (atomic, readonly, strong) NSDate *progressedTime;

/**
 * The time where the call did ring, if it reached ringing state.
 *
 * Before the call has reached ringing state, the value of the rungTime property is `nil`.
 */
@property (atomic, readonly, strong) NSDate *rungTime;

/**
 * The time where the call was answered, if it reached answered state.
 *
 * Before the call has reached answered state, the value of the answeredTime property is `nil`.
 */
@property (atomic, readonly, strong) NSDate *answeredTime;

/**
 * The time at which the call was established, if it reached established state.
 *
 * Before the call has reached established state, the value of the establishedTime property is `nil`.
 */
@property (atomic, readonly, strong) NSDate *establishedTime;

/**
 * The end time of the call.
 *
 * Before the call has ended, the value of the endedTime property is `nil`.
 */
@property (atomic, readonly, strong) NSDate *endedTime;

/**
 * Holds the cause of why a call ended, after it has ended. It may be one
 * of the following:
 *
 *  - `SINCallEndCauseNone`
 *  - `SINCallEndCauseTimeout`
 *  - `SINCallEndCauseDenied`
 *  - `SINCallEndCauseNoAnswer`
 *  - `SINCallEndCauseError`
 *  - `SINCallEndCauseHungUp`
 *  - `SINCallEndCauseCanceled`
 *  - `SINCallEndCauseOtherDeviceAnswered`
 *  - `SINCallEndCauseInactive`
 *  - `SINCallEndCauseVoIPCallDetected`
 *  - `SINCallEndCauseGSMCallDetected`
 *
 * If the call has not ended yet, the value is `SINCallEndCauseNone`.
 */
@property (atomic, readonly) SINCallEndCause endCause;

/**
 * If the end cause is error, then this property contains an error object
 * that describes the error.
 *
 * If the call has not ended yet or if the end cause is not an error,
 * the value of this property is `nil`.
 */
@property (atomic, readonly, strong) NSError *error;

/**
 * Hint that indicates if video is offered in the call.
 */
@property (atomic, readonly, getter=isVideoOffered) BOOL videoOffered;

@end
