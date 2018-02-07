//
//  pickerViewModel.h
//  try1
//
//  Created by air on 2017/9/6.
//  Copyright © 2017年 smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface pickerViewModel : NSObject

+(pickerViewModel*) pickerInstance;
-(NSArray*)arrayNameInteger:(NSInteger)integer;
-(NSString*)arrayArrayInteger:(NSInteger)integer;
-(NSInteger)arrayNum;

@end
