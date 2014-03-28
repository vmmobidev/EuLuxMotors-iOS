//
//  OrderListDetailsViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/24/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "OrderListDetailsViewController.h"
#import "OrderDetailsViewController.h"

@interface OrderListDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderListDetailsViewController
{
    NSArray *arrayOfTitles;
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
    
    arrayOfTitles = @[@"Order Info", @"Customer Info", @"Billing & Shipping Info", @"Address Info", @"Product", @"Accessories", @"Services", @"Notes", @"Freight Forwarding", @"Shipping & Transportation"];
    
    NSLog(@"%@",self.selectedOrderDetail.modelName);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    label.text = arrayOfTitles[indexPath.row];
    
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    seperator.backgroundColor = [UIColor redColor];
    seperator.alpha = 0.8;
    [cell.contentView addSubview:seperator];
    
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"disclouserBtn1.png"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OrderDetailsSegue"])
    {
        OrderDetailsViewController *orderDetailViewController = (OrderDetailsViewController *)segue.destinationViewController;
        orderDetailViewController.selectedOrder = self.selectedOrderDetail;
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        orderDetailViewController.sectionOfDetail = selectedIndexPath.row;
    }
}
@end
