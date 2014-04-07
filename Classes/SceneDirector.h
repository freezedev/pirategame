//
//  SceneDirector.h
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "SPSprite.h"
#import "Scene.h"

@interface SceneDirector : SPSprite {
    NSMutableDictionary *_dict;
}

@property (readonly) Scene *currentScene;

-(void) addScene:(Scene *)scene;
-(void) addScene:(Scene *)scene WithName:(NSString *)name;

-(void) showScene:(NSString *)name;

@end
