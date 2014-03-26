//
//  Scene.h
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "SPSprite.h"

@interface Scene : SPSprite {
    SPSoundChannel *backgroundMusic;
}

@property SPSprite* guiLayer;
@property NSString* name;
@property id director;

-(id) initWithName:(NSString *)name;
-(void) reset;
-(void) stop;

@end
