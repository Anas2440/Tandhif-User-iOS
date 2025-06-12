//
//  Gofer-Bridging-Header.h
//  GoferHandy
//
//  Created by Maroofff  on 02/05/25.
//

#ifndef Gofer_Bridging_Header_h
#define Gofer_Bridging_Header_h

#include <ifaddrs.h> // Getting User ip Address

#import "BIZProgressViewHandler.h"
#import "BIZCircularProgressView.h"
#import "GooglePlacesDataLoader.h"
#import "PlaceDetailsAnnotation.h"
#import "CurrentLocationAnnotation.h"
#import "GoogleKeys.h"
#import "LocationModel.h"
#import "ARCarMovement.h"



#pragma mark - LIST OF FIREBASE CHILD REF NAMES
//*******************************************
//#define     FIR_CHAT_REF_NAME          @"driver_rider_trip_chats"



#pragma mark LIST OF CONSTANTS
//********************************************
#define           USER_FIREBASE_TOKEN       @"firebase_token"
#define           USER_FIREBASE_AUTH        @"firebase_auth"
#define           "access_token"         @"access_token"
#define           "Promo_Code"           @"Promo_Code"
#define           CEO_FacebookAccessToken   @"FBAcessToken"
#define           USER_FULL_NAME            @"full_name"
#define           USER_FIRST_NAME           @"first_name"
#define           USER_LAST_NAME            @"last_name"
#define           USER_GENDER               @"gender"
#define           USER_IMAGE_THUMB          @"user_image"
#define           USER_FB_ID                @"user_fbid"
#define           USER_ID                  @"user_id"
#define           USER_EMAIL_ID             @"user_email_id"
#define           USER_DIAL_CODE            @"dial_code"
#define           USER_COUNTRY_CODE         @"user_country_code"
#define           USER_PAYPAL_EMAIL_ID      @"paypal_email_id"
#define           USER_STRIPE_APP_KEY       @"payment_stride_app_key"
#define           "work_loc"        @"work_loc"
#define           "home_loc"        @"home_loc"
#define           "work_latitude"        @"work_latitude"
#define           "work_longitude"       @"work_longitude"
#define           "wallet_amount"        @"wallet_amount"
#define           USER_PAYMENT_METHOD       @"payment_method"
#define           "selectwallet"        @"selectwallet"
#define           USER_PAYPAL_APP_ID        @"paypal_app_id"
#define           USER_PAYPAL_MODE          @"paypal_mode"
#define           "home_latitude"        @"home_latitude"
#define           "home_longitude"       @"home_longitude"
#define           "device_token"         @"device_token"
#define           LICENSE_BACK              @"licence_back"
#define           LICENSE_FRONT             @"licence_front"
#define           LICENSE_INSURANCE         @"licence_insurance"
#define           LICENSE_RC                @"licence_rc"
#define           LICENSE_PERMIT            @"licence_permit"
#define           "user_currency_org"         @"user_currency_org"
#define           "user_currency_symbol_org"  @"user_currency_symbol_org"
#define           USER_PHONE_NUMBER         @"phonenumber"
#define           USER_TYPE                 @"Rider"
#define           DEVICE_LANGUAGE           @"device_default_language"
#define           "user_credit_card_sufix"           @"user_credit_card_sufix"
#define           "user_credit_card_brand"           @"user_credit_card_brand"
#define           PAYPAL_WALLET_PAYMENT     @"user_paypal_default_wallet_payment"
#define           "user_stripe_default_wallet_payment"     @"user_stripe_default_wallet_payment"
#define           TRIP_DRIVER_THUMB_URL      @"trip_driver_thumb_url"
#define           TRIP_DRIVER_NAME           @"trip_driver_name"
#define           TRIP_DRIVER_RATING         @"trip_driver_rating"
//#define           "user_currency_symbol_org"_splash  @"user_currency_symbol_org_splash"
//#define           "user_currency_org"_splash         @"user_currency_org_splash"


#define           USER_START_DATE           @"user_start_date"
#define           USER_END_DATE             @"user_end_date"
#define           USER_LONGITUDE            @"user_longitude"
#define           USER_LATITUDE             @"user_latitude"
#define           USER_LOCATION             @"user_location"
#define           NEXT_ICON_NAME            @"I"

#endif /* Gofer_Bridging_Header_h */
