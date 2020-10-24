//
//  UIRefreshControl+ProgramaticallyBeginRefresh.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/23/20.
//

import UIKit

/*
 UIRefreshControl - beginRefreshing not working when UITableViewController is inside UINavigationController
 https://stackoverflow.com/questions/14718850/uirefreshcontrol-beginrefreshing-not-working-when-uitableviewcontroller-is-ins
 
 It seems that if you start refreshing programmatically, you have to scroll the table view yourself, say, by changing contentoffset
 */
extension UIRefreshControl {
    func programaticallyBeginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
}
