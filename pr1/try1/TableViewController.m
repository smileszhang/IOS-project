//
//  TableViewController.m
//  try1
//
//  Created by smile on 2017/8/28.
//  Copyright © 2017年 smile. All rights reserved.
//

#import "TableViewController.h"
#import "ImageModel.h"
#import "ViewController.h"
#import "WebModel.h"
#import "webviewcontroller.h"
#import "pickerViewModel.h"
#import "pickerViewController.h"


@interface TableViewController ()

@property (strong,nonatomic) ImageModel* myImageModel;
@property (strong,nonatomic) pickerViewModel* mypickerViewModel;
@property (strong,nonatomic) WebModel* myWebModel;



@end

@implementation TableViewController

-(ImageModel*)myImageModel{
    
    if(!_myImageModel)
        _myImageModel = [ImageModel sharedInstance];
    
    return _myImageModel;
}

-(pickerViewModel*)mypickerViewModel{
    
    if(!_mypickerViewModel)
        _mypickerViewModel = [pickerViewModel pickerInstance];
    
    return _mypickerViewModel;
}

-(WebModel*)myWebModel{
    
    if(!_myWebModel)
        _myWebModel = [WebModel sharedInstance];
    
    return _myWebModel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of rows
    if(section==0){
        return [self.myImageModel imageNum] ;
    }
    
    else if(section==2){
        return  [self.myWebModel webNum];
    }
    else if(section==3){
        NSInteger i= [self.mypickerViewModel arrayNum];
        return i;
    }

    
    else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if(indexPath.section==0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ImageNameCell" forIndexPath:indexPath];
        
        
        
        // Configure the cell...
       
        //cell.textLabel.text = self.myImageModel.imageNames[indexPath.row];
        cell.textLabel.text = [self.myImageModel imageNameInteger:indexPath.row];
        cell.detailTextLabel.text = @"More";
    
    }
   
    else if(indexPath.section ==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionCell" forIndexPath:indexPath];
        
        
        // Configure the cell...
        cell.textLabel.text = @"collection";
    }
    
    else if(indexPath.section ==2){
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"webViewCell" forIndexPath:indexPath];
        
        cell.textLabel.text = [self.myWebModel webLinksInteger:indexPath.row];

    }
    
    else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"pickerViewCell" forIndexPath:indexPath];
            
            
            // Configure the cell...
        cell.textLabel.text = [self.mypickerViewModel arrayArrayInteger:indexPath.row];
    }
    
        
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    BOOL isVC = [[segue destinationViewController] isKindOfClass: [ViewController class]];
    BOOL isWC = [[segue destinationViewController] isKindOfClass:[webviewcontroller class]];
    BOOL isPVC = [[segue destinationViewController] isKindOfClass: [pickerViewController class]];

    if (isVC) {
        UITableViewCell* cell = (UITableViewCell*)sender;
        ViewController *vc = [segue destinationViewController];
    
        vc.indexUse = [self.tableView indexPathForCell:cell].row;
        
    }
    else if(isWC){
        UITableViewCell* cell = (UITableViewCell*)sender;
        webviewcontroller* wc = [segue destinationViewController];
        wc.indexUseWeb=[self.tableView indexPathForCell:cell].row;
    }

    else if(isPVC){
        
        UITableViewCell* cell = (UITableViewCell*)sender;
        pickerViewController *pvc = [segue destinationViewController];
        
        pvc.indexPicker = [self.tableView indexPathForCell:cell].row;
    
    }
   
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
