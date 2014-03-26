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
    if ((self = [super init])) {
        self.guiLayer = [[SPSprite alloc] init];
        self.director = nil;
        self.name = @"scene";
    }
    
    return self;
}

-(id) initWithName:(NSString *) name
{
    self = [self init];
    self.name = name;
    
    return self;
}


-(void) stop
{

}

-(void) reset
{

}

@end
