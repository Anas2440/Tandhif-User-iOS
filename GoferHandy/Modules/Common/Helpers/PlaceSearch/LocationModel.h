/**
 * LocationModel.h
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

@interface LocationModel : NSObject

@property (nonatomic,strong)    NSString *searchedAddress;
@property (nonatomic,strong)    NSString *longitude;
@property (nonatomic,strong)    NSString *latitude;
@property (nonatomic, strong)   CLLocation *currentLocation;

@end
