/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#pragma once
#import <Foundation/Foundation.h>

#import <Sinch/SINExport.h>
#import <Sinch/SINIceCandidateTransportType.h>

/**
 * This class contains the WebRTC connected configuration for Sinch calls.
 */
@interface SINWebRtcCallConfiguration : NSObject

@property (atomic, assign) SINIceCandidateTransportType iceCandidateTransportType;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIceCandidateTransportType:(SINIceCandidateTransportType)iceCandidateTransportType;

@end
