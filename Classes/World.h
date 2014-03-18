//
//  World.h
//  PirateGame
//
//  Created by Johannes Stein on 18/03/14.
//
//

#import <Foundation/Foundation.h>

@interface World : NSObject

+(int) level;
+(void) setLevel:(int)value;

+(int) levelMax;

+(int) gold;
+(void) setGold:(int)value;

+(int) hitpoints;
+(void) setHitpoints:(int)value;

+(int) damage;
+(void) setDamage:(int)value;

+(void) reset;
+(void) log;

@end
