//
//  Ship.h
//  PirateGame
//
//  Created by Johannes Stein on 16/02/14.
//
//

#import "SPSprite.h"

@interface Ship : SPSprite {
    SPMovieClip *_shootingClip;
    SPImage *_image;
}

-(id)initWithContentsOfFile:(NSString *)filename;

-(void) shoot;

-(void) moveToX:(float) x andY:(float) y;
-(void) stop;

@end
