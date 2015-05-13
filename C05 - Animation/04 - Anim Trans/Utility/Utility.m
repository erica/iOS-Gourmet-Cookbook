//
//  Utility.m
//  Hello World
//
//  Created by Erica Sadun on 1/28/15.
//  Copyright (c) 2015 Erica Sadun. All rights reserved.
//

#import "Utility.h"

CGFloat Random01()
{
    return ((CGFloat) arc4random() / (CGFloat) UINT_MAX);
}

UIColor *Random_Color()
{
    return [UIColor colorWithRed:Random01() green:Random01() blue:Random01() alpha:1.0];
}

CGRect RectAroundCenter(CGPoint center, CGSize size)
{
    CGFloat halfWidth = size.width / 2.0f;
    CGFloat halfHeight = size.height / 2.0f;
    
    return CGRectMake(center.x - halfWidth, center.y - halfHeight, size.width, size.height);
}

CGPoint RectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

UIImage *BlockImage()
{
    CGFloat inset = 10.0;
    CGSize backgroundSize = CGSizeMake(512, 512);
    CGRect bounds = (CGRect){.size = backgroundSize};
    
    UIGraphicsBeginImageContext(backgroundSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw white backdrop
    [[UIColor whiteColor] set];
    UIRectFill(bounds);
    
    // Prepare for the inset children
    CGRect insetBounds = CGRectInset(bounds, inset, inset);
    int numChildren = 4 + rand() % 4;
    
    for (int i = 0; i < numChildren; i++)
    {
        [Random_Color() set];
        CGFloat randX = insetBounds.origin.x + (insetBounds.size.width * .7) * (rand() % 1000) / 1000.0;
        CGFloat dx = insetBounds.size.width - randX;
        CGFloat randW = dx * (0.5f + (rand() % 1000) / 2000.0);
        
        CGFloat randY = insetBounds.origin.y + (insetBounds.size.height * .7) * (rand() % 1000) / 1000.0;
        CGFloat dy = insetBounds.size.height - randY;
        CGFloat randH = dy * (0.5f + (rand() % 1000) / 2000.0);
        
        // Add the tinted child view
        CGRect childBounds = CGRectMake(randX, randY, randW, randH);
        CGContextAddEllipseInRect(context, childBounds);
        CGContextFillPath(context);
        
        [[UIColor blackColor] set];
        CGContextAddEllipseInRect(context, childBounds);
        CGContextSetLineWidth(context, 3.0);
        CGContextStrokePath(context);
    }
    
    static CGFloat ith = 1;
    CGRect r = RectAroundCenter(RectGetCenter(bounds), CGSizeMake(100, 100));
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:@(ith++).stringValue attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:64]}];
    [as drawInRect:r];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
