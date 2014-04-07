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
    for (NSString* sceneName in _dict) {
        ((Scene *) _dict[sceneName]).visible = false;
        [((Scene *) _dict[sceneName]) stop];
    }
    
    if (_dict[name] != nil) {
        ((Scene *) _dict[name]).visible = YES;
        [((Scene *) _dict[name]) reset];
        _currentScene = (Scene *) _dict[name];
    }
}

@end
