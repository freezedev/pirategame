//
//  PirateCove.m
//  PirateGame
//
//  Created by Johannes Stein on 20/01/14.
//
//

#import "PirateCove.h"
#import "Assets.h"

@implementation PirateCove

-(id) init
{
    if ((self = [super init])) {
        SPImage *background = [SPImage imageWithTexture:[Assets texture:@"cove.png"]];
        background.x = (Sparrow.stage.width - background.width) / 2;
        background.y = (Sparrow.stage.height - background.height) / 2;
        
        SPImage *pirateShip = [SPImage imageWithTexture:[Assets texture:@"ship_pirate.png"]];
        pirateShip.x = Sparrow.stage.width - pirateShip.width - 120;
        pirateShip.y = Sparrow.stage.height - pirateShip.height - 10;
        
        SPImage *house = [SPImage imageWithTexture:[Assets texture:@"house.png"]];
        house.x = 100;
        house.y = 100;
        
        SPImage *tavern = [SPImage imageWithTexture:[Assets texture:@"tavern.png"]];
        tavern.x = 220;
        tavern.y = 40;
        
        SPImage *weaponsmith = [SPImage imageWithTexture:[Assets texture:@"weaponsmith.png"]];
        weaponsmith.x = 350;
        weaponsmith.y = 130;
        
        [self addChild:background];
        [self addChild:pirateShip];
        [self addChild:house];
        [self addChild:tavern];
        [self addChild:weaponsmith];
    }
    
    return self;
}

@end
