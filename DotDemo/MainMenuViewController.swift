//
//  MainMenuViewController.swift
//  Dot
//
//  Created by Titus Cheng on 11/3/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate
{
    
    @IBOutlet weak var menuViewController: DotTableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewController.delegate = self
        menuViewController.dataSource = self
        menuViewController.multipleTouchEnabled = true
        self.menuViewController.registerNib(UINib(nibName: Data.menuItemNibName(), bundle: nil), forCellReuseIdentifier: Data.menuItemNibID())
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MenuItem = tableView.dequeueReusableCellWithIdentifier(Data.menuItemNibID()) as MenuItem
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.itemLabel.text = Data.menuNames()[indexPath.row]
        if(!Data.menuDestinationIDS()[indexPath.row].isEmpty) {
            let vc: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Data.menuDestinationIDS()[indexPath.row]) as UIViewController
            cell.viewController = self
            cell.destinationController = vc
        } else {
            cell.viewController = nil
            cell.destinationController = nil
        }
        cell.multipleTouchEnabled = true

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.menuNames().count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Data.menuItemHeight()
    }
    
}
