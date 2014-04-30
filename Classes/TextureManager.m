//
//  TextureManager.m
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "TextureManager.h"

@implementation TextureManager

-(SPTexture *) registerTexture:(NSString *)filename
{
    if ([_dict objectForKey:filename] == nil) {
		return (SPTexture *) [self registerAsset:filename withContent:[SPTexture textureWithContentsOfFile:filename]];
	} else {
		return (SPTexture *) [self registerAsset:filename withContent:nil];
	}
}

-(SPTextureAtlas *) registerTextureAtlas:(NSString *) filename
{
    if ([_dict objectForKey:filename] == nil) {
		return (SPTextureAtlas *) [self registerAsset:filename withContent:[SPTextureAtlas atlasWithContentsOfFile:filename]];
	} else {
		return (SPTextureAtlas *) [self registerAsset:filename withContent:nil];
	}
}

@end
