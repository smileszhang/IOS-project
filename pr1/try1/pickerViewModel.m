//
//  pickerViewModel.m
//  try1
//
//  Created by air on 2017/9/6.
//  Copyright © 2017年 smile. All rights reserved.
//

#import "pickerViewModel.h"




@interface NSObject ()

@property (strong, nonatomic) NSArray* arrayNames;
@property (strong, nonatomic) NSMutableArray* arrayArray;

@end

@implementation pickerViewModel
@synthesize arrayNames = _arrayNames;
@synthesize arrayArray = _arrayArray;





-(NSArray*)arrayNames{
    
    
    if(!_arrayNames)
       // _arrayNames= [[NSMutableArray alloc] initWithCapacity:[self arrayNum]];
  
        _arrayNames = @[@[@"Number",@"1",@"2",@"3",@"4"],@[@"Name",@"Eric1",@"Eric2",@"Eric3"], @[@"Animal",@"Horse",@"Sheep", @"Pig", @"Dog", @"Cat", @"Chicken", @"Duck", @"Goose"],@[@"Fruit",@"apple",@"peer",@"orange",@"banana",@"blueberry"]];
    
    
    return _arrayNames;
}



-(NSMutableArray*)arrayArray{
    
    if(!_arrayArray){
        _arrayArray = [[NSMutableArray alloc] initWithCapacity:[self arrayNum]];
    }
    
    for(int i=0; i<[self arrayNum]; i++)
    {
        _arrayArray[i] =  _arrayNames[i];
        
    }
 
    /* _imageImage[0]=[self getImageWithName:self.imageNames[0]];
     _imageImage[1]=[self getImageWithName:self.imageNames[1]];
     _imageImage[2]=[self getImageWithName:self.imageNames[2]];
     _imageImage[3]=[self getImageWithName:self.imageNames[3]];
     //[[self.sharedInstance] getImageWithName:@"Eric1"];
     //@[@"Eric1",@"Eric2",@"Eric3"];*/
 
    return _arrayArray;
}


+(pickerViewModel*)pickerInstance{
    static pickerViewModel * _pickerInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate,^{
        _pickerInstance = [[pickerViewModel alloc] init];
    });
    
    return _pickerInstance;
    
}

/*-(UIImage*)getImageWithName:(NSString *)name{
    UIImage* image = nil;
    
    image = [UIImage imageNamed:name];
    // /image = [UIImage imageWithContentsOfFile:<#(nonnull NSString *)#>]
    return image;
}*/


-(NSArray*)arrayNameInteger:(NSInteger)integer{
    
    NSArray* sendback= self.arrayNames[integer];
    return sendback;
    
}
-(NSString*)arrayArrayInteger:(NSInteger)integer{
    NSString* sendback=self.arrayArray[integer][0];
    return sendback;
    
}

-(NSInteger)arrayNum{
    NSInteger str=self.arrayNames.count;
    return str;
}
@end
