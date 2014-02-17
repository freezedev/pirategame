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
    return (SPTexture *) [self registerAsset:filename withContent:[SPTexture textureWithContentsOfFile:filename]];
}

-(SPTextureAtlas *) registerTextureAtlas:(NSString *) filename
{
    return (SPTextureAtlas *) [self registerAsset:filename withContent:[SPTextureAtlas atlasWithContentsOfFile:filename]];
}

@end
