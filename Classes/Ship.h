//
//  Ship.h
//  PirateGame
//
//  Created by Johannes Stein on 16/02/14.
//
//

#import "SPSprite.h"

typedef void(^ShipCallback)(void);

typedef NS_ENUM(NSInteger, ShipDirection) {
    DirectionNorth,
    DirectionSouth,
    DirectionWest,
    DirectionEast,
    DirectionNorthWest,
    DirectionNorthEast,
    DirectionSouthWest,
    DirectionSouthEast
};

typedef NS_ENUM(NSInteger, ShipType) {
    ShipPirate,
    ShipNormal
};

@interface Ship : SPSprite {
    NSArray *_shootingClip;
    ShipDirection _direction;
    BOOL _isShooting;
    int _hitpoints;
    
    SPQuad *_quadHitpoints;
}

@property (nonatomic) int hitpoints;
@property int maxHitpoints;

@property ShipType type;
@property (nonatomic) ShipDirection direction;
@property (readonly) BOOL isShooting;
@property (nonatomic) BOOL paused;
@property SPImage *cannonBallLeft;
@property SPImage *cannonBallRight;

@property SPJuggler *juggler;

-(id)initWithType:(ShipType)type;

-(void) shoot;
-(void) shootWithBlock:(ShipCallback) block;

-(void) abortShooting;

-(void) hit;

-(void) moveToX:(float)x andY:(float)y withBlock:(ShipCallback) block;
-(void) moveToX:(float) x andY:(float) y;
-(void) stop;

-(void) advanceTime:(double)seconds;

-(float) checkDistanceToShip:(Ship *)ship;
-(void) moveToShip:(Ship *)ship WithBlock:(ShipCallback) block;

@end
