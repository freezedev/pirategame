//
//  BaseAssets.m
//  PirateGame
//
//  Created by Johannes Stein on 03/01/14.
//
//

#import "AssetsDictionary.h"

@implementation AssetsDictionary

- (id)init
{
	if ((self = [super init])) {
		_dict = [[NSMutableDictionary alloc] init];
		self.verbose = NO;
	}
    
    return self;
}

-(id) registerAsset:(NSString *)name withContent:(id)content
{
	id result;

	if ([_dict objectForKey:name] == nil) {
		[_dict setObject:content forKey:name];
		
		result = content;
		
		if (self.verbose) {
			NSLog(@"Asset %@ does not exist. Registering.", name);
		}
	} else {
		result = [_dict objectForKey:name];
		
		if (self.verbose) {
			NSLog(@"Asset %@ already exists. Using cached value.", name);
		}
	}

	return result;
}

-(void) unregisterAsset:(NSString *)name
{
    if ([_dict objectForKey:name] == nil) {
        [_dict removeObjectForKey:name];
    }
}

-(void) clear
{
    [_dict removeAllObjects];
}

@end
