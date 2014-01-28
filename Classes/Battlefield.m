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

-(void) onBackgroundTouch: (SPTouchEvent*) event
{
    SPTouch* touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
    
    if (touch) {
        SPTween* tweenX = [SPTween tweenWithTarget:_pirateShip time:2.0f];
        SPTween* tweenY = [SPTween tweenWithTarget:_pirateShip time:2.0f];
        
        
        [tweenX animateProperty:@"x" targetValue:touch.globalX - (_pirateShip.width / 2)];
        [tweenY animateProperty:@"y" targetValue:touch.globalY - (_pirateShip.height / 2)];
        
        [Sparrow.juggler addObject:tweenX];
        [Sparrow.juggler addObject:tweenY];
    }
}

-(id) init
{
    if ((self = [super init])) {
        SPImage *background = [SPImage imageWithTexture:[Assets texture:@"water.png"]];
        background.x = (Sparrow.stage.width - background.width) / 2;
        background.y = (Sparrow.stage.height - background.height) / 2;
        
        _pirateShip = [SPImage imageWithTexture:[Assets texture:@"ship_pirate.png"]];
        _pirateShip.x = (Sparrow.stage.width - _pirateShip.width) / 2;
        _pirateShip.y = (Sparrow.stage.height - _pirateShip.height) / 2;
        
        SPImage* ship = [SPImage imageWithTexture:[Assets texture:@"ship.png"]];
        ship.x = 100;
        ship.y = 100;
        
        [background addEventListener:@selector(onBackgroundTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addChild:background];
        [self addChild:_pirateShip];
        [self addChild:ship];
    }
    
    return self;
}

@end
