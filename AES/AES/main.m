//
//  main.m
//  AES
//
//  Created by WuShiHai on 07/03/2017.
//  Copyright © 2017 ws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AES.h"

void AESExample();
void testAES();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        AESExample();
        testAES();
    }
    return 0;
}


void AESExample(){
    
    NSString *test = [AES encryptAES:@"I'm AES" key:@"447C54BE3ACDFAF2E131B7657180D5AA" initialVector:nil keySize:kWMKeySizeAES128];
    NSString *deTest = [AES decryptAES:test key:@"447C54BE3ACDFAF2E131B7657180D5AA" initialVector:nil keySize:kWMKeySizeAES128];
    NSLog(@"%s:%@",__func__,deTest);
    
}

void testAES(){
    NSString *deTest = [AES decryptAES:@"HoP38q0t30OXkI1dEesILQ==" key:@"4CE729B454CBE5DB751140EE2A3C3C44" initialVector:@"1EB526F904BE7EBDAF046ED75B2FFDC7" keySize:kWMKeySizeAES128];
    NSLog(@"%s:%@",__func__,deTest);
}
