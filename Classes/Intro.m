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
        
        SPQuad *quad = [SPQuad quadWithWidth:400.0f height:60.0f color:SP_BLACK];
        quad.alpha = 0.8f;
        quad.x = 16.0f;
        quad.y = 16.0f;
        
        _message = [SPTextField textFieldWithWidth:400.0f height:60.0f text:@"Welcome to the battlefield."];
        _message.color = SP_WHITE;
        _message.x = 16.0f;
        _message.y = 16.0f;
        
        [self addChild:background];
        [self addChild:_pirateShip];
        [self addChild:_enemyShip];
        [self addChild:buttonNext];
        [self addChild:quad];
        [self addChild:_message];
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
        _message.text = @"There is your ship (the pirate ship) and at least one enemy";
        [_pirateShip.juggler delayInvocationByTime:2.5f block:^{
            [_pirateShip shootWithBlock:^{
                 _message.text = @"Tap anywhere to move your ship.";
                [_pirateShip shootWithBlock:^{
                    [_pirateShip shootWithBlock:^{
                         _message.text = @"Double-tap on your ship to shoot.";
                        [_pirateShip.juggler delayInvocationByTime:2.5f block:^{
                             _message.text = @"In-between missions you can upgrade your ship.";
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
