//
//  PostViewController.swift
//  FinalProject_35
//
//  Created by Yu huiying on 11/28/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create a New Post"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.layer.cornerRadius = 10
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let imagePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to select an image"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionTextView = UITextView()
    private let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Write a description..."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let publishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Publish Post", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupConstraints()
        setupActions()
        
        // Observe text changes to show/hide placeholder label
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: descriptionTextView)
        
        // Handle keyboard to improve user experience
        setupKeyboardObservers()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        imageView.addSubview(imagePlaceholderLabel)
        
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 10
        contentView.addSubview(descriptionTextView)
        descriptionTextView.addSubview(descriptionPlaceholderLabel)
        
        contentView.addSubview(publishButton)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imagePlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        publishButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView full screen
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView matches scrollView width, flexible height
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // ImageView
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Image Placeholder Label
            imagePlaceholderLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imagePlaceholderLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            // DescriptionTextView
            descriptionTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 150),
            
            // Description Placeholder
            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 8),
            
            // Publish Button
            publishButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 120),
            publishButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            publishButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupActions() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelectImage))
        imageView.addGestureRecognizer(imageTapGesture)
        
        publishButton.addTarget(self, action: #selector(didTapPublish), for: .touchUpInside)
    }
    
    @objc private func handleTextChange() {
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    @objc private func didTapSelectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc private func didTapPublish() {
        guard let image = imageView.image else {
            showAlert(title: "No Image Selected", message: "Please select an image before publishing.")
            return
        }
        showActivityIndicator()
        let description = descriptionTextView.text ?? ""
        uploadImageToStorage(image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageURL):
                self.createPost(description: description, imageURL: imageURL)
            case .failure(let error):
                self.showAlert(title: "Upload Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            imagePlaceholderLabel.isHidden = true
        }
    }
    
    // MARK: - Firebase Helpers
    private func uploadImageToStorage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG"])))
            return
        }
        
        let filename = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference().child("post_images/\(filename)")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.failure(NSError(domain: "DownloadURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "No download URL"])))
                    return
                }
                
                completion(.success(downloadURL.absoluteString))
            }
        }
    }
    
    private func createPost(description: String, imageURL: String) {
        let db = Firestore.firestore()
        let postID = UUID().uuidString
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            showAlert(title: "Not Signed In", message: "You must be signed in to create a post.")
            return
        }

        // Fetch the user's contact to get the name
        db.collection("users").document(currentUserId).getDocument { [weak self] doc, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch user name: \(error)")
                // If fetch fails, you can decide to use a placeholder username
                self.storePost(db: db, postID: postID, imageURL: imageURL, description: description, username: "Unknown", userId: currentUserId)
                return
            }

            if let doc = doc, doc.exists, let contact = Contact(document: doc) {
                let username = contact.name // Extract user’s name from contact
                self.storePost(db: db, postID: postID, imageURL: imageURL, description: description, username: username, userId: currentUserId)
            } else {
                // If contact not found, fallback to "Unknown"
                self.storePost(db: db, postID: postID, imageURL: imageURL, description: description, username: "Unknown", userId: currentUserId)
            }
        }
    }

    private func storePost(db: Firestore, postID: String, imageURL: String, description: String, username: String, userId: String) {
        let postData: [String: Any] = [
            "imageURL": imageURL,
            "description": description,
            "userId": userId,
            "username": username, // Store the username here
            "likes": 0,
            "comments": [],
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("posts").document(postID).setData(postData) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(title: "Error", message: "Could not save post. Try again.\n\(error.localizedDescription)")
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("PostAddedNotification"), object: nil)
                self.showAlert(title: "Success", message: "Your post has been published!")
                hideActivityIndicator()
                resetPostFields()
            }
        }
    }
    
    private func resetPostFields() {
        imageView.image = nil
        imagePlaceholderLabel.isHidden = false
        descriptionTextView.text = ""
        descriptionPlaceholderLabel.isHidden = false
    }

    // MARK: - Alert Helper
    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if completion == nil {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        }
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard Handling (Optional)
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomInset + 20
        scrollView.scrollIndicatorInsets.bottom = bottomInset + 20
    }
    
    @objc private func handleKeyboardHide() {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
}

