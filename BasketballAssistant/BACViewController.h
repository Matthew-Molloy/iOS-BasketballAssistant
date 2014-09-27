//
//  BACViewController.h
//  BasketballAssistant
//
//  Created by Matthew Molloy on 7/26/14.
//  Copyright (c) 2014 Matthew Molloy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BACViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *shotLabelField;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSMutableArray *shotDataArray;
@property (strong, nonatomic) NSNumber *shotPercentage;
@property (strong, nonatomic) NSNumber *shotsMade;
@property (strong, nonatomic) NSNumber *shotCount;
- (IBAction)textFieldReturn:(UITextField*)sender;

@end
