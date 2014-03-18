//
//  Ship.m
//  PirateGame
//
//  Created by Johannes Stein on 16/02/14.
//
//

#import "Ship.h"

#import "Assets.h"
#import "World.h"

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

-(void) setHitpoints:(int)hitpoints
{
    _hitpoints = hitpoints;
    
    _quadHitpoints.scaleX = (float) _hitpoints / self.maxHitpoints;
    
    _isDead = (hitpoints <= 0);
    
    if (_hitpoints <= 0) {
        self.visible = FALSE;
        
        if (self.onDead) {
            [_onDead invoke];
        }
    }
}

-(int) getHitpoints
{
    return _hitpoints;
}


-(id) init
{
    return [self initWithType:ShipNormal];
}

-(id) initWithType:(ShipType)type
{
    if ((self = [super init])) {
        self.type = type;
        [self reset];
        
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

        self.cannonBallLeft = [SPImage imageWithTexture:[Assets texture:@"cannonball.png"]];
        self.cannonBallRight = [SPImage imageWithTexture:[Assets texture:@"cannonball.png"]];
        
        SPQuad *hitpointsBorder = [SPQuad quadWithWidth:clipNorth.width height:5.0f color:SP_BLACK];
        SPQuad *quadMaxHitpoints = [SPQuad quadWithWidth:hitpointsBorder.width - 2.0f height:3.0f color:SP_COLOR(200, 0, 0)];
        quadMaxHitpoints.x = 1.0f;
        quadMaxHitpoints.y = 1.0f;
        
        _quadHitpoints = [SPQuad quadWithWidth:hitpointsBorder.width - 2.0f height:3.0f color:SP_COLOR(0, 180, 0)];
        _quadHitpoints.x = quadMaxHitpoints.x;
        _quadHitpoints.y = quadMaxHitpoints.y;
        
        for (SPMovieClip* clip in _shootingClip) {
            clip.loop = NO;
            [self addChild:clip];
        }
        
        self.cannonBallLeft.visible = NO;
        self.cannonBallRight.visible = NO;
        
        _juggler = [SPJuggler juggler];
        
        [self addChild:self.cannonBallLeft];
        [self addChild:self.cannonBallRight];
        
        [self addChild:hitpointsBorder];
        [self addChild:quadMaxHitpoints];
        [self addChild:_quadHitpoints];
        
        self.direction = DirectionSouthWest;
    }
    
    return self;
}

-(void) reset
{
    for (SPMovieClip* clip in _shootingClip) {
        clip.color = SP_WHITE;
    }
    
    self.maxHitpoints = (self.type == ShipPirate) ? World.hitpoints : [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"hitpoints"] intValue];
    
    self.hitpoints = self.maxHitpoints;
    _isShooting = NO;
    self.paused = NO;
}

-(void) advanceTime:(double)seconds
{
    if (!self.paused) {
        [_juggler advanceTime:seconds];
    }
}

