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
        [Sparrow.juggler removeObjectsWithTarget:_pirateShip];
        
        float targetX = touch.globalX - (_pirateShip.width / 2);
        float targetY = touch.globalY - (_pirateShip.height / 2);
        
        float distanceX = fabsf(_pirateShip.x - targetX);
        float distanceY = fabsf(_pirateShip.y - targetY);
        
        float penalty = (distanceX + distanceY) / 80.0f;
        
        float shipInitial = 0.25f + penalty;
        
        float speedX = shipInitial + (distanceX / Sparrow.stage.width) * penalty * penalty;
        float speedY = shipInitial + (distanceY / Sparrow.stage.height) * penalty * penalty;
        
        SPTween *tweenX = [SPTween tweenWithTarget:_pirateShip time:speedX];
        SPTween *tweenY = [SPTween tweenWithTarget:_pirateShip time:speedY];
        
        
        [tweenX animateProperty:@"x" targetValue:targetX];
        [tweenY animateProperty:@"y" targetValue:targetY];
        
        [Sparrow.juggler addObject:tweenX];
        [Sparrow.juggler addObject:tweenY];
    }
}

-(void) onShipStop:(SPTouchEvent*) event
{
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
    
    if (touch) {
        [Sparrow.juggler removeObjectsWithTarget:_pirateShip];
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
        
        SPImage *ship = [SPImage imageWithTexture:[Assets texture:@"ship.png"]];
        ship.x = 100;
        ship.y = 100;
        
        SPTween *shipTween = [SPTween tweenWithTarget:ship time:4.0f transition:SP_TRANSITION_EASE_IN_OUT];
        [shipTween animateProperty:@"y" targetValue:250];
        shipTween.repeatCount = 5;
        shipTween.reverse = YES;
        shipTween.delay = 2.0f;
        
        [Sparrow.juggler addObject:shipTween];
        
        
        [background addEventListener:@selector(onBackgroundTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [_pirateShip addEventListener:@selector(onShipStop:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addChild:background];
        [self addChild:ship];
        [self addChild:_pirateShip];
    }
    
    return self;
}

@end
