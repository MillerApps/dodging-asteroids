//
//  AstroidNode.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/8/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "AsteroidNode.h"
#import "Utils.h"


@implementation AsteroidNode

+(instancetype)astroidOfType:(AstoridType)type {
    AsteroidNode *astroid;
    
    
    if (type == AstoridTypeA) {
        astroid = [self spriteNodeWithImageNamed:@"rock_a"];
        astroid.type = AstoridTypeA;
        
        
        
    } else if (type == AstoridTypeB) {
        astroid = [self spriteNodeWithImageNamed:@"rock_b"];
        astroid.type = AstoridTypeB;
        
    } else {
        astroid = [self spriteNodeWithImageNamed:@"rock_c"];
        astroid.type = AstoridTypeC;
        
    }
    
    astroid.name = @"astroid";
    astroid.zPosition = 1;
    
    
    //changes asteroid size for smaller screen sizes
    if ( IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
        astroid.size = [Utils setNodeSize:astroid.size];
        
    }
    
    [astroid setUpPhysicsBody];
    
    
    return astroid;
}




-(void)setUpPhysicsBody {
    
    
    CGFloat offsetX = self.size.width / 2;
    CGFloat offsetY = self.size.height / 2;
    
    if (self.type == AstoridTypeA) {
        
        
        
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            CGMutablePathRef path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, NULL, 17 - offsetX, 72 - offsetY);
            CGPathAddLineToPoint(path, NULL, 64 - offsetX, 71 - offsetY);
            CGPathAddLineToPoint(path, NULL, 85 - offsetX, 40 - offsetY);
            CGPathAddLineToPoint(path, NULL, 73 - offsetX, 10 - offsetY);
            CGPathAddLineToPoint(path, NULL, 52 - offsetX, 13 - offsetY);
            CGPathAddLineToPoint(path, NULL, 27 - offsetX, 4 - offsetY);
            CGPathAddLineToPoint(path, NULL, 2 - offsetX, 30 - offsetY);
            
            
            CGPathCloseSubpath(path);
            
            
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
            CGPathRelease(path);
        } else {
            CGMutablePathRef path = CGPathCreateMutable();
            
            
            CGPathMoveToPoint(path, NULL, 20 - offsetX, 87 - offsetY);
            CGPathAddLineToPoint(path, NULL, 77 - offsetX, 86 - offsetY);
            CGPathAddLineToPoint(path, NULL, 103 - offsetX, 48 - offsetY);
            CGPathAddLineToPoint(path, NULL, 88 - offsetX, 13 - offsetY);
            CGPathAddLineToPoint(path, NULL, 63 - offsetX, 16 - offsetY);
            CGPathAddLineToPoint(path, NULL, 33 - offsetX, 5 - offsetY);
            CGPathAddLineToPoint(path, NULL, 3 - offsetX, 36 - offsetY);
            
            CGPathCloseSubpath(path);
            
            
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
            CGPathRelease(path);
        }
        
        
    } else if (self.type == AstoridTypeB) {
        
        
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            CGMutablePathRef path = CGPathCreateMutable();
            
            
            CGPathMoveToPoint(path, NULL, 35 - offsetX, 75 - offsetY);
            CGPathAddLineToPoint(path, NULL, 67 - offsetX, 66 - offsetY);
            CGPathAddLineToPoint(path, NULL, 80 - offsetX, 41 - offsetY);
            CGPathAddLineToPoint(path, NULL, 62 - offsetX, 8 - offsetY);
            CGPathAddLineToPoint(path, NULL, 20 - offsetX, 15 - offsetY);
            CGPathAddLineToPoint(path, NULL, 10 - offsetX, 30 - offsetY);
            CGPathAddLineToPoint(path, NULL, 8 - offsetX, 59 - offsetY);
            
            CGPathCloseSubpath(path);
            
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
            CGPathRelease(path);
            
        } else {
            CGMutablePathRef path = CGPathCreateMutable();
            
            
            CGPathMoveToPoint(path, NULL, 43 - offsetX, 91 - offsetY);
            CGPathAddLineToPoint(path, NULL, 81 - offsetX, 80 - offsetY);
            CGPathAddLineToPoint(path, NULL, 97 - offsetX, 50 - offsetY);
            CGPathAddLineToPoint(path, NULL, 75 - offsetX, 10 - offsetY);
            CGPathAddLineToPoint(path, NULL, 25 - offsetX, 18 - offsetY);
            CGPathAddLineToPoint(path, NULL, 12 - offsetX, 36 - offsetY);
            CGPathAddLineToPoint(path, NULL, 10 - offsetX, 71 - offsetY);
            
            CGPathCloseSubpath(path);
            
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
            CGPathRelease(path);
        }
    } else {
        
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            CGMutablePathRef path = CGPathCreateMutable();
            
            
            CGPathMoveToPoint(path, NULL, 34 - offsetX, 40 - offsetY);
            CGPathAddLineToPoint(path, NULL, 45 - offsetX, 26 - offsetY);
            CGPathAddLineToPoint(path, NULL, 33 - offsetX, 8 - offsetY);
            CGPathAddLineToPoint(path, NULL, 20 - offsetX, 10 - offsetY);
            CGPathAddLineToPoint(path, NULL, 9 - offsetX, 19 - offsetY);
            CGPathAddLineToPoint(path, NULL, 14 - offsetX, 35 - offsetY);
            
            CGPathCloseSubpath(path);
            
            
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
            CGPathRelease(path);
            
            
        } else {
            CGMutablePathRef path = CGPathCreateMutable();
            
            
            CGPathMoveToPoint(path, NULL, 41 - offsetX, 48 - offsetY);
            CGPathAddLineToPoint(path, NULL, 55 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, NULL, 40 - offsetX, 10 - offsetY);
            CGPathAddLineToPoint(path, NULL, 24 - offsetX, 12 - offsetY);
            CGPathAddLineToPoint(path, NULL, 11 - offsetX, 23 - offsetY);
            CGPathAddLineToPoint(path, NULL, 17 - offsetX, 43 - offsetY);
            
            CGPathCloseSubpath(path);
            
            
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
            CGPathRelease(path);
        }
        
        
        
    }
    
    self.physicsBody.friction = 0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.categoryBitMask = CollisionCatAstroid;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCatShip | CollisionCatBottomEdge;
    
}

@end
