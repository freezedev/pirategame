//
//  Ship.m
//  PirateGame
//
//  Created by Johannes Stein on 16/02/14.
//
//

#import "Ship.h"

#import "Assets.h"

@implementation Ship

-(id) init
{
    if ((self = [super init])) {
        NSArray *textures = [[Assets textureAtlas:@"ship_pirate_small_cannon.xml"] texturesStartingWith:@"00"];
        
        _shootingClip = [SPMovieClip movieWithFrames:textures fps:20.0f];
        
        if (_image == nil) {
            _image = [[SPImage alloc] init];
        }
        
        [self addChild:_shootingClip];
        [self addChild:_image];
    }
    
    return self;
}

-(id) initWithContentsOfFile:(NSString *)filename
{
    _image = [[SPImage alloc] initWithTexture:[Assets texture:filename]];
    
    return [self init];
}

-(void) shoot
{
    [_shootingClip play];
    [Sparrow.juggler addObject:_shootingClip];
}

-(void) moveToX:(float)x andY:(float)y
{
    [self stop];
    
    float targetX = x - (self.width / 2);
    float targetY = y - (self.height / 2);
    
    float distanceX = fabsf(self.x - targetX);
    float distanceY = fabsf(self.y - targetY);
    
    float penalty = (distanceX + distanceY) / 80.0f;
    
    float shipInitial = 0.25f + penalty;
    
    float speedX = shipInitial + (distanceX / Sparrow.stage.width) * penalty * penalty;
    float speedY = shipInitial + (distanceY / Sparrow.stage.height) * penalty * penalty;
    
    SPTween *tweenX = [SPTween tweenWithTarget:self time:speedX];
    SPTween *tweenY = [SPTween tweenWithTarget:self time:speedY];
    
    
    [tweenX animateProperty:@"x" targetValue:targetX];
    [tweenY animateProperty:@"y" targetValue:targetY];
    
    [Sparrow.juggler addObject:tweenX];
    [Sparrow.juggler addObject:tweenY];
}

-(void) stop
{
    [Sparrow.juggler removeObjectsWithTarget:self];
}

@end
