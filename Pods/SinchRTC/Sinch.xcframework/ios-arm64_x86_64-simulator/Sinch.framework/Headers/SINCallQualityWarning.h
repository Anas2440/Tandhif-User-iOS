/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#pragma once
#import <Foundation/Foundation.h>

#import <Sinch/SINExport.h>

typedef NS_ENUM(NSInteger, SINCallQualityWarningEventType) {
  SINCallQualityWarningEventTypeTrigger,
  SINCallQualityWarningEventTypeRecover
};

typedef NS_ENUM(NSInteger, SINMediaStreamType) {
  SINMediaStreamTypeAudio,
  SINMediaStreamTypeVideo,
  SINMediaStreamTypeNone
};

typedef NS_ENUM(NSInteger, SINSourceStreamType) {
  SINSourceStreamTypeInbound,
  SINSourceStreamTypeOutbound,
  SINSourceStreamTypeNone
};

@protocol SINCallQualityWarningEvent <NSObject>
@property (atomic, readonly) NSString *name;
@property (atomic, readonly) SINCallQualityWarningEventType type;
@property (atomic, readonly) SINMediaStreamType mediaStreamType;
@property (atomic, readonly) SINSourceStreamType sourceStreamType;
@end

SIN_EXPORT
@interface SINMissingMediaStreamWarningEvent : NSObject <SINCallQualityWarningEvent>
- (instancetype)init NS_UNAVAILABLE;
@end

SIN_EXPORT
@interface SINHighInboundJitterWarningEvent : NSObject <SINCallQualityWarningEvent>
- (instancetype)init NS_UNAVAILABLE;
@end

SIN_EXPORT
@interface SINHighInboundPacketLossWarningEvent : NSObject <SINCallQualityWarningEvent>
- (instancetype)init NS_UNAVAILABLE;
@end

SIN_EXPORT
@interface SINHighRemoteInboundRttWarningEvent : NSObject <SINCallQualityWarningEvent>
- (instancetype)init NS_UNAVAILABLE;
@end

SIN_EXPORT
@interface SINConstantAudioLevelWarningEvent : NSObject <SINCallQualityWarningEvent>
- (instancetype)init NS_UNAVAILABLE;
@end

SIN_EXPORT
@interface SINZeroAudioLevelWarningEvent : NSObject <SINCallQualityWarningEvent>
- (instancetype)init NS_UNAVAILABLE;
@end

SIN_EXPORT
@interface SINLowOSOutputVolumeLevelWarningEvent : NSObject <SINCallQualityWarningEvent>
- (instancetype)init NS_UNAVAILABLE;
@end
