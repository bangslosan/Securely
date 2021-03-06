/**
 * Securely Titanium Security Project
 * Copyright (c) 2009-2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingSecurelyStringCryptoProxy.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+CommonCrypto.h"

@implementation BencodingSecurelyStringCryptoProxy

-(NSString *)AESEncrypt:(id)args
{
    ENSURE_ARG_COUNT(args,2);
    NSString* password = [TiUtils stringValue:[args objectAtIndex:0]];
    //DebugLog(@"password: %@", password);
    NSString* plainText = [TiUtils stringValue:[args objectAtIndex:1]];
    //DebugLog(@"plainText: %@", plainText);
    
    NSData *encryptedData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    NSString *encryptedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    
    return encryptedString;
}

-(NSString *)AESDecrypt:(id)args
{
    ENSURE_ARG_COUNT(args,2);

    NSString* password = [TiUtils stringValue:[args objectAtIndex:0]];
    //DebugLog(@"password: %@", password);
    NSString* encryptedText = [TiUtils stringValue:[args objectAtIndex:1]];
    //DebugLog(@"encryptedText: %@", encryptedText);
        
    NSData *encryptedData = [NSData base64DataFromString:encryptedText];
    
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    
    NSString *plainText =  [[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] autorelease];
    
    return plainText;
    
}

-(NSString *)DESEncrypt:(id)args
{
    ENSURE_ARG_COUNT(args,2);
    NSString* password = [TiUtils stringValue:[args objectAtIndex:0]];
    //DebugLog(@"password: %@", password);
    NSString* plainText = [TiUtils stringValue:[args objectAtIndex:1]];
    //DebugLog(@"plainText: %@", plainText);
    
    NSData *encryptedData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] DESEncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    
    NSString *encryptedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    
    return encryptedString;
}

-(NSString *)DESDecrypt:(id)args
{
    ENSURE_ARG_COUNT(args,2);
    
    NSString* password = [TiUtils stringValue:[args objectAtIndex:0]];
    //DebugLog(@"password: %@", password);
    NSString* encryptedText = [TiUtils stringValue:[args objectAtIndex:1]];
    //DebugLog(@"encryptedText: %@", encryptedText);
    
    NSData *encryptedData = [NSData base64DataFromString:encryptedText];
    
    NSData *decryptedData = [encryptedData decryptedDESDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    
    NSString *plainText =  [[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding]autorelease];
    
    return plainText;
    
}
-(NSString *) sha256:(id)args
{
    ENSURE_ARG_COUNT(args,1);
    NSString* plainText = [TiUtils stringValue:[args objectAtIndex:0]];
    NSData* data = [[plainText dataUsingEncoding:NSUTF8StringEncoding]SHA256Hash];
    NSString *hashText = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return hashText;
}

-(NSString *) toHex:(id)args
{
    ENSURE_ARG_COUNT(args,1);
    NSString* plainText = [TiUtils stringValue:[args objectAtIndex:0]];
    NSUInteger len = [plainText length];
    unichar *chars = malloc(len * sizeof(unichar));
    [plainText getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendFormat:@"%02x", chars[i]];
    }
    free(chars);
    
    return [hexString autorelease];
}

-(NSString *) fromHex:(id)args
{
    ENSURE_ARG_COUNT(args,1);
    NSString* text = [TiUtils stringValue:[args objectAtIndex:0]];
    NSMutableData *stringData = [[[NSMutableData alloc] init] autorelease];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [text length] / 2; i++) {
        byte_chars[0] = [text characterAtIndex:i*2];
        byte_chars[1] = [text characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    
    return [[[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding] autorelease];
}

@end
