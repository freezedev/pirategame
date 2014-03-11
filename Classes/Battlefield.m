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

-(void) onButtonPause:(SPTouchEvent *)event
{

}

-(void) onButtonResume:(SPTouchEvent *)event
{

}

-(void) onEnterFrame:(SPEvent *)event
{
    SPRectangle *enemyShipBounds = [_enemyShip boundsInSpace:self];
    SPRectangle *ball1 = [_pirateShip.cannonBallLeft boundsInSpace:self];
    SPRectangle *ball2 = [_pirateShip.cannonBallRight boundsInSpace:self];
    
    if ([enemyShipBounds intersectsRectangle:ball1] || [enemyShipBounds intersectsRectangle:ball2]) {
        if (_pirateShip.cannonBallLeft.visible || _pirateShip.cannonBallRight.visible) {
            [_pirateShip abortShooting];
            [_enemyShip hit];
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
        _pirateShip.x = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"battlefield"][@"pirate"][@"x"] floatValue];
        _pirateShip.y = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"battlefield"][@"pirate"][@"y"] floatValue];
        
        _enemyShip = [[Ship alloc] init];
        _enemyShip.x = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"battlefield"][@"enemy"][@"x"] floatValue];
        _enemyShip.y = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"battlefield"][@"enemy"][@"y"] floatValue];
        
        SPTween *shipTween = [SPTween tweenWithTarget:_enemyShip time:4.0f transition:SP_TRANSITION_EASE_IN_OUT];
        [shipTween animateProperty:@"y" targetValue:250];
        shipTween.repeatCount = 5;
        shipTween.reverse = YES;
        shipTween.delay = 2.0f;
        
        
        SPButton *buttonPause = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"button_pause@4x"]];
        SPButton *buttonResume = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"button_play@4x"]];
        
        buttonPause.x = Sparrow.stage.width - buttonPause.width - 4.0f;
        buttonPause.y = 4.0f;
        
        buttonResume.x = buttonPause.x;
        buttonResume.y = buttonPause.y;
        
        buttonResume.visible = NO;
        
        [buttonPause addEventListener:@selector(onButtonPause:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [buttonResume addEventListener:@selector(onButtonResume:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [Sparrow.juggler addObject:shipTween];
        
        [background addEventListener:@selector(onBackgroundTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [_pirateShip addEventListener:@selector(onShipTap:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        
        [self addChild:background];
        [self addChild:_enemyShip];
        [self addChild:_pirateShip];
        
        [self addChild:buttonPause];
        [self addChild:buttonResume];
    }
    
    return self;
}

@end
