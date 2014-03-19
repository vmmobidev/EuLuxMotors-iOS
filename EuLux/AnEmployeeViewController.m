//
//  AnEmployeeViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/11/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "AnEmployeeViewController.h"
#import "AFNetworking.h"
#import "QuartzCore/QuartzCore.h"

@interface AnEmployeeViewController ()

@property (strong, nonatomic)NSString *firstname, *middleName, *lastName;
@property (strong, nonatomic) NSString *role;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameOfEmployeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleOfEmployeeLabel;

@end

@implementation AnEmployeeViewController
{
    NSMutableArray *arrayOfCellIDs, *arrayOfVales;
    NSString *nameOfEmployee;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%li",(long)[self.employeeID integerValue]);
    arrayOfCellIDs = [[NSMutableArray alloc] init];
    arrayOfVales = [[NSMutableArray alloc] init];
    
    NSString *URLString = [NSString stringWithFormat:@"http://ripple-io.in/Employee/%li",(long)[self.employeeID integerValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer  =[AFJSONRequestSerializer serializer];
    
    [requestSerializer  setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer=requestSerializer;
    
    [manager GET:URLString parameters:Nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             [self getRquestSucessfullWithResponseData:[operation responseData]];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Failure");
         }];
    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    
    self.tableView.layer.borderWidth = 2.0;
    self.tableView.layer.borderColor = [UIColor blackColor].CGColor;
    self.tableView.layer.cornerRadius = 20;
}

- (void)getRquestSucessfullWithResponseData:(NSData *)responseData
{
    NSDictionary *dictionaryFromJSON = [NSJSONSerialization JSONObjectWithData:responseData
                                                                       options:kNilOptions
                                                                         error:Nil];
    
    if (dictionaryFromJSON[@"aaData"][@"Success"])
    {
        NSDictionary *userDictionary = dictionaryFromJSON[@"aaData"][@"User"];
        
        self.firstname = userDictionary[@"FirstName"];
        self.middleName = userDictionary[@"MiddleName"];
        self.lastName = userDictionary[@"LastName"];
        
        self.role = userDictionary[@"Role"];
        
        NSString *tempHolder;
        if (userDictionary[@"Phone"] != [NSNull null])
        {
            tempHolder = userDictionary[@"Phone"];
            if (tempHolder.length != 0)
            {
                [arrayOfCellIDs addObject:@"phoneCell"];
                [arrayOfVales addObject:tempHolder];
            }else
                NSLog(@"lenght is zero for phone");
        }else
            NSLog(@"it null for phone");

        
        if (userDictionary[@"Mobile"] != [NSNull null])
        {
            tempHolder = userDictionary[@"Mobile"];
            if (tempHolder.length != 0)
            {
                [arrayOfCellIDs addObject:@"mobileCell"];
                [arrayOfVales addObject:tempHolder];
            }else
                NSLog(@"lenght is zero for Mobile");
        }else
            NSLog(@"it null for Mobile");
        
        
        if (userDictionary[@"Email"] != [NSNull null])
        {
            tempHolder = userDictionary[@"Email"];
            if (tempHolder.length != 0)
            {
                [arrayOfCellIDs addObject:@"emailCell"];
                [arrayOfVales addObject:tempHolder];
            }else
                NSLog(@"lenght is zero for Email");
        }else
            NSLog(@"it null for Email");
        
        
        if (userDictionary[@"Fax"] != [NSNull null])
        {
            tempHolder = userDictionary[@"Fax"];
            if (tempHolder.length != 0)
            {
                [arrayOfCellIDs addObject:@"faxCell"];
                [arrayOfVales addObject:tempHolder];
            }else
                NSLog(@"lenght is zero for Fax");
        }else
            NSLog(@"it null for Fax");
        
        
        if (userDictionary[@"Address"] != [NSNull null])
        {
            tempHolder = userDictionary[@"Address"];
            if (tempHolder.length != 0)
            {
                [arrayOfCellIDs addObject:@"addressCell"];
                [arrayOfVales addObject:tempHolder];
            }else
                NSLog(@"lenght is zero for Address");
        }else
            NSLog(@"it null for Address");
    }

    nameOfEmployee = [NSString stringWithFormat:@"%@ %@ %@",self.firstname, self.middleName, self.lastName];
    self.nameOfEmployeeLabel.text = nameOfEmployee;
    self.roleOfEmployeeLabel.text = self.role;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfVales count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = arrayOfCellIDs[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    label.text = arrayOfVales[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = arrayOfCellIDs[indexPath.row];

    if ([cellID isEqualToString:@"addressCell"])
    {
        return 100;
    }
    
    return 45;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
