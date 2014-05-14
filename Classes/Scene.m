//
//  Scene.m
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "Scene.h"

@implementation Scene

-(id) init
{
    return [self initWithName:@"scene"];
}

-(id) initWithName:(NSString *) sceneName
{
    if ((self = [super init])) {
        self.guiLayer = [[SPSprite alloc] init];
        self.director = nil;
        self.name = sceneName;
    }
    
    return self;
}


-(void) stop
{

}

-(void) reset
{

}

@end
