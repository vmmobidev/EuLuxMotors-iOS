//
//  InventoryItemViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/11/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "InventoryItemViewController.h"
#import "InventoryObject.h"

@interface InventoryItemViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@end

@implementation InventoryItemViewController

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
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
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
    return [self.itemsToShow count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tabelView dequeueReusableCellWithIdentifier:@"inventoryItemCell"];
    InventoryObject *anItem = self.itemsToShow[indexPath.row];
    
    UILabel *modelName = (UILabel *)[cell viewWithTag:10];
    modelName.text = anItem.modelName;
    UILabel *transmissionName = (UILabel *)[cell viewWithTag:11];
    transmissionName.text = anItem.transmissionName;
    UILabel *colorName = (UILabel *)[cell viewWithTag:13];
    colorName.text = anItem.colorName;
    UILabel *yearOfManufacture = (UILabel *)[cell viewWithTag:12];
    yearOfManufacture.text = anItem.yearOfManufacture;
    UILabel *supplierName = (UILabel *)[cell viewWithTag:14];
    supplierName.text = anItem.supplierName;
    
    UILabel *supplierWebsite = (UILabel *)[cell viewWithTag:17];
    supplierWebsite.text = anItem.supplierURLString;
    
    UIButton *website = (UIButton *)[cell viewWithTag:15];
    website.frame = supplierWebsite.frame;
    [website addTarget:self action:@selector(showWebSiteForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *MSRP = (UILabel *)[cell viewWithTag:16];
    MSRP.text = [NSString stringWithFormat:@"%i",(int)anItem.MSRP];
    
    return cell;
}

- (void)showWebSiteForButton:(UIButton *)sender
{
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tabelView];
    NSIndexPath *indexPath = [self.tabelView indexPathForRowAtPoint:hitPoint];
    InventoryObject *anItem = self.itemsToShow[indexPath.row];
    
    NSString *URLString = anItem.supplierURLString;
    NSRange rangeOfHTTPSubStirng = [URLString rangeOfString:@"http://"];
    if (rangeOfHTTPSubStirng.location == NSNotFound )
    {
        URLString = [NSString stringWithFormat:@"http://%@",URLString];
    }

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URLString]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
