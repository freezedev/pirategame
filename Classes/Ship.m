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

-(void) setDirection:(ShipDirection)direction
{
    _direction = direction;
    
    for (SPMovieClip* clip in _shootingClip) {
        clip.visible = NO;
    }
    
    ((SPMovieClip *) _shootingClip[_direction]).visible = YES;
}

-(ShipDirection) getDirection
{
    return _direction;
}


-(id) init
{
    return [self initWithType:ShipNormal];
}

-(id) initWithType:(ShipType)type
{
    if ((self = [super init])) {
        self.hitpoints = 100;
        self.type = type;
        
        SPTextureAtlas *atlas = (type == ShipPirate) ? [Assets textureAtlas:@"ship_pirate_small_cannon.xml"] : [Assets textureAtlas:@"ship_small_cannon.xml"] ;
        
        NSArray *texturesNorth = [atlas texturesStartingWith:@"n_00"];
        NSArray *texturesSouth = [atlas texturesStartingWith:@"s_00"];
        NSArray *texturesWest = [atlas texturesStartingWith:@"w_00"];
        NSArray *texturesEast = [atlas texturesStartingWith:@"e_00"];
        NSArray *texturesNorthWest = [atlas texturesStartingWith:@"nw_00"];
        NSArray *texturesNorthEast = [atlas texturesStartingWith:@"ne_00"];
        NSArray *texturesSouthWest = [atlas texturesStartingWith:@"sw_00"];
        NSArray *texturesSouthEast = [atlas texturesStartingWith:@"se_00"];
        
        float animationFPS = 12.0f;
        
        SPMovieClip *clipNorth = [SPMovieClip movieWithFrames:texturesNorth fps:animationFPS];
        SPMovieClip *clipSouth = [SPMovieClip movieWithFrames:texturesSouth fps:animationFPS];
        SPMovieClip *clipWest = [SPMovieClip movieWithFrames:texturesWest fps:animationFPS];
        SPMovieClip *clipEast = [SPMovieClip movieWithFrames:texturesEast fps:animationFPS];
        SPMovieClip *clipNorthWest = [SPMovieClip movieWithFrames:texturesNorthWest fps:animationFPS];
        SPMovieClip *clipNorthEast = [SPMovieClip movieWithFrames:texturesNorthEast fps:animationFPS];
        SPMovieClip *clipSouthWest = [SPMovieClip movieWithFrames:texturesSouthWest fps:animationFPS];
        SPMovieClip *clipSouthEast = [SPMovieClip movieWithFrames:texturesSouthEast fps:animationFPS];
        
        _shootingClip = [NSArray arrayWithObjects:clipNorth, clipSouth, clipWest, clipEast, clipNorthWest, clipNorthEast, clipSouthWest, clipSouthEast, nil];

        for (SPMovieClip* clip in _shootingClip) {
            clip.loop = NO;
            [self addChild:clip];
        }
        
        self.direction = DirectionSouthWest;
    }
    
    return self;
}

-(void) shoot
{
    for (SPMovieClip* clip in _shootingClip) {
        [Sparrow.juggler removeObjectsWithTarget:clip];
    }
    
    [_shootingClip[self.direction] play];
    [Sparrow.juggler addObject:_shootingClip[self.direction]];
    
    [_shootingClip[self.direction] addEventListenerForType:SP_EVENT_TYPE_COMPLETED block:^(SPEvent *event)
    {
        [_shootingClip[self.direction] stop];
    }];
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
    
    
    int signX = 0;
    int signY = 0;
    
    if (distanceX > 40) {
        signX = (self.x - targetX) / distanceX;
    }
    
    if (distanceY > 40) {
        signY = (self.y - targetY) / distanceY;
    }
    
    if ((signX == 1) && (signY == 0)) {
        self.direction = DirectionEast;
    }
    
    if ((signX == -1) && (signY == 0)) {
        self.direction = DirectionWest;
    }
    
    if ((signX == 0) && (signY == 1)) {
        self.direction = DirectionNorth;
    }
    
    if ((signX == 0) && (signY == -1)) {
        self.direction = DirectionSouth;
    }
    
    if ((signX == 1) && (signY == 1)) {
        self.direction = DirectionNorthWest;
    }
    
    if ((signX == -1) && (signY == 1)) {
        self.direction = DirectionNorthEast;
    }
    
    if ((signX == -1) && (signY == -1)) {
        self.direction = DirectionSouthEast;
    }
    
    if ((signX == 1) && (signY == -1)) {
        self.direction = DirectionSouthWest;
    }
    
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
