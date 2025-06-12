/**
 * CurrentLocationAnnotation.m
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 *  
 * @link http://trioangle.com
 */

#import "CurrentLocationAnnotation.h"

@interface CurrentLocationAnnotation()

@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@end

@implementation CurrentLocationAnnotation 

@synthesize currentLocation = _currentLocation;

- (id)initWithLocation:(CLLocation *)currentLocation {
    if (self = [super init]) {
        self.currentLocation = currentLocation;
    }
    return self;
}

- (NSString *)title {
    return @"Current Location";
}

- (CLLocationCoordinate2D)coordinate {
    return self.currentLocation.coordinate;
}

@end
