//
//  Game.m
//  AppScaffold
//

#import "Game.h" 
#import "SceneDirector.h"
#import "PirateCove.h"
#import "Battlefield.h"
#import "GameOver.h"
#import "MainMenu.h"
#import "World.h"
#import "Intro.h"

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
        MainMenu *mainMenu = [[MainMenu alloc] initWithName:@"mainmenu"];
        Intro *intro = [[Intro alloc] initWithName:@"intro"];
        
        SceneDirector *director = [[SceneDirector alloc] init];
        [self addChild:director];
        
        [director addScene:pirateCove];
        [director addScene:battlefield];
        [director addScene:gameOver];
        [director addScene:mainMenu];
        [director addScene:intro];
        
        [World log];
        
        [director showScene:@"mainmenu"];
        
        
    }
    return self;
}

-(void) dealloc
{
    [SPAudioEngine stop];
}

@end
