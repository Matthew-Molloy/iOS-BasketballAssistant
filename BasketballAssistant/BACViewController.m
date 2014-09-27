//
//  BACViewController.m
//  BasketballAssistant
//
//  Created by Matthew Molloy on 7/26/14.
//  Copyright (c) 2014 Matthew Molloy. All rights reserved.
//

#import "BACViewController.h"
#pragma GCC diagnostic ignored "-Wundeclared-selector"

@interface BACViewController ()
@property (strong, nonatomic) IBOutlet UILabel *shotsMadeToday;
@property (strong, nonatomic) IBOutlet UILabel *shotPercentageToday;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewList;
@property (strong, nonatomic) IBOutlet UILabel *shotCountLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL tableDoNotUpdateFlag;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@end

@implementation BACViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
     if ([segue.destinationViewController isKindOfClass:[BACViewController class]])
        {
         BACViewController *bvc = (BACViewController *)segue.destinationViewController;
         bvc.tableData = self.tableData;
         bvc.shotPercentage = self.shotPercentage;
         bvc.shotCount = self.shotCount;
         bvc.shotsMade = self.shotsMade;
         bvc.tableDoNotUpdateFlag = self.tableDoNotUpdateFlag;
        }
    }

- (IBAction)increment:(UIButton *)sender 
    {
     _tableDoNotUpdateFlag = NO;
     int shotsMade = [_shotsMade intValue];
     shotsMade++;
     _shotsMade = [NSNumber numberWithInt:shotsMade];
     int shotCount = [_shotCount intValue];
     shotCount++;
     _shotCount = [NSNumber numberWithInt:shotCount];
     [self updateUI];
    }

- (IBAction)decrement:(UIButton *)sender
    {
     _tableDoNotUpdateFlag = NO;
     int shotCount = [_shotCount intValue];
     shotCount++;
     _shotCount = [NSNumber numberWithInt:shotCount];
     [self updateUI];
    }

- (void)updateTableData
    {
     if( _tableDoNotUpdateFlag == NO )
        {
         NSDate *date = [NSDate date];
         NSString *displayDate = [NSDate stringForDisplayFromDate:date];
         NSString *shotInfo = [NSString stringWithFormat:@" %d out of %d, %.2lf%%", [_shotsMade intValue], [_shotCount intValue], [_shotPercentage doubleValue]];
         displayDate = [displayDate stringByAppendingString:shotInfo];
         int temp =[_tableData count];
         [_tableData insertObject:displayDate atIndex:temp];
        }
    }

- (void)updateUI
    {
     double shotPercentage;
     double shotsMade = [_shotsMade doubleValue];
     double shotCount = [_shotCount doubleValue];
     if( shotsMade == 0 && shotCount == 0 )
        {
          shotPercentage = 0.0;
        }
     else
        {
         shotPercentage = ( shotsMade / shotCount ) * 100;
        }
     _shotPercentage = [NSNumber numberWithDouble:shotPercentage];
     [_shotsMadeToday setText:[NSString stringWithFormat:@"Shots Made: %d", [_shotsMade intValue]]];
     [_shotPercentageToday setText:[NSString stringWithFormat:@"Shot Percentage: %.2lf%%", [_shotPercentage doubleValue]]];
     [_shotCountLabel setText:[NSString stringWithFormat:@"Shot Count: %d", [_shotCount intValue]]];

     if( [_shotDataArray count] != 0 )
        {
         _removeButton.hidden = NO;
        }
     else
        {
         _removeButton.hidden = YES;
        }
        
     [self updateTableData];
     [self saveData];
    }

// need to save shot data
- (void)saveData
    {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:_shotDataArray forKey:@"shotDataArray"];
     [defaults setObject:_shotCount forKey:@"shotCount"];
     [defaults setObject:_shotPercentage forKey:@"shotPercentage"];
     [defaults setObject:_shotsMade forKey:@"shotsMade"];
     [defaults synchronize];
     [self.pickerViewList reloadAllComponents];
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";

    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) 
        {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
    {
     cell.backgroundColor = cell.contentView.backgroundColor;
    }


- (IBAction)textFieldReturn:(UITextField*)sender
    {
     [ _shotDataArray addObject:sender.text ];
     _removeButton.hidden = NO;
     _tableDoNotUpdateFlag = YES;
     [self updateUI];
     sender.text = @"";
     [sender resignFirstResponder];
    }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    if ([_shotLabelField isFirstResponder] && [touch view] != _shotLabelField)
        {
         [_shotLabelField resignFirstResponder];
        }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)removeSelectedLabel:(UIButton *)sender 
    {
     NSInteger row = [_pickerViewList selectedRowInComponent:0];
     [_shotDataArray removeObjectAtIndex:row];
     [self updateUI];
    }

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [_shotDataArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [_shotDataArray objectAtIndex:row];
}

- (IBAction)changeBackgroundToMatchBackgroundofButton:(UIButton *)sender 
    {
     self.view.backgroundColor = sender.backgroundColor;
     // save theme
     NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:sender.backgroundColor];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:colorData forKey:@"theme"];
     [defaults synchronize];
    }

- (IBAction)resetButton:(UIButton *)sender 
    {
     _shotsMade = [NSNumber numberWithInt:0];
     _shotCount = [NSNumber numberWithInt:0];
     [self updateUI];
    }

- (void)viewWillAppear:(BOOL)animated
    {
     [super viewWillAppear:animated];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         
     // grab 
     if( [defaults objectForKey:@"shotDataArray"] != nil )
        {
         NSMutableArray *temp = [defaults objectForKey:@"shotDataArray"];
         _shotDataArray = [[[NSMutableArray alloc] initWithArray:temp] mutableCopy];
         _removeButton.hidden = NO;
        }
    
     // grab shot data
     _shotsMade = [defaults objectForKey:@"shotsMade"];
     _shotCount = [defaults objectForKey:@"shotCount"];
     _shotPercentage = [defaults objectForKey:@"shotPercentage"];
     
     _tableDoNotUpdateFlag = YES;
     
     [self updateUI];
     
     // grab theme
     NSData *colorData = [defaults objectForKey:@"theme"];
     if( colorData != nil )
        {
         self.view.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        }
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    _removeButton.hidden = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.opaque = NO;
    _tableView.backgroundView = nil;
    if( _tableData == nil )
        {
         _tableData = [[NSMutableArray alloc]init];
        }
    if( _shotDataArray == nil )
        {
         _shotDataArray  = [[NSMutableArray alloc]init];
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
