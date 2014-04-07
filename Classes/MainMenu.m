//
//  MainMenu.m
//  PirateGame
//
//  Created by Johannes Stein on 07/04/14.
//
//

#import "MainMenu.h"
#import "Assets.h"
#import "Ship.h"
#import "SceneDirector.h"

@implementation MainMenu

-(id) init
{
    if ((self = [super init])) {
        
        SPImage *background = [SPImage imageWithTexture:[Assets texture:@"water.png"]];
        
        SPImage *ship = [SPImage imageWithTexture:[[Assets textureAtlas:@"ship_pirate_small_cannon.xml"] textureByName:@"ne_0001"]];
        ship.x = 16.0f;
        ship.y = (Sparrow.stage.height - ship.height) / 2;
        
        SPButton *buttonNewGame = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_yes"] text:@"New game"];
        
        buttonNewGame.x = (Sparrow.stage.width - buttonNewGame.width) / 2;
        buttonNewGame.y = 50.0f;
        
        [buttonNewGame addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(id event) {
            [(SceneDirector *) self.director showScene:@"intro"];
        }];
        
        SPButton *buttonContinue = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_yes"] text:@"Continue"];
        
        buttonContinue.x = (Sparrow.stage.width - buttonContinue.width) / 2;
        buttonContinue.y = 150.0f;
        buttonContinue.enabled = NO;
        
        [self addChild:background];
        [self addChild:ship];
        [self addChild:buttonNewGame];
        [self addChild:buttonContinue];
    }
    
    return self;
}

@end
