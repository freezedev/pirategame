//
//  World.m
//  PirateGame
//
//  Created by Johannes Stein on 18/03/14.
//
//

#import "World.h"
#import "Assets.h"

@implementation World

static int level;
static int levelMax;
static int gold;
static int hitpoints;
static int damage;

+(int) level
{
    return level;
}

+(int) levelMax
{
    return levelMax;
}

+(void) setLevel:(int)value
{
    level = value;
}

+(int) gold
{
    return gold;
}

+(void) setGold:(int)value
{
    gold = value;
}

+(int) hitpoints
{
    return hitpoints;
}

+(void) setHitpoints:(int)value
{
    hitpoints = value;
}

+(int) damage
{
    return damage;
}

+(void) setDamage:(int)value
{
    damage = value;
}

+(void) reset
{
    level = 1;
    levelMax = 3;
    gold = 200;
    damage = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"damage"] intValue];
    hitpoints = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"hitpoints"] intValue];
}

+(void) log
{
    NSLog(@"Level %d of %d", level, levelMax);
    NSLog(@"Gold: %d", gold);
    NSLog(@"Players' hit points: %d", hitpoints);
    NSLog(@"Players' damage: %d", damage);
}

+(NSDictionary *) serialize
{
    return @{
             @"level": [NSNumber numberWithInt:level],
             @"gold": [NSNumber numberWithInt:gold],
             @"damage": [NSNumber numberWithInt:damage],
             @"hitpoints": [NSNumber numberWithInt:hitpoints]
    };
}

+(void) deserialize: (NSDictionary *) dict
{
    level = [(NSNumber *) dict[@"level"] intValue];
    gold = [(NSNumber *) dict[@"gold"] intValue];
    damage = [(NSNumber *) dict[@"damage"] intValue];
    hitpoints = [(NSNumber *) dict[@"hitpoints"] intValue];
}

@end
