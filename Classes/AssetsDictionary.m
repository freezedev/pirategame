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

	if ([_dict valueForKey:name] == nil) {
		[_dict setObject:content forKey:name];
		
		result = content;
		
		if (self.verbose) {
			NSLog(@"Asset %@ does not exist. Registering.", name);
		}
	} else {
		result = [_dict valueForKey:name];
		
		if (self.verbose) {
			NSLog(@"Asset %@ does already exist. Using cached value.", name);
		}
	}

	return result;
}

@end
