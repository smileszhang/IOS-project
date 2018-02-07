//
//  WebModel.m
//  try1
//
//  Created by smile on 2017/9/6.
//  Copyright © 2017年 smile. All rights reserved.
//

#import "WebModel.h"
@interface NSObject ()

@property (strong, nonatomic) NSMutableArray* webLinks;
@property (nonatomic,assign) NSInteger webLinkCount;


@end
@implementation WebModel

@synthesize webLinks = _webLinks;
@synthesize webLinkCount=_webLinkCount;


-(NSMutableArray*)webLinks{
    if(!_webLinks){
        _webLinks = [[NSMutableArray alloc] initWithCapacity: self.webLinkCount];
        [_webLinks addObject:@"http://www.google.com"];
        [_webLinks addObject:@"http://www.youtube.com"];
        [_webLinks addObject:@"http://www.facebook.com"];
    }
    

    return _webLinks;
}

-(NSInteger)webLinkCount{
    
    
    if(!_webLinkCount)
        _webLinkCount=3;
    
    
    return _webLinkCount;
}

+(WebModel*)sharedInstance{
    static WebModel * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate,^{
        _sharedInstance = [[WebModel alloc] init];
    });
    
    return _sharedInstance;
    
}

-(NSString*)webLinksInteger:(NSInteger)integer{
    
    NSString* sendback= self.webLinks[integer];
    return sendback;
    
}

-(NSInteger)webNum{
    NSInteger str=self.webLinks.count;
    return str;
}




@end
