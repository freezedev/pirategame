//
//  Ship.h
//  PirateGame
//
//  Created by Johannes Stein on 16/02/14.
//
//

#import "SPSprite.h"

@interface Ship : SPSprite {
    SPMovieClip *_shootClip;
    SPMovieClip *_movingClip;
}

-(void) shoot;

-(void) moveTo: (int) x y: (int) y;
-(void) stop;

@end
