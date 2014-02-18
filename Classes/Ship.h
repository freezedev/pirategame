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
}

@property int hitpoints;
@property ShipType type;
@property (nonatomic) ShipDirection direction;

-(id)initWithType:(ShipType)type;

-(void) shoot;

-(void) moveToX:(float) x andY:(float) y;
-(void) stop;

@end
