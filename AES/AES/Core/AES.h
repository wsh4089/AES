//
//  WMAES.h
//  Pods
//
//  Created by WuShiHai on 03/03/2017.
//
//

#import <Foundation/Foundation.h>

enum {
    kWMKeySizeAES128          = 16,
    kWMKeySizeAES192          = 24,
    kWMKeySizeAES256          = 32,
};

@interface AES : NSObject

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key initialVector:(NSString *)initialVector keySize:(size_t)keySize;
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key initialVector:(NSString *)initialVector keySize:(size_t)keySize;

@end
