/**
 * CurrentLocationAnnotation.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 *
 * @link http://trioangle.com
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CurrentLocationAnnotation : NSObject <MKAnnotation>

- (id)initWithLocation:(CLLocation *)currentLocation;

@end
