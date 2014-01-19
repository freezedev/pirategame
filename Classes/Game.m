//
//  Game.m
//  AppScaffold
//

#import "Game.h" 
#import "Assets.h"

@implementation Game

- (void)onLegTouch:(SPTouchEvent *)event
{
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
    if (touch) {
        SPQuad* target = (SPQuad *) event.target;
        
        float currentRotation = SP_R2D(target.rotation);
        
        if (currentRotation >= 360.0)
        {
            currentRotation = 0.0;
        }
        target.rotation = SP_D2R(currentRotation + 10);
    }
}

- (void)onHeadTouch:(SPTouchEvent *)event
{
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
    if (touch) {
        SPQuad* target = (SPQuad *) event.target;
        target.scaleX = (target.scaleX == 1.0) ? 1.5 : 1.0;
        target.scaleY = (target.scaleY == 1.0) ? 1.5 : 1.0;
    }
}

- (void)onArmsTouch:(SPTouchEvent *)event
{
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
    if (touch) {
        SPQuad* target = (SPQuad *) event.target;
        target.skewX = (target.skewY == SP_D2R(20)) ? SP_D2R(0) : SP_D2R(20);
        target.skewY = (target.skewY == SP_D2R(20)) ? SP_D2R(0) : SP_D2R(20);
    }
}


/*- (void)objectsFromDictionaryToScreen:(NSDictionary *)dict withDefinitions:(NSDictionary *)def andParent:(SPSprite *)parent
{
    NSArray* arrKey = [dict allKeys];
    NSArray* arrValues = [dict allValues];
    
    for (NSUInteger i = 0; i < arrValues.count; i++) {
        SPDisplayObject* element;
        NSString* key = arrKey[i];
        
        if ([arrValues[i] isKindOfClass:[NSDictionary class]])
        {
            SPSprite* sprite = [[SPSprite alloc] init];
            element = sprite;
            [self objectsFromDictionaryToScreen:arrValues[i] withDefinitions:def andParent:sprite];
        }
        else
        {
            if ([arrValues[i] isKindOfClass:[SPQuad class]])
            {
                element = arrValues[i];
            }
            else
            {
                element = [self quadFromDefinition:def withName:key];
            }
        }
        
        NSDictionary* elementDefinition = [def valueForKey:key];
        if (elementDefinition != nil)
        {
            if ([elementDefinition valueForKey:@"x"] != nil) {
                element.x = [(NSNumber*) elementDefinition[@"x"] floatValue];
            }
            if ([elementDefinition valueForKey:@"y"] != nil) {
                element.y = [(NSNumber*) elementDefinition[@"y"] floatValue];
            }
        }
        
        [parent addChild:element];
    }
}

- (SPQuad *)quadFromDefinition:(NSDictionary *)dict withName:(NSString *)name
{
    NSDictionary* elementDefinition = [dict valueForKey:name];
    if (elementDefinition != nil)
    {
        return [SPQuad quadWithWidth:[elementDefinition[@"width"] floatValue] height:[elementDefinition[@"height"] floatValue] color:[elementDefinition[@"color"] intValue]];
    }
    else
    {
        return [SPQuad quad];
    }
}*/

