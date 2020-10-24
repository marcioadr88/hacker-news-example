//
//  ViewController.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/22/20.
//

import UIKit
import SafariServices

class PostsListViewController: UIViewController {
    // the reuse cell's identifier
    private static let cellId = "postCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    // create the controller for this particular base URL and Repository
    private lazy var newsController: NewsController = {
        let apiClient = APIClientImpl(baseURL: "http://hn.algolia.com")
        let postsRepository = PostsRepositoryImpl(apiClient: apiClient)
        
        return NewsControllerImpl(repository: postsRepository)
    }()
    
    /// The posts showing in the table view
    private var posts: [Post] = []
    
    // shorthand for tableView.refreshControl
    private var refreshControl: UIRefreshControl? {
        get {
            tableView.refreshControl
        }
        
        set {
            tableView.refreshControl = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegates
        tableView.dataSource = self
        tableView.delegate = self
        newsController.delegate = self
        
        // for the table view refresh control
        setupRefreshControl()
                
        // workaround to show the refresh controller programatically
        refreshControl?.programaticallyBeginRefreshing(in: tableView)
        
        // refresh the list after loading the VC
        newsController.refresh()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    /// called then the user swipes to refresh
    @objc private func refreshData(_ sender: Any) {
        newsController.refresh()
    }
    
    /// show a web view with the url
    private func showPost(url urlString: String) {
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
}

// MARK: SFSafariViewControllerDelegate
extension PostsListViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension PostsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        if let storyURL = post.url {
            showPost(url: storyURL)
        } else {
            let alertVC = AlertUtils.buildAlertController(title: "Error", message: NSLocalizedString("This post does not provide a valid URL", comment: ""))
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: UITableViewDataSource
extension PostsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsListViewController.cellId) as? PostViewCell else {
            return UITableViewCell()
        }

        // configure the cell with the corresponding post
        cell.post = posts[indexPath.row]
        cell.selectionStyle = .none

        cell.setNeedsLayout()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // hide the post for the swiped row
        if editingStyle == .delete {
            let post = posts[indexPath.row]
            newsController.hidePost(post)
        }
    }
}

// MARK: NewControllerDelegate
extension PostsListViewController: NewsControllerDelegate {
    func error(error: AppError) {
        switch error {
        case .invalidBaseURL, .invalidEndpoindURL:
            let alertVC = AlertUtils.buildAlertController(title: "Error", message: error.localizedDescription)
            present(alertVC, animated: true, completion: nil)
            
        default:
            print("An error ocurred: \(error.localizedDescription)")
        }
    }
    
    func update(results: [Post], deletions: [Int], insertions: [Int], modifications: [Int]) {
        posts = results // update the posts with the new data
        
        // update only the rows affected by the change
        tableView.beginUpdates()
        
        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                             with: .automatic)
        
        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}),
                             with: .automatic)
        
        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}),
                             with: .automatic)
        
        tableView.endUpdates()
    }
    
    func initial(results: [Post]) {
        posts = results // update the posts with the new data
        tableView.reloadData() // load all data at once because is the first time
    }
    
    func beginRefreshing() {
        // start the refresh control animation
        DispatchQueue.main.async {  [weak self] in
            self?.tableView.refreshControl?.beginRefreshing()
        }
    }
    
    func endRefreshing() {
        // end the refresh control animation
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
}
