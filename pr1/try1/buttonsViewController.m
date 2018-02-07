//
//  buttonsViewController.m
//  try1
//
//  Created by air on 2017/9/4.
//  Copyright © 2017年 smile. All rights reserved.
//

#import "buttonsViewController.h"
#import "ImageModel.h"

@interface buttonsViewController ()

@property (strong,nonatomic) ImageModel* myImageModel;
@property (nonatomic, weak) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;

@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepperLabel;
@property (weak, nonatomic) IBOutlet UIStepper *myStepper;

@end

@implementation buttonsViewController

@synthesize segmentControl;
@synthesize timerLabel = _timerLabel;


int i = 0;


-(void)timerOn:(id)userinfo {
    NSLog(@"Fire");
    i++;
    _timerLabel.text = [NSString stringWithFormat:@"Timer count: %d",i];
}
- (IBAction)startButtonPressed:(id)sender {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(timerOn:)
                                            userInfo:nil
                                             repeats:YES];
    [_timer fire];
}

- (IBAction)stopPressed:(id)sender {
    
    [_timer invalidate];
    _timer = nil;
    _timerLabel.text = [NSString stringWithFormat:@"Timer stoped: %d",i]; //@"Timer off";
    
}

- (IBAction)moreButtonPressed:(id)sender {
    
    [_timer invalidate];
    _timerLabel.text = @"Timer off";
    
}


-(ImageModel*)myImageModel{
    
    if(!_myImageModel)
        _myImageModel = [ImageModel sharedInstance];
    
    return _myImageModel;
}



- (IBAction)buttonChangeText:(UIButton *)sender {
    self.myLabel.text=@"涮火锅最好吃的是腐竹！";
}

- (IBAction)switchChange:(UISwitch *)sender {
    BOOL isButtonOn = [self.mySwitch isOn];
    if (isButtonOn) {
        self.switchLabel.text=@"Yes";
    }else {
        self.switchLabel.text=@"No";
    }
}

- (IBAction)sliderChange:(id)sender {
    NSString* str=[[NSString alloc] initWithFormat:@"%f",self.mySlider.value*10];
    self.sliderLabel.text=str;
}

- (IBAction)stepperChange:(id)sender {
    NSString* str=[[NSString alloc] initWithFormat:@"%f",self.myStepper.value];
    self.stepperLabel.text=str;
}

- (IBAction)imageDec:(id)sender {
    [self.myImageModel getimageNames];
}


- (IBAction)selected:(id)sender {
    if(segmentControl.selectedSegmentIndex==0){
            self.view.backgroundColor = [UIColor whiteColor];
        
            }
    else if(segmentControl.selectedSegmentIndex==1){

            self.view.backgroundColor = [UIColor grayColor];
            }
    
    else if(segmentControl.selectedSegmentIndex==2){
            self.view.backgroundColor = [UIColor greenColor];
            }
    
    else if(segmentControl.selectedSegmentIndex==3){
            self.view.backgroundColor = [UIColor blueColor];
            }
    
    
    }
    
    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

