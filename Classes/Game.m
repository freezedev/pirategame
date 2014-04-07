//
//  Game.m
//  AppScaffold
//

#import "Game.h" 
#import "SceneDirector.h"
#import "PirateCove.h"
#import "Battlefield.h"
#import "GameOver.h"
#import "World.h"

@implementation Game

- (id)init
{
    if ((self = [super init]))
    {
        Sparrow.stage.color = 0xffffff;
        
        [SPAudioEngine start];
        
        [SPTextField registerBitmapFontFromFile:@"PirateFont.fnt"];
        
        [World reset];
        
        PirateCove *pirateCove = [[PirateCove alloc] initWithName:@"piratecove"];
        Battlefield *battlefield = [[Battlefield alloc] initWithName:@"battlefield"];
        GameOver *gameOver = [[GameOver alloc] initWithName:@"gameover"];
        
        SceneDirector *director = [[SceneDirector alloc] init];
        [self addChild:director];
        
        [director addScene:pirateCove];
        [director addScene:battlefield];
        [director addScene:gameOver];
        
        [World log];
        
        [director showScene:@"piratecove"];
        
        
    }
    return self;
}

-(void) dealloc
{
    [SPAudioEngine stop];
}

@end
