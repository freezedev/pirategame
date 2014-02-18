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

-(void) onBackgroundTouch:(SPTouchEvent*) event
{
    SPTouch *touch = [[event touchesWithTarget:self] anyObject];
    
    if (touch) {
        [_pirateShip moveToX:touch.globalX andY:touch.globalY];
    }
}

-(void) onShipTap:(SPTouchEvent*) event
{
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
    
    if (touch) {
        if (touch.tapCount == 1) {
            [_pirateShip stop];
        } else if (touch.tapCount == 2) {
            [_pirateShip shoot];
        }
    }
}

-(id) init
{
    if ((self = [super init])) {
        SPImage *background = [SPImage imageWithTexture:[Assets texture:@"water.png"]];
        background.x = (Sparrow.stage.width - background.width) / 2;
        background.y = (Sparrow.stage.height - background.height) / 2;
        
        _pirateShip = [[Ship alloc] initWithType:ShipPirate];
        _pirateShip.x = (Sparrow.stage.width - _pirateShip.width) / 2;
        _pirateShip.y = (Sparrow.stage.height - _pirateShip.height) / 2;
        
        Ship *ship = [[Ship alloc] init];
        ship.x = 100;
        ship.y = 100;
        
        SPTween *shipTween = [SPTween tweenWithTarget:ship time:4.0f transition:SP_TRANSITION_EASE_IN_OUT];
        [shipTween animateProperty:@"y" targetValue:250];
        shipTween.repeatCount = 5;
        shipTween.reverse = YES;
        shipTween.delay = 2.0f;
        
        [Sparrow.juggler addObject:shipTween];
        
        [background addEventListener:@selector(onBackgroundTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [_pirateShip addEventListener:@selector(onShipTap:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addChild:background];
        [self addChild:ship];
        [self addChild:_pirateShip];
    }
    
    return self;
}

@end
