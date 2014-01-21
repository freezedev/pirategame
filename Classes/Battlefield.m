//
//  Battlefield.m
//  PirateGame
//
//  Created by Johannes Stein on 20/01/14.
//
//

#import "Battlefield.h"
#import "Assets.h"

@implementation Battlefield

-(id) init
{
    if ((self = [super init])) {
        SPImage *background = [SPImage imageWithTexture:[Assets texture:@"water.png"]];
        background.x = (Sparrow.stage.width - background.width) / 2;
        background.y = (Sparrow.stage.height - background.height) / 2;
        
        SPImage *pirateShip = [SPImage imageWithTexture:[Assets texture:@"ship_pirate.png"]];
        pirateShip.x = (Sparrow.stage.width - pirateShip.width) / 2;
        pirateShip.y = (Sparrow.stage.height - pirateShip.height) / 2;
        
        SPImage *ship = [SPImage imageWithTexture:[Assets texture:@"ship.png"]];
        ship.x = 100;
        ship.y = 100;
        
        [self addChild:background];
        [self addChild:pirateShip];
        [self addChild:ship];
    }
    
    return self;
}

@end
