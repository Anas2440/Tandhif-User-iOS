/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Sinch/SINExport.h>

/**
 * This enumeration categorizes the possible transport types of the ICE candidates used when creating the peer
 * connection. By using a value different than `SINIceCandidateTransportTypeAll`, it is possible to filter out
 * some of the generated ICE candidates.
 */
typedef NS_ENUM(NSInteger, SINIceCandidateTransportType) {
  /**
   * Allows to use only ICE candidates that are using a relay server
   * (such as a TURN server) to route the traffic.
   */
  SINIceCandidateTransportTypeRelay = 0,
  /**
   * Filters all the `HOST` ICE candidates out.
   * This can be used to improve privacy as no local IP addresses of device (i.e. the ones that are not accessible by
   * STUN server or other peer) are exposed.
   */
  SINIceCandidateTransportTypeNoHost = 1,
  /**
   * Allows to use every generated ICE candidate. This is the default value.
   */
  SINIceCandidateTransportTypeAll = 2
};
