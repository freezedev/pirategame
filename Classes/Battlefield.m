//
//  Battlefield.m
//  PirateGame
//
//  Created by Johannes Stein on 20/01/14.
//
//

#import "Battlefield.h"
#import "Assets.h"

#import "SceneDirector.h"

@implementation Battlefield

-(void) setPaused:(BOOL)paused
{
    _paused = paused;
    
    _buttonResume.visible = _paused;
    _buttonPause.visible = !_paused;
    
    _background.touchable = !_paused;
    
    _pirateShip.paused = _paused;
    _enemyShip.paused = _paused;
}

-(BOOL) getPaused
{
    return _paused;
}


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
    self.paused = YES;
}

-(void) onButtonResume:(SPTouchEvent *)event
{
    self.paused = NO;
}

-(void) onEnterFrame:(SPEnterFrameEvent *)event
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
    
    double passedTime = event.passedTime;
    
    [_enemyShip advanceTime:passedTime];
    [_pirateShip advanceTime:passedTime];
    
    if (!self.paused) {
        [_juggler advanceTime:passedTime];
    }
}

-(id) init
{
    if ((self = [super init])) {
        self.paused = NO;
        
        _background = [SPImage imageWithTexture:[Assets texture:@"water.png"]];
        _background.x = (Sparrow.stage.width - _background.width) / 2;
        _background.y = (Sparrow.stage.height - _background.height) / 2;
        
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
        
        
        _buttonPause = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"button_pause"]];
        _buttonResume = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"button_play"]];
        
        _buttonPause.x = Sparrow.stage.width - _buttonPause.width - 4.0f;
        _buttonPause.y = 4.0f;
        
        _buttonResume.x = _buttonPause.x;
        _buttonResume.y = _buttonPause.y;
        
        _buttonResume.visible = NO;
        
        SPButton *buttonAbort = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"button_abort"]];
        buttonAbort.x = Sparrow.stage.width - buttonAbort.width - 4.0f;
        buttonAbort.y = Sparrow.stage.height - buttonAbort.height - 4.0f;
        
        [_buttonPause addEventListener:@selector(onButtonPause:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [_buttonResume addEventListener:@selector(onButtonResume:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [buttonAbort addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(SPEvent *event)
        {
            [((SceneDirector *) self.director) showScene:@"piratecove"];
        }];

        
        _juggler = [SPJuggler juggler];
        
        [_juggler addObject:shipTween];
        
        [_background addEventListener:@selector(onBackgroundTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [_pirateShip addEventListener:@selector(onShipTap:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        
        [self addChild:_background];
        [self addChild:_enemyShip];
        [self addChild:_pirateShip];
        
        [self addChild:_buttonPause];
        [self addChild:_buttonResume];
        [self addChild:buttonAbort];
    }
    
    return self;
}

@end
