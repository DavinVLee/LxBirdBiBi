//
//  SbRoadNode.m
//  SbTestProject
//
//  Created by 李翔 on 2017/3/3.
//  Copyright © 2017年 李翔. All rights reserved.
//

#import "SbRoadNode.h"

@implementation SbRoadNode

+ (SbRoadNode *)nodeWithType:(SbRoadType)type
{
    NSString *imageName = [NSString stringWithFormat:@"SbRoad%ld",type];
    SbRoadNode *node = [SbRoadNode spriteNodeWithImageNamed:imageName];
    node.type = type;
    return node;
}

- (void)nodePhysicsBodySetup
{
//    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
    
    CGFloat offsety = 0;
    CGFloat treeOffsetx = 0;
    switch (self.type) {
        case SbRoadType1:
        {
            treeOffsetx = 5;
            offsety = 12;
        }
            break;
            case SbRoadType2:
        {
            treeOffsetx = 0;
            offsety = 12;
        }
            break;
            case SbRoadType3:
        {
            offsety = 13;
            treeOffsetx = -5;
        }
            break;
        default:
            break;
    }
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-self.size.width/2.f, -self.size.height/2.f - offsety, self.size.width, self.size.height - offsety)];
    self.physicsBody.linearDamping = 1.0;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.restitution = 0;

    
    self.physicsBody.contactTestBitMask = 1;
    self.physicsBody.categoryBitMask = 2;
    self.physicsBody.collisionBitMask = 3;
    
    
    //添加植物
    int randomCount = arc4random() % 3 + 1;
    SKSpriteNode *treeNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"SbTree%d",randomCount]];treeNode.position = CGPointMake(self.position.x + treeOffsetx, self.position.y + self.frame.size.height/2.f + treeNode.size.height/2.f - (randomCount == 1 ? 23 : 16));
    
    [self.parent insertChild:treeNode atIndex:0];
    
    
}

@end