-(void) shootWithBlock:(ShipCallback)block
{
    if (_isShooting) {
        return;
    }
    
    _isShooting = YES;
    
    for (SPMovieClip* clip in _shootingClip) {
        [_juggler removeObjectsWithTarget:clip];
    }
    
    [_juggler removeObjectsWithTarget:self.cannonBallLeft];
    [_juggler removeObjectsWithTarget:self.cannonBallRight];
    
    SPMovieClip *currentClip = _shootingClip[self.direction];
    
    [_shootingClip[self.direction] play];
    [_juggler addObject:currentClip];
    
    float shootingTime = 1.25f;
    float innerBox = 25.0f;
    float targetPos = 30.0f;
    
    SPTween *tweenCbLeftX = [SPTween tweenWithTarget:self.cannonBallLeft time:shootingTime];
    SPTween *tweenCbLeftY = [SPTween tweenWithTarget:self.cannonBallLeft time:shootingTime];
    SPTween *tweenCbRightX = [SPTween tweenWithTarget:self.cannonBallRight time:shootingTime];
    SPTween *tweenCbRightY = [SPTween tweenWithTarget:self.cannonBallRight time:shootingTime];
    
    switch (self.direction) {
        case DirectionNorth:
        case DirectionSouth:
            self.cannonBallLeft.x = (-self.cannonBallLeft.width / 2) + innerBox;
            self.cannonBallLeft.y = (currentClip.height - self.cannonBallLeft.height) / 2;
            
            self.cannonBallRight.x = (-self.cannonBallRight.width / 2) + currentClip.width - innerBox;
            self.cannonBallRight.y = (currentClip.height - self.cannonBallRight.height) / 2;
            
            [tweenCbLeftX animateProperty:@"x" targetValue:self.cannonBallLeft.x - targetPos];
            [tweenCbRightX animateProperty:@"x" targetValue:self.cannonBallRight.x + targetPos];
            
            break;
            
        case DirectionEast:
        case DirectionWest:
            self.cannonBallLeft.y = (-self.cannonBallLeft.height / 2) + innerBox;
            self.cannonBallLeft.x = (currentClip.width - self.cannonBallLeft.width) / 2;
            
            self.cannonBallRight.y = (-self.cannonBallRight.height / 2) + currentClip.height - innerBox;
            self.cannonBallRight.x = (currentClip.width - self.cannonBallRight.width) / 2;
            
            [tweenCbLeftY animateProperty:@"y" targetValue:self.cannonBallLeft.y - targetPos];
            [tweenCbRightY animateProperty:@"y" targetValue:self.cannonBallRight.y + targetPos];
            
            break;
            
        default:
            break;
    }
    
    self.cannonBallLeft.visible = YES;
    self.cannonBallRight.visible = YES;
    
    [_juggler addObject:tweenCbLeftX];
    [_juggler addObject:tweenCbLeftY];
    [_juggler addObject:tweenCbRightX];
    [_juggler addObject:tweenCbRightY];
    
    [currentClip addEventListenerForType:SP_EVENT_TYPE_COMPLETED block:^(SPEvent *event)
     {
         [_shootingClip[self.direction] stop];
         _isShooting = NO;
         self.cannonBallLeft.visible = NO;
         self.cannonBallRight.visible = NO;
         
         [block invoke];
     }];
}

-(void) shoot
{
    [self shootWithBlock:^
    {
        
    }];
}

-(void) abortShooting
{
    _isShooting = NO;
    
    [_juggler removeObjectsWithTarget:self.cannonBallLeft];
    [_juggler removeObjectsWithTarget:self.cannonBallRight];
    
    self.cannonBallLeft.visible = NO;
    self.cannonBallRight.visible = NO;
}

-(void) hit: (int) damage
{
    self.hitpoints = self.hitpoints - damage;
    
    for (SPMovieClip* clip in _shootingClip) {
        SPTween *tween = [SPTween tweenWithTarget:clip time:0.3f];
        tween.reverse = YES;
        tween.repeatCount = 2;
        
        [tween animateProperty:@"color" targetValue:SP_RED];
        [_juggler addObject:tween];
    }
}

-(void) moveToX:(float)x andY:(float)y
{
    [self moveToX:x andY:y withBlock:^
    {
        
    }];
}

-(void) moveToX:(float)x andY:(float)y withBlock:(ShipCallback) block
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
    
    __block BOOL isTweenXCompleted = NO;
    __block BOOL isTweenYCompleted = NO;
    
    tweenX.onComplete = ^{
        isTweenXCompleted = YES;
        
        if (isTweenXCompleted && isTweenYCompleted) {
            [block invoke];
        }
    };
    
    tweenY.onComplete = ^{
        isTweenYCompleted = YES;
        
        if (isTweenXCompleted && isTweenYCompleted) {
            [block invoke];
        }
    };
    
    [_juggler addObject:tweenX];
    [_juggler addObject:tweenY];
}

-(void) stop
{
    [_juggler removeObjectsWithTarget:self];
}

-(float) checkDistanceToShip:(Ship *)ship
{
    SPPoint* p1 = [SPPoint pointWithX:self.x + self.width y:self.y + self.height];
    SPPoint* p2 = [SPPoint pointWithX:ship.x + ship.width y:ship.y + ship.height];
    
    float distance = [SPPoint distanceFromPoint:p1 toPoint:p2];
    
    return distance;
}

-(void) moveToShip:(Ship *)ship WithBlock:(ShipCallback)block
{
    float randomX = (arc4random() % 80) - 40.0f;
    float randomY = (arc4random() % 80) - 40.0f;
    
    [self moveToX:ship.x + randomX andY:ship.y + randomY withBlock:block];
}

@end
