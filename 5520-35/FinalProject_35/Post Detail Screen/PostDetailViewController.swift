//
//  PostDetailViewController.swift
//  FinalProject_35
//
//  Created by Zhang Xinjia on 2024/12/5.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    private var postId: String
    private var post: Post? {
        didSet {
            updateUI()
        }
    }
    
    private let db = Firestore.firestore()
    
    private var creatorName: String? {
        didSet {
            // Once we have the creator name, update the UI again.
            updateUI()
        }
    }
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let postImageView = UIImageView()
    private let userLabel = UILabel()
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let likesLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    
    private let commentsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Comments"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let commentsTableView = UITableView()
    
    private let commentContainerView = UIView()
    private let commentTextField = UITextField()
    private let sendCommentButton = UIButton(type: .system)
    
    // MARK: - Init
    init(postId: String) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
        title = "Post Detail"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        setupActions()
        
        fetchPost()
        setupKeyboardObservers()
        
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 44

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObservers()
    }
    
    private func setupUI() {
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        
        userLabel.font = UIFont.boldSystemFont(ofSize: 16)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        likesLabel.textColor = .darkGray
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .systemRed
        likeButton.imageView?.contentMode = .scaleAspectFit
        
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "commentCell")
        commentsTableView.isScrollEnabled = false
        commentsTableView.tableFooterView = UIView()
        
        commentTextField.borderStyle = .roundedRect
        commentTextField.placeholder = "Add a comment..."
        sendCommentButton.setTitle("Send", for: .normal)
        sendCommentButton.setTitleColor(.systemBlue, for: .normal)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(postImageView)
        contentView.addSubview(userLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(likesLabel)
        contentView.addSubview(commentsTitleLabel)
        contentView.addSubview(commentsTableView)
        
        view.addSubview(commentContainerView)
        commentContainerView.addSubview(commentTextField)
        commentContainerView.addSubview(sendCommentButton)
        
        commentContainerView.backgroundColor = .secondarySystemBackground
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        commentsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        commentContainerView.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        sendCommentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView full screen
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: commentContainerView.topAnchor),
            
            // contentView matches scrollView width and anchors
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // We'll set bottom after setting all subviews
            
            // Post Image
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // User & Date
            userLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 12),
            userLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            dateLabel.centerYAnchor.constraint(equalTo: userLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: userLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            
            // Likes and Like Button
            likeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            likeButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            
            likesLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            
            // Comments Title
            commentsTitleLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 20),
            commentsTitleLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            commentsTitleLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            
            // Comments Table View
            commentsTableView.topAnchor.constraint(equalTo: commentsTitleLabel.bottomAnchor, constant: 8),
            commentsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Comment Container View
            commentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            commentContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            commentTextField.centerYAnchor.constraint(equalTo: commentContainerView.centerYAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: commentContainerView.leadingAnchor, constant: 16),
            
            sendCommentButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            sendCommentButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: 8),
            sendCommentButton.trailingAnchor.constraint(equalTo: commentContainerView.trailingAnchor, constant: -16),
            
            // Set bottom of contentView to commentsTableView bottom + constant
            commentsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        let tableHeightConstraint = commentsTableView.heightAnchor.constraint(equalToConstant: 300)
        tableHeightConstraint.isActive = true
    }
    
    private func setupActions() {
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        sendCommentButton.addTarget(self, action: #selector(didTapSendComment), for: .touchUpInside)
    }
    
    // MARK: - Fetch & Update Post
    private func fetchPost() {
        db.collection("posts").document(postId).getDocument { [weak self] doc, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch post: \(error)")
                return
            }
            guard let doc = doc, doc.exists, let post = Post(document: doc) else {
                print("Post not found or invalid")
                return
            }
            self.post = post
        }
    }
    
    private func updateUI() {
        guard let post = post else { return }
        
        if let userId = Auth.auth().currentUser?.uid, post.likesUserIds.contains(userId) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        // Update image
        if let urlString = post.imageURL, let url = URL(string: urlString) {
            postImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            postImageView.image = UIImage(named: "placeholder")
        }
        
        // Update user name
        print("creatorName: \(creatorName ?? "nil"), post.username: \(post.username ?? "nil"), post.userId: \(post.userId ?? "nil")")
        userLabel.text = "By: \(post.username ?? creatorName ?? post.userId ?? "Unknown")"

        // Update date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: post.createdAt)
        
        // Description
        descriptionLabel.text = post.description
        
        // Likes
        likesLabel.text = "\(post.likes) likes"
        
        // Update comments title with count
        commentsTitleLabel.text = "Comments (\(post.comments.count))"
        
        // Debugging: print the number of comments
        print("Loaded \(post.comments.count) comments")
        
        commentsTableView.reloadData()
        
        // Adjust content size after updating
//        DispatchQueue.main.async {
//            self.adjustScrollViewContentSize()
//        }
    }
    
    private func adjustScrollViewContentSize() {
        self.contentView.layoutIfNeeded()
        let contentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.contentView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
        self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.width, height: contentHeight)
    }
    
    @objc private func didTapLike() {
        guard let post = post, let userId = Auth.auth().currentUser?.uid else {
            return
        }

        // Check if the user has already liked the post
        if let index = post.likesUserIds.firstIndex(of: userId) {
            // User has already liked, so unlike the post
            var updatedLikesUserIds = post.likesUserIds
            updatedLikesUserIds.remove(at: index)
            updateLikeStatus(post: post, likesUserIds: updatedLikesUserIds, isLiked: false)
        } else {
            // User has not liked, so like the post
            var updatedLikesUserIds = post.likesUserIds
            updatedLikesUserIds.append(userId)
            updateLikeStatus(post: post, likesUserIds: updatedLikesUserIds, isLiked: true)
        }
    }


    private func updateLikeStatus(post: Post, likesUserIds: [String], isLiked: Bool) {
        // Update the likes and likesUserIds in Firestore
        db.collection("posts").document(post.id).updateData([
            "likes": isLiked ? post.likes + 1 : post.likes - 1,
            "likesUserIds": likesUserIds
        ]) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to update like status: \(error)")
                return
            }

            // Update the local post data
            self.post?.likesUserIds = likesUserIds
            self.post?.likes = isLiked ? post.likes + 1 : post.likes - 1
            self.updateUI() // Update the UI to reflect the new like status
            
            // Update the like button icon
            self.likeButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
        }
    }



    
    @objc private func didTapSendComment() {
        guard let text = commentTextField.text, !text.isEmpty, let post = post else { return }
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not signed in")
            return
        }
        
        // Fetch the current user's name from users
        db.collection("users").document(userId).getDocument { [weak self] doc, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch user name: \(error)")
                return
            }
            guard let doc = doc, doc.exists else {
                print("No contact record found for the current user, using 'Unknown'")
                self.addCommentToPost(post: post, userId: userId, username: "Unknown", text: text)
                return
            }
            
            let contact = Contact(document: doc)
            let username = contact?.name ?? "Unknown"
            self.addCommentToPost(post: post, userId: userId, username: username, text: text)
        }
    }

    private func addCommentToPost(post: Post, userId: String, username: String, text: String) {
        let newComment: [String: Any] = [
            "userId": userId,
            "username": username,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]

        var updatedComments = post.comments.map { c in
            [
                "userId": c.userId,
                "username": c.username,
                "text": c.text,
                "timestamp": Timestamp(date: c.timestamp)
            ]
        }
        updatedComments.append(newComment)
        
        db.collection("posts").document(post.id).updateData(["comments": updatedComments]) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to add comment: \(error)")
                return
            }
            self.commentTextField.text = ""
            self.fetchPost() // Refresh the post to display the new comment
        }
    }

    
    // MARK: - Comments Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        guard let comment = post?.comments[indexPath.row] else { return cell }
        cell.textLabel?.text = "\(comment.username): \(comment.text)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleKeyboardShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomInset + 50
        scrollView.scrollIndicatorInsets.bottom = bottomInset + 50
    }
    
    @objc private func handleKeyboardHide() {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
}
