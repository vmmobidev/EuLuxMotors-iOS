//
//  EmployeeViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "EmployeeViewController.h"
#import "AFNetworking.h"


@interface EmployeeViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (strong, nonatomic) IBOutlet UILabel *empName;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation EmployeeViewController

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
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
    
    self.arrayOfEmpNames = [[NSMutableArray alloc] init];
    self.arrayOfEmpId = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer  =[AFJSONRequestSerializer serializer];
    
    [requestSerializer  setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer=requestSerializer;
    NSString *stringJSON = @"{\"request\":{\"Name\":\"\",\"GenericSearchViewModel\":{\"Name\":\"\"}}}";
    NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:[stringJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:Nil];
    
    [self.activityIndicator startAnimating];
    
    [manager POST:@"http://ripple-io.in/Search/Employee" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSData *responseData = [operation responseData];
         [self postRequestSuccessfulWithObject:responseData];
         [self.tblView reloadData];
         [self.activityIndicator stopAnimating];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",error);
           [self.activityIndicator stopAnimating];
     }];
    
}

- (void)postRequestSuccessfulWithObject:(NSData *)responseData
{
    NSDictionary *jSONResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
    // NSLog(@"%@",jSONResponse);
    
    NSDictionary *aaDataDict = jSONResponse[@"aaData"];
    NSArray *allEmp = aaDataDict[@"GenericSearchViewModels"];
    for (NSDictionary *employeeInfo  in allEmp) {
        [self.arrayOfEmpNames addObject:employeeInfo[@"Name"]];
        [self.arrayOfEmpId addObject:employeeInfo[@"Id"]];
        }
     NSLog(@"safdva   %i",[self.arrayOfEmpNames count]);
}
#pragma mark
#pragma UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.arrayOfEmpNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = [self.arrayOfEmpNames objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark
#pragma UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
