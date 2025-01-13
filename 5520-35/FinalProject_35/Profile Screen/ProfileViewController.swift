//
//  Untitled.swift
//  FinalProject_35
//
//  Created by Mingxuan Wang on 12/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let postCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapEditProfile), for: .touchUpInside)
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        return button
    }()
    
    private let myPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Posts"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let postsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private var userPosts: [Post] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        setupUI()
        fetchUserProfile()
        fetchUserPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePostAdded), name: NSNotification.Name("PostAddedNotification"), object: nil)
    }
    
    @objc private func handlePostAdded() {
        // Refresh posts when notified
        fetchUserPosts(forceReload: true)
    }
    
    deinit {
        // Remove observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("PostAddedNotification"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserProfile()
        fetchUserPosts()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(postCountLabel)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(editProfileButton)
        view.addSubview(signOutButton)
        view.addSubview(myPostsLabel)
        view.addSubview(postsCollectionView)
        
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        postCountLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        myPostsLabel.translatesAutoresizingMaskIntoConstraints = false
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Sign Out Button
            signOutButton.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5),
            signOutButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Email Label
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Post count Label
            postCountLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            postCountLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            postCountLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            
            // Edit Profile Button
            editProfileButton.topAnchor.constraint(equalTo: postCountLabel.bottomAnchor, constant: 10),
            editProfileButton.leadingAnchor.constraint(equalTo: postCountLabel.leadingAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: postCountLabel.trailingAnchor),
            
            // My Posts Label
            myPostsLabel.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 30),
            myPostsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myPostsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                    
            // Posts Collection View
            postsCollectionView.topAnchor.constraint(equalTo: myPostsLabel.bottomAnchor, constant: 10),
            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }
    
    // MARK: - Fetch User Profile
    private func fetchUserProfile() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch user profile: \(error)")
                return
            }
            guard let data = snapshot?.data() else { return }
            self.nameLabel.text = data["name"] as? String ?? "Unknown Name"
            self.emailLabel.text = currentUser.email ?? "Unknown Email"
            if let avatarURL = data["avatarURL"] as? String {
                self.loadProfileImage(from: avatarURL)
            }
        }
    }
    
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }
    }
    
    // MARK: - Fetch User Posts
    private func fetchUserPosts(forceReload: Bool = false) {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        if !forceReload && !userPosts.isEmpty {
            return
        }
        
        let db = Firestore.firestore()
        
        
        db.collection("posts").whereField("userId", isEqualTo: currentUser.uid).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch user posts: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            let fetchedPosts = documents.compactMap { Post(document: $0) }
            DispatchQueue.main.async {
                if fetchedPosts != self.userPosts { // Prevent redundant UI updates
                    self.userPosts = fetchedPosts
                    self.postCountLabel.attributedText = self.formatPostCount(fetchedPosts.count)
                    self.postsCollectionView.reloadData()
                }
            }
        }
    }
    
    private func formatPostCount(_ count: Int) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: "\(count)  ",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 22),
                .foregroundColor: UIColor.label
            ]
        )
        attributedText.append(NSAttributedString(
            string: "posts",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.secondaryLabel
            ]
        ))
        return attributedText
    }


    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = userPosts[indexPath.item]
        if let imageURL = post.imageURL, let url = URL(string: imageURL) {
            cell.configure(with: url)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2 // Adjust for padding
        return CGSize(width: width, height: width)
    }
    
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = userPosts[indexPath.item] // Retrieve the selected post
        let postDetailVC = PostDetailViewController(postId: selectedPost.id) // Pass the postId to PostDetailViewController
        navigationController?.pushViewController(postDetailVC, animated: true) // Navigate to the PostDetailViewController
    }
    

    // MARK: - Edit Profile
    @objc private func didTapEditProfile() {
        let editProfileVC = EditProfileViewController()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    // MARK: - Sign Out
    @objc private func didTapSignOut() {
        do {
            try Auth.auth().signOut()
            let landingVC = ViewController()
            let navigationController = UINavigationController(rootViewController: landingVC)
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

