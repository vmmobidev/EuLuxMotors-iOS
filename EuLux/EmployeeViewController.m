//
//  EmployeeViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "EmployeeViewController.h"
#import "AFNetworking.h"
#import "AnEmployeeViewController.h"


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
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.31 green:.46 blue:.99 alpha:1];
    }else
    {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:.31 green:.46 blue:.99 alpha:1]];
    }
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
    
    self.arrayOfEmpNames = [[NSMutableArray alloc] init];
    self.arrayOfEmpId = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer  =[AFJSONRequestSerializer serializer];
    
    [requestSerializer  setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer=requestSerializer;
    
    NSString *stringJSON = @"{\"request\":{\"Name\":\"\",\"GenericSearchViewModel\":{\"Name\":null}}}";

//    NSLog(@"%@",stringJSON);
    NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:[stringJSON dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:kNilOptions
                                                                 error:Nil];
    
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
    NSDictionary *jSONResponse = [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:kNilOptions
                                                                   error:Nil];
    // NSLog(@"%@",jSONResponse);
    
    NSDictionary *aaDataDict = jSONResponse[@"aaData"];
    NSArray *allEmp = aaDataDict[@"GenericSearchViewModels"];
    for (NSDictionary *employeeInfo  in allEmp) {
        [self.arrayOfEmpNames addObject:employeeInfo[@"Name"]];
        [self.arrayOfEmpId addObject:employeeInfo[@"Id"]];
        }
     //NSLog(@"No of Emp   %li",[self.arrayOfEmpNames count]);
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"anEmployeeSegue"])
    {
        NSIndexPath *indexPath = [self.tblView indexPathForSelectedRow];
        AnEmployeeViewController *anEmployee = (AnEmployeeViewController *)segue.destinationViewController;
        anEmployee.employeeID = self.arrayOfEmpId[indexPath.row];
    }
}

@end
