//
//  Ship.h
//  PirateGame
//
//  Created by Johannes Stein on 16/02/14.
//
//

#import "SPSprite.h"

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
@property SPImage *cannonBallLeft;
@property SPImage *cannonBallRight;

-(id)initWithType:(ShipType)type;

-(void) shoot;
-(void) abortShooting;

-(void) hit;

-(void) moveToX:(float) x andY:(float) y;
-(void) stop;

@end
