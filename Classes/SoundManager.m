//
//  SoundManager.m
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "SoundManager.h"

@implementation SoundManager

-(SPSound *) registerSound:(NSString *)filename
{
    return (SPSound *) [self registerAsset:filename withContent:[SPSound soundWithContentsOfFile:filename]];
}

@end