- (id)init
{
    if ((self = [super init]))
    {
        Sparrow.stage.color = 0xffffff;
        
        //AssetsDictionary* assets = [[AssetsDictionary alloc] init];
        //assets.verbose = YES;
        //[assets registerAsset:@"myAsset" withContent:@"test"];
        //[assets registerAsset:@"myAsset" withContent:@"test"];
        
        //TextureManager* textureAssets = [[TextureManager alloc] init];
        //textureAssets.verbose = YES;
        //[textureAssets registerTexture:@"Default.png"];
        //[textureAssets registerTexture:@"Default.png"];
        
        SPImage* image = [SPImage imageWithTexture:[Assets texture:@"Default.png"]];
        
NSDictionary* data = [Assets dictionaryFromJSON:@"example.json"];

NSLog(@"Printing values from dictionary:");
NSLog(@"%@", data[@"name"]);
NSLog(@"%@", data[@"a"]);
NSLog(@"%@", data[@"b"]);

NSLog(@"Loading from text file and displaying as a string:");
NSLog(@"%@", [Assets plainText:@"example.txt"]);
NSLog(@"%@", [Assets plainText:@"example.txt"]);
        
        //SPQuad *background = [SPQuad quadWithWidth:Sparrow.stage.width height:Sparrow.stage.height color:0xffffff];
        //[self addChild:background];
        
        //SP_COLOR(255, 255, 255);
        
        // This is where the code of your game will start;
        // in this sample, we add just a simple quad to see if it works.
        
        /*NSDictionary* definitions = @{
         @"body": @{
                 @"x": @85,
                 @"y": @120,
                 },
         @"torso": @{
                 @"width": @150,
                 @"height": @150,
                 @"color": @SP_RED
                 },
         @"head": @{
                 @"x": @35,
                 @"y": @-70,
                 @"width": @80,
                 @"height": @80,
                 @"color": @SP_YELLOW
                 },
         @"legs": @{
                 @"y": @140,
                 @"width": @50,
                 @"height": @150,
                 @"color": @SP_BLUE
                 },
         @"arms": @{
                 @"width": @150,
                 @"height": @50,
                 @"color": @SP_LIME
                 },
         @"hand": @{
                 @"width": @40,
                 @"height": @50,
                 @"color": @SP_YELLOW
                 },
         @"leftArm": @{
                 @"x": @-80
                 },
         @"rightArm": @{
                 @"x": @130
                 },
         @"rightHand": @{
                 @"x": @65
                 },
         @"rightLeg": @{
                 @"x": @100
                 }
         };
        
        NSDictionary *puppet = @{
            @"body": @{
                @"torso": @0,
                @"head": @0,
                @"arms": @{
                    @"leftArm": @{
                        @"arm": [self quadFromDefinition:definitions withName:@"arms"],
                        @"leftHand": [self quadFromDefinition:definitions withName:@"hand"]
                    },
                    @"rightArm": @{
                        @"arm": [self quadFromDefinition:definitions withName:@"arms"],
                        @"rightHand": [self quadFromDefinition:definitions withName:@"hand"]
                    }
                },
                @"legs": @{
                    @"leftLeg": [self quadFromDefinition:definitions withName:@"legs"],
                    @"rightLeg": [self quadFromDefinition:definitions withName:@"legs"]
                }
            }
        };
        
        [self objectsFromDictionaryToScreen:puppet withDefinitions:definitions andParent:self];*/
        
        SPSprite *body = [[SPSprite alloc] init];
        body.x = 85;
        body.y = 120;
        
        [self addChild:body];
        
        SPQuad *torso = [SPQuad quadWithWidth:150 height:150];
        torso.color = 0xff0000;
        [body addChild:torso];
        
        SPQuad *head = [SPQuad quadWithWidth:80 height:80 color:SP_YELLOW];
        head.x = 75;
        head.y = -30;
        [body addChild: head];
        
        SPSprite *arms = [[SPSprite alloc] init];
        [body addChild:arms];
        
        SPSprite *legs = [[SPSprite alloc] init];
        legs.y = 140;
        [body addChild:legs];
        
        SPQuad *leftArm = [SPQuad quadWithWidth:100 height:50 color:0x00ff00];
        leftArm.x = -80;
        [arms addChild:leftArm];
        
        SPQuad *rightArm = [SPQuad quadWithWidth:100 height:50 color:0x00ff00];
        rightArm.x = 130;
        [arms addChild:rightArm];
        
        SPQuad *leftHand = [SPQuad quadWithWidth:40 height:50 color:SP_YELLOW];
        leftHand.x = -80;
        [arms addChild:leftHand];
        
        SPQuad *rightHand = [SPQuad quadWithWidth:40 height:50 color:SP_YELLOW];
        rightHand.x = 190;
        [arms addChild:rightHand];
        
        SPQuad *leftLeg = [SPQuad quadWithWidth:50 height:150 color:0x0000ff];
        [legs addChild:leftLeg];
        leftLeg.x = 25;
        
        SPQuad *rightLeg = [SPQuad quadWithWidth:50 height:150 color:0x0000ff];
        rightLeg.x = 125;
        [legs addChild:rightLeg];
        
        leftLeg.pivotX = 25;
        leftLeg.pivotY = 10;
        
        rightLeg.pivotX = 25;
        rightLeg.pivotY = 10;
        
        head.pivotX = 40;
        head.pivotY = 40;
        
        [rightLeg addEventListener:@selector(onLegTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [leftLeg addEventListener:@selector(onLegTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [head addEventListener:@selector(onHeadTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [arms addEventListener:@selector(onArmsTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addChild:image];
        
        // Per default, this project compiles as an universal application. To change that, enter the
        // project info screen, and in the "Build"-tab, find the setting "Targeted device family".
        //
        // Now Choose:  
        //   * iPhone      -> iPhone only App
        //   * iPad        -> iPad only App
        //   * iPhone/iPad -> Universal App  
        // 
        // The "iOS deployment target" setting must be at least "iOS 5.0" for Sparrow 2.
        // Always used the latest available version as the base SDK.
    }
    return self;
}

@end
