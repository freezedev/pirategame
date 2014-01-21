//
//  Game.m
//  AppScaffold
//

#import "Game.h" 
#import "SceneDirector.h"
#import "PirateCove.h"
#import "Battlefield.h"

@implementation Game

- (id)init
{
    if ((self = [super init]))
    {
        Sparrow.stage.color = 0xffffff;
        
        PirateCove *pirateCove = [[PirateCove alloc] initWithName:@"piratecove"];
        Battlefield *battlefield = [[Battlefield alloc] initWithName:@"battlefield"];
        
        SceneDirector *director = [[SceneDirector alloc] init];
        [self addChild:director];
        
        [director addScene:pirateCove];
        [director addScene:battlefield];
        
        [director showScene:@"piratecove"];
        
        
    }
    return self;
}

@end
