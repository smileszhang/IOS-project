//
//  pickerViewController.m
//  try1
//
//  Created by air on 2017/9/6.
//  Copyright © 2017年 smile. All rights reserved.
//

#import "pickerViewController.h"
#import "pickerViewModel.h"

@interface pickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *myPickerData;

@property (strong,nonatomic) pickerViewModel* mypickerViewModel;

@end


//NSArray* timors;

@implementation pickerViewController

@synthesize indexPicker = _indexPicker;

-(pickerViewModel*)mypickerViewModel{
    
    if(!_mypickerViewModel)
        _mypickerViewModel = [pickerViewModel pickerInstance];
    
    return _mypickerViewModel;
}

-(NSInteger)indexPicker{
    
    if(!_indexPicker)
        _indexPicker = 0;
    
    return _indexPicker;
}

//@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = [[NSArray alloc] initWithArray:[[self mypickerViewModel] arrayNameInteger:_indexPicker]]/*@"Horse", @"Sheep", @"Pig", @"Dog", @"Cat", @"Chicken", @"Duck", @"Goose", nil]*/;
    self.myPickerData = array;
    

    
    
    UIPickerView* pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 415, 200)];
 
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];

    
    [pickerView selectRow:1 inComponent:0 animated:YES];
    
    [self.view addSubview:pickerView];
    
}

#pragma mark -UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{

    return _myPickerData.count;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
   
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:@"Congrats"
                          message:[NSString stringWithFormat:@"You've chosen ：%@"
                                   , [_myPickerData objectAtIndex:row]]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark -UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return [_myPickerData objectAtIndex:row];
}




//- (void)viewDidLoad {
 //   [super viewDidLoad];
    // Do any additional setup after loading the view.
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
