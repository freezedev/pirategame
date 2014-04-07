//
//  Collision.m
//  PirateGame
//
//  Created by Johannes Stein on 07/04/14.
//
//

#import "Collision.h"
#import "Assets.h"
#import "World.h"

@implementation Collision

+(void) checkShipCollision: (Ship *) ship1 againstShip: (Ship *) ship2 withReferenceToSprite: (SPSprite *) sprite
{
    SPRectangle *enemyShipBounds = [ship1 boundsInSpace:sprite];
    SPRectangle *ball1 = [ship2.cannonBallLeft boundsInSpace:sprite];
    SPRectangle *ball2 = [ship2.cannonBallRight boundsInSpace:sprite];
    
    if ([enemyShipBounds intersectsRectangle:ball1] || [enemyShipBounds intersectsRectangle:ball2]) {
        if (ship2.cannonBallLeft.visible || ship2.cannonBallRight.visible) {
            [ship2 abortShooting];
            if (ship1.type == ShipPirate) {
                [ship1 hit: World.damage];
            } else {
                [ship1 hit:[(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"damage"] intValue]];
            }
        }
    }
}

@end
