//
//  GameOver.m
//  PirateGame
//
//  Created by Johannes Stein on 07/04/14.
//
//

#import "GameOver.h"
#import "Assets.h"
#import "SceneDirector.h"
#import "World.h"

@implementation GameOver

-(BOOL) getGameWon
{
    return _gameWon;
}

-(void) setGameWon:(BOOL)gameWon
{
    _gameWon = gameWon;
    
    if (_gameWon) {
        _message.text = @"You won the game. Congratulations.";
    } else {
        _message.text = @"Your ship sank. Try again.";
    }
}

-(id) init
{
    if ((self = [super init])) {
        
        SPImage *background = [SPImage imageWithTexture:[Assets texture:@"water.png"]];
        
        _message = [SPTextField textFieldWithWidth:Sparrow.stage.width height:Sparrow.stage.height text:@"Game Over" fontName:@"PirateFont" fontSize:24.0f color:SP_WHITE];
        
        SPButton *resetButton = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_yes"] text:@"Start over"];
        
        resetButton.x = (Sparrow.stage.width - resetButton.width) / 2;
        resetButton.y = Sparrow.stage.height - resetButton.height - 8.0f;
        
        [resetButton addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(id event) {
            [World reset];
            [(SceneDirector *) self.director showScene:@"piratecove"];
        }];
        
        [self addChild:background];
        [self addChild:_message];
        [self addChild:resetButton];
    }
    
    return self;
}

@end
