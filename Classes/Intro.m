//
//  Intro.m
//  PirateGame
//
//  Created by Johannes Stein on 07/04/14.
//
//

#import "Intro.h"
#import "Assets.h"
#import "Ship.h"
#import "SceneDirector.h"
#import "Collision.h"

@implementation Intro

-(id) init
{
    if ((self = [super init])) {
        
        SPImage *background = [SPImage imageWithTexture:[Assets texture:@"water.png"]];
        
        _pirateShip = [[Ship alloc] initWithType:ShipPirate];
        _pirateShip.x = 16.0f;
        _pirateShip.y = ((Sparrow.stage.height - _pirateShip.height) / 2) - 20.0f;
        
        _enemyShip = [[Ship alloc] initWithType:ShipNormal];
        _enemyShip.x = Sparrow.stage.width - _enemyShip.width - 16.0f;
        _enemyShip.y = ((Sparrow.stage.height - _enemyShip.height) / 2) + 20.0f;
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        
        SPButton *buttonNext = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_yes"] text:@"Next"];
        
        buttonNext.x = (Sparrow.stage.width - buttonNext.width) / 2;
        buttonNext.y = Sparrow.stage.height - buttonNext.height - 8.0f;
        
        [buttonNext addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(id event) {
            [(SceneDirector *) self.director showScene:@"piratecove"];
        }];
        
        [self addChild:background];
        [self addChild:_pirateShip];
        [self addChild:_enemyShip];
        [self addChild:buttonNext];
    }
    
    return self;
}

-(void) onEnterFrame: (SPEnterFrameEvent *) event
{
    double passedTime = event.passedTime;
    
    [Collision checkShipCollision:_pirateShip againstShip:_enemyShip withReferenceToSprite:self];
    [Collision checkShipCollision:_enemyShip againstShip:_pirateShip withReferenceToSprite:self];
    
    [_pirateShip advanceTime:passedTime];
    [_enemyShip advanceTime:passedTime];
}

-(void) reset
{
    [_pirateShip reset];
    [_enemyShip reset];
    
    [_pirateShip moveToX:Sparrow.stage.width / 2 andY:(Sparrow.stage.height / 2) - 20.0f withBlock:^{
        [_pirateShip.juggler delayInvocationByTime:1.5f block:^{
            [_pirateShip shootWithBlock:^{
                [_pirateShip shootWithBlock:^{
                    [_pirateShip shootWithBlock:^{
                        [_pirateShip.juggler delayInvocationByTime:1.0f block:^{
                            [_pirateShip shoot];
                        }];
                    }];
                }];
            }];
        }];
    }];
    
    [_enemyShip moveToX:Sparrow.stage.width / 2 andY:(Sparrow.stage.height / 2) + 20.0f withBlock:^{
        [_enemyShip shoot];
    }];
}

@end
