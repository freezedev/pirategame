//
//  Collision.h
//  PirateGame
//
//  Created by Johannes Stein on 07/04/14.
//
//

#import <Foundation/Foundation.h>
#import "Ship.h"

@interface Collision : NSObject

+(void) checkShipCollision: (Ship *) ship1 againstShip: (Ship *) ship2 withReferenceToSprite: (SPSprite *) sprite;

@end
