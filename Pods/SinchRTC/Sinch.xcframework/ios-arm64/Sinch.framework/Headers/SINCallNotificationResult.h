/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>

/**
 * SINCallNotificationResult is used to indicate the result of `-[SINClient relayPushNotificationPayload:]`
 * when the Sinch-specific payload in the notification represents an incoming
 * call.
 *
 * One example of a scenario where SINCallNotificationResult is when a user
 * have been attempted to be reached, but not acted on the notification directly.
 * In that case, the notification result object can indicate that the
 * notification is too old (`isTimedOut`), and also contains the `remoteUserId`
 * which can be used for display purposes.
 *
 **/

@protocol SINCallNotificationResult <NSObject, NSCopying>

/** Indicates whether the notification has timed out or not. */
@property (atomic, readonly, assign) BOOL isTimedOut;

/** Identifier of the user from which the call represented by the notification originated. */
@property (atomic, readonly, copy) NSString *remoteUserId;

/** A unique identifier pertaining to the call */
@property (atomic, readonly, copy) NSString *callId;

/**
 * Hint that indicates if video is offered in the call.
 */
@property (atomic, readonly, getter=isVideoOffered) BOOL videoOffered;

/**
 * Return headers set by the caller when initiating the call.
 *
 * @see - [SINCallClient callUserWithId: headers:].
 */
@property (atomic, readonly, copy) NSDictionary *headers;

@end
