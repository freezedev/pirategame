//
//  BaseAssets.h
//  PirateGame
//
//  Created by Johannes Stein on 03/01/14.
//
//

#import <Foundation/Foundation.h>

@interface AssetsDictionary : NSObject {
    NSMutableDictionary *_dict;
}

@property BOOL verbose;

-(id) registerAsset:(NSString *)name withContent:(id)content;
-(void) unregisterAsset:(NSString *)name;
-(void) clear;

@end
