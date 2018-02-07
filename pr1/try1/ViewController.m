//
//  ViewController.m
//  try1
//
//  Created by smile on 2017/8/27.
//  Copyright © 2017年 smile. All rights reserved.
//

#import "ViewController.h"
#import "ImageModel.h"

@interface ViewController () <UIScrollViewDelegate>

//normal image view
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//scroll image view 
@property(strong, nonatomic) UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic) ImageModel* myImageModel;

@end

@implementation ViewController

@synthesize indexUse = _indexUse;

-(ImageModel*)myImageModel{
    
    if(!_myImageModel)
        _myImageModel = [ImageModel sharedInstance];
    
    return _myImageModel;
}

-(NSString*)imageName{
    
    if(!_imageName)
        _imageName = @"Eric1";
    
    return _imageName;
}


-(NSInteger)indexUse{
    
    if(!_indexUse)
        _indexUse = 0;
    
    return _indexUse;
}


-(UIImageView*)imageView{
    
    if(!_imageView)
        _imageView = [[UIImageView alloc] initWithImage:[[self myImageModel] imageImageInteger:_indexUse]];
        //_imageView = [[UIImageView alloc] initWithImage:[[self myImageModel] getImageWithName:_imageName]];
        return _imageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.imageView.image = [self.myImageModel getImageWithName:self.imageName];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.image.size;
    self.scrollView.minimumZoomScale = 0.1;
    self.scrollView.delegate=self;
    

}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
