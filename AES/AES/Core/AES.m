
//
//  WMAES.m
//  Pods
//
//  Created by WuShiHai on 03/03/2017.
//
//

#import "AES.h"
#import <CommonCrypto/CommonCryptor.h>

NSString *const kDefaultInitVector = @"00000000000000000000000000000000";

size_t const kDefaultKeySize = kCCKeySizeAES128;

@implementation AES

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key initialVector:(NSString *)initialVector keySize:(size_t)keySize{
    
    return [self AES:content
                 key:key
       initialVector:initialVector
             keySize:keySize
           operation:kCCEncrypt];
}

+ (NSString *)decryptAES:(NSString *)content
                     key:(NSString *)key
           initialVector:(NSString *)initialVector
                 keySize:(size_t)keySize{
    return [self AES:content
                 key:key
       initialVector:initialVector
             keySize:keySize
           operation:kCCDecrypt];
}

+ (NSString *)AES:(NSString *)content
              key:(NSString *)key
    initialVector:(NSString *)initialVector
          keySize:(size_t)keySize
        operation:(CCOperation)operation{
    
    if (content == nil) {
        return nil;
    }
    
    NSAssert(key.length > 0, @"%s: error key",__func__);
    NSAssert(keySize == kCCKeySizeAES128 || keySize == kCCKeySizeAES192 || keySize == kCCKeySizeAES256, @"%s: error keySize",__func__);
    NSAssert(operation == kCCEncrypt || operation == kCCDecrypt, @"%s: error operation",__func__);
    
    NSData *contentData = nil;
    if (operation == kCCEncrypt) {
        contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    }else if (operation == kCCDecrypt){
        contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    NSUInteger dataLength = contentData.length;
    
    const void *keyPtr = [self bytesFromString:key];
    const void *ivPtr = [self bytesFromString:initialVector?:kDefaultInitVector];
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          keySize,
                                          ivPtr,
                                          contentData.bytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        if (operation == kCCEncrypt) {
            return [[NSData dataWithBytesNoCopy:operationBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        }else if (operation == kCCDecrypt){
            return [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:operationBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
        }
    }
    
    free(operationBytes);
    
    return nil;
}

//@"ECD"->0xECD
+ (const void *)bytesFromString:(NSString*)content{
    
    NSUInteger size = content.length/2;
    
    NSData *keyHexData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char keyBytes[16];
    unsigned char *hex = (uint8_t *)keyHexData.bytes;
    
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i=0; i<size; i++) {
        byte_chars[0] = hex[i*2];
        byte_chars[1] = hex[(i*2)+1];
        keyBytes[i] = strtol(byte_chars, NULL, (int)size);
    }
    NSData *keyData = [NSData dataWithBytes:keyBytes length:size];
    
    return keyData.bytes;
}

@end
