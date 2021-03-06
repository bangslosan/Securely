//
//  PDKeychainBindingsController.h
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import <Foundation/Foundation.h>
#import "BCPDKeychainBindings.h"


@interface BCPDKeychainBindingsController : NSObject {
@private
    BCPDKeychainBindings *_keychainBindings;
    NSMutableDictionary *_valueBuffer;
    NSString* _serviceName;
    NSString* _accessGroup;
}

+ (BCPDKeychainBindingsController *)sharedKeychainBindingsController;
- (BCPDKeychainBindings *) keychainBindings;

- (id)values;    // accessor object for PDKeychainBindings values. This property is observable using key-value observing.

- (NSString*)stringForKey:(NSString*)key;
- (BOOL)storeString:(NSString*)string forKey:(NSString*)key;
- (void) setServiceName:(NSString*)newValue;
- (void) setAccessGroup:(NSString*)newValue;
- (NSMutableArray *)allKeys;
-(void) removeAllItems;
@end

