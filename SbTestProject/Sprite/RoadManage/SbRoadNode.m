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
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
    self.physicsBody.linearDamping = 0.5;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    
    
    self.physicsBody.contactTestBitMask = 1;
    self.physicsBody.categoryBitMask = 2;
    self.physicsBody.collisionBitMask = 3;
}

@end
