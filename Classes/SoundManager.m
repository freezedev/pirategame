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
    if ([_dict objectForKey:filename] == nil) {
		return (SPSound *) [self registerAsset:filename withContent:[SPSound soundWithContentsOfFile:filename]];
	} else {
		return (SPSound *) [self registerAsset:filename withContent:nil];
	}
}

@end
