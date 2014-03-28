//
//  SecondViewController.m
//  EuLux
//
//  Created by Varghese Simon on 2/28/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrderDetail.h"
#import "OrderListDetailsViewController.h"

@interface OrdersViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrdersViewController
{
    NSMutableArray *arrayOfFinalOrders;
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
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:194.0/255.0 green:54.0/255.0 blue:42.0/255.0 alpha:1];
    }else
    {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:.31 green:.46 blue:.99 alpha:1]];
    }
    
    arrayOfFinalOrders = [[NSMutableArray alloc] init];
    
    Postman *postman = [[Postman alloc] init];
    postman.delegate = self;
    
    [postman get:@"http://ripple-io.in//AllOrders"];
    
}

- (void)postman:(Postman *)postman gotFailure:(NSError *)error
{
    NSLog(@"Failure");
}

- (void)postman:(Postman *)postman gotSuccess:(NSData *)response
{
    NSLog(@"Sucess");
    [self parseResponseData:response];
}

- (void)parseResponseData:(NSData *)response
{
    NSDictionary *dictionaryFromJSON = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
    NSArray *orderDetails = dictionaryFromJSON[@"aaData"][@"OrderDetails"];
    
    for (NSDictionary *orderDict in orderDetails)
    {
        OrderDetail *anOrder = [[OrderDetail alloc] init];
        anOrder.code = orderDict[@"Code"];
        anOrder.orderDate = orderDict[@"OrderDate"];
        
        
        NSData *dataFromSubJSON = [orderDict[@"JSON"] dataUsingEncoding:NSUTF8StringEncoding];
        
        anOrder.detailsInJSON = [NSJSONSerialization JSONObjectWithData:dataFromSubJSON options:kNilOptions error:nil];
        
        NSDictionary *orderDetailsFromsubJSON = anOrder.detailsInJSON[@"Order"];
        anOrder.status = orderDetailsFromsubJSON[@"OrderInfo"][@"StatusName"];
        
        if (CheckWhetherArrayIsEmpty(orderDetailsFromsubJSON[@"Products"]))
        {
            anOrder.brandName = orderDetailsFromsubJSON[@"Products"][0][@"BrandName"];
            anOrder.modelName = orderDetailsFromsubJSON[@"Products"][0][@"ModelName"];

        } else
        {
            anOrder.brandName = @" ";
            anOrder.modelName = @" ";
        }
        
        [arrayOfFinalOrders addObject:anOrder];
    }
    
    [self.tableView reloadData];
    NSLog(@"%i",[arrayOfFinalOrders count]);
    
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
    return [arrayOfFinalOrders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    OrderDetail *currentOrder = arrayOfFinalOrders[indexPath.row];
    
    UILabel *brandName = (UILabel *)[cell viewWithTag:100];
    UILabel *modelName = (UILabel *)[cell viewWithTag:101];
    UILabel *orderDate = (UILabel *)[cell viewWithTag:102];
    UILabel *status = (UILabel *)[cell viewWithTag:103];

    brandName.text = currentOrder.brandName;
    modelName.text = currentOrder.modelName;
    orderDate.text = currentOrder.orderDate;
    status.text = currentOrder.status;
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"disclouserBtn.png"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"orderListSegue"])
    {
        OrderListDetailsViewController *orderListViewController = (OrderListDetailsViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        orderListViewController.selectedOrderDetail = arrayOfFinalOrders[selectedIndexPath.row];
    }
}

@end
