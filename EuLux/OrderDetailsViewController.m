//
//  OrderDetailsViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/25/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "OrderInfo.h"
#import "CustomerInfo.h"
#import "BillingNShippingInfo.h"
#import "AddressInfo.h"
#import "ProductInfo.h"
#import "ServicesInfo.h"

@interface OrderDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderDetailsViewController
{
    NSArray *dataForTable, *titlesForTable, *sectionHeaders;
    NSInteger numberOfSections;
    
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
    
    switch (self.sectionOfDetail)
    {
        case 0:
        {
            OrderInfo *orderInfo = [[OrderInfo alloc] initWithDetailedDict:self.selectedOrder.detailsInJSON];
            dataForTable = orderInfo.arrayOfDatas;
            titlesForTable = orderInfo.arrayOfTitles;
            sectionHeaders = orderInfo.arrayOsSectionTitles;
            numberOfSections = orderInfo.numberOfSections;
        }
            break;
            
        case 1:
        {
            CustomerInfo *customerInfo = [[CustomerInfo alloc] initWithDetailedDict:self.selectedOrder.detailsInJSON];
            dataForTable = customerInfo.arrayOfDatas;
            titlesForTable = customerInfo.arrayOfTitles;
            sectionHeaders = customerInfo.arrayOsSectionTitles;
            numberOfSections = customerInfo.numberOfSections;
        }
            break;
            
        case 2:
        {
            BillingNShippingInfo *billngInfo = [[BillingNShippingInfo alloc] initWithDetailedDict:self.selectedOrder.detailsInJSON];
            dataForTable = billngInfo.arrayOfDatas;
            titlesForTable = billngInfo.arrayOfTitles;
            sectionHeaders = billngInfo.arrayOsSectionTitles;
            numberOfSections = billngInfo.numberOfSections;
        }
            break;
            
        case 3:
        {
            AddressInfo *addressInfo = [[AddressInfo alloc] initWithDetailedDict:self.selectedOrder.detailsInJSON];
            dataForTable = addressInfo.arrayOfDatas;
            titlesForTable = addressInfo.arrayOfTitles;
            sectionHeaders = [addressInfo getSectionTitles];
            numberOfSections = addressInfo.numberOfSections;
        }
            break;
            
        case 4:
        {
            ProductInfo *productInfo = [[ProductInfo alloc] initWithDetailedDict:self.selectedOrder.detailsInJSON];
            dataForTable = productInfo.arrayOfDatas;
            titlesForTable = productInfo.arrayOfTitles;
            sectionHeaders = [productInfo getSectionTitlesFrom:self.selectedOrder.detailsInJSON];
            numberOfSections = productInfo.numberOfSections;
        }
            break;
            
        case 6:
        {
            ServicesInfo *serviceInfo = [[ServicesInfo alloc] initWithDetailedDict:self.selectedOrder.detailsInJSON];
            dataForTable = serviceInfo.arrayOfDatas;
            titlesForTable = serviceInfo.arrayOfTitles;
            sectionHeaders = [serviceInfo getSectionTitlesFrom:self.selectedOrder.detailsInJSON];
            numberOfSections = serviceInfo.numberOfSections;
        }
            break;
        default:
            break;
    }
    

    

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%i",[dataForTable[section] count]);
    return [dataForTable[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
    titleLabel.text = titlesForTable[indexPath.section][indexPath.row];
//    [titleLabel sizeToFit];
    
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:11];
    detailLabel.text = dataForTable[indexPath.section][indexPath.row];
//    [detailLabel sizeToFit];
    
//    CGRect frameOfCurrentCell = [tableView rectForRowAtIndexPath:indexPath];
//    
//    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, frameOfCurrentCell.size.height - 1.0, frameOfCurrentCell.size.width, 1)];
//    seperator.backgroundColor = [UIColor redColor];
//    seperator.alpha = 0.8;
//
//    [cell.contentView addSubview:seperator];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightOfCell;
    
    NSString *titleLableText = titlesForTable[indexPath.section][indexPath.row];
    CGSize expectedSizeOfTitleLable = [titleLableText sizeWithFont:[UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:16] constrainedToSize:(CGSizeMake(70, 10000)) lineBreakMode:(NSLineBreakByWordWrapping)];
    
    
    NSString *dataLableText = dataForTable[indexPath.section][indexPath.row];
    CGSize expectedSizeOfDataLable = [dataLableText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] constrainedToSize:(CGSizeMake(165, 10000)) lineBreakMode:(NSLineBreakByWordWrapping)];
    
    heightOfCell = 10*2 + MAX(expectedSizeOfDataLable.height, expectedSizeOfTitleLable.height);
    
    return heightOfCell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([sectionHeaders count] >= 1)
    {
        UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        viewForHeader.backgroundColor = [UIColor clearColor];
        viewForHeader.layer.cornerRadius = 5;
        viewForHeader.alpha = 1;
        
        UIView *containerViewForLabel = [[UIView alloc] initWithFrame:viewForHeader.frame];
        containerViewForLabel.backgroundColor = [UIColor colorWithRed:1 green:152.0/255.0 blue:135.0/255.0 alpha:1];
        containerViewForLabel.alpha = .9;
        [viewForHeader addSubview:containerViewForLabel];
        
        UILabel *labelForHeader = [[UILabel alloc] initWithFrame:(CGRectMake(10, 5, 100, 40))];
        labelForHeader.text = sectionHeaders[section];
        labelForHeader.backgroundColor = [UIColor clearColor];
        labelForHeader.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        labelForHeader.textColor = [UIColor whiteColor];
        [labelForHeader sizeToFit];
        
        [viewForHeader addSubview:labelForHeader];
        
        return viewForHeader;
    }
    return [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 0, 0))];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 0, 0))];
}

@end
