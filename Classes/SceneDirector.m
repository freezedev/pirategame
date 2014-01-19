//
//  SceneDirector.m
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "SceneDirector.h"

@implementation SceneDirector

-(id) init
{
    if ((self = [super init])) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void) addScene:(Scene *)scene
{
    [self addScene:scene WithName:scene.name];
}

-(void) addScene:(Scene *)scene WithName:(NSString *)name
{
    scene.name = name;
    _dict[name] = scene;
    
    scene.director = self;
    [self addChild:scene];
}

-(void) showScene:(NSString *)name
{
    for (Scene* scene in _dict) {
        scene.visible = NO;
    }
    
    if (_dict[name] != nil) {
        ((Scene *) _dict[name]).visible = YES;
    }
}

@end
