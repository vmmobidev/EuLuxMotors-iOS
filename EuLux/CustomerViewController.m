//
//  CustomerViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "CustomerViewController.h"
#import "Customer.h"
#import "CustomerDetailsViewController.h"


@interface CustomerViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CustomerViewController
{
    NSMutableArray *customersArray;
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
    
    NSString *JSONParameterToPost = @"{\"request\":{\"Country\":\"\",\"Name\":\"\",\"Type\":\"Customer\"}}";
    NSString *JSONURLToPOst = @"http://ripple-io.in/GetCustomers";
    Postman *postman = [[Postman alloc] init];
    postman.delegate = self;
    
    [self.activityIndicator startAnimating];
    [postman post:JSONURLToPOst withParameters:JSONParameterToPost];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [customersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    Customer *aCustomer = customersArray[indexPath.row];
    label.text = aCustomer.name;
    return cell;
}

- (void)postman:(Postman *)postman gotFailure:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    NSLog(@"Got failure with error : %@",[error userInfo]);
}

- (void)postman:(Postman *)postman gotSuccess:(NSData *)response
{
    [self.activityIndicator stopAnimating];
    [self parseResponseData:response];
    [self.tableView reloadData];
}

- (void)parseResponseData:(NSData *)response
{
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:Nil];
    NSArray *usersArray = parsedJSON[@"aaData"][@"Users"];
    
    customersArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *anCustomer in usersArray)
    {
        Customer *customer = [[Customer alloc] init];
        customer.userID =  [anCustomer[@"Id"] integerValue];
        customer.name = anCustomer[@"Name"];
        [customersArray addObject:customer];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailsOfCustomerSegue"])
    {
        CustomerDetailsViewController *details = (CustomerDetailsViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Customer *aCustomer = customersArray[selectedIndexPath.row];
        details.userID = aCustomer.userID;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
