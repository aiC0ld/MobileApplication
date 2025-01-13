//
//  MainViewController.swift
//  FinalProject_35
//
//  Created by Yu huiying on 11/28/24.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class MainViewController: UIViewController {
    
    var mainView = MainScreenView()
    var allPosts: [Post] = []
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.searchBar.delegate = self
        mainView.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "postCell")
        
        fetchAllPosts()
    }
    
    private func fetchAllPosts() {
        let db = Firestore.firestore()
        db.collection("posts").order(by: "createdAt", descending: true).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            guard let documents = snapshot?.documents else {
                self.allPosts = []
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
                return
            }

            // Debugging
            print("Fetched \(documents.count) posts from Firestore")

            self.allPosts = documents.compactMap { Post(document: $0) }
            
            // Debugging
            print("Parsed \(self.allPosts.count) valid posts")

            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (allPosts.count + 1) / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! MainTableViewCell
        
        let firstIndex = indexPath.row * 2
        let secondIndex = firstIndex + 1
        
        // Left post
        if firstIndex < allPosts.count {
            let firstPost = allPosts[firstIndex]
            if let urlString = firstPost.imageURL, let url = URL(string: urlString) {
                cell.leftImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.leftImageView.image = UIImage(named: "placeholder")
            }
            cell.leftLabel.text = firstPost.description
            cell.leftPostTapped = {
                self.showPostDetail(post: firstPost)
            }
        }
        
        // Right post
        if secondIndex < allPosts.count {
            let secondPost = allPosts[secondIndex]
            if let urlString = secondPost.imageURL, let url = URL(string: urlString) {
                cell.rightImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.rightImageView.image = UIImage(named: "placeholder")
            }
            cell.rightLabel.text = secondPost.description
            cell.rightPostTapped = {
                self.showPostDetail(post: secondPost)
            }
            cell.rightPostView.isHidden = false
        } else {
            cell.rightPostView.isHidden = true
        }
        
        return cell
    }
    
    private func showPostDetail(post: Post) {
        let detailVC = PostDetailViewController(postId: post.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: adopting the search bar protocol...
extension MainViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            fetchAllPosts()
        }else{
            let filtered = allPosts.filter { post in
                post.description?.lowercased().contains(searchText.lowercased()) == true
            }
            allPosts = filtered
        }
        self.mainView.tableView.reloadData()
    }
}
