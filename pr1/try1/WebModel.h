//
//  WebModel.h
//  try1
//
//  Created by smile on 2017/9/6.
//  Copyright © 2017年 smile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebModel : NSObject


-(NSString*)webLinksInteger:(NSInteger)integer;
-(NSInteger)webNum;
+(WebModel*)sharedInstance;

@end
