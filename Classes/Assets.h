//
//  Assets.h
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import <Foundation/Foundation.h>

@interface Assets : NSObject

+(SPTexture *) texture:(NSString *)filename;
+(SPSound *) sound:(NSString *)filename;
+(NSString *) plainText:(NSString *)filename;
+(NSDictionary *) dictionaryFromJSON:(NSString *)filename;

@end
