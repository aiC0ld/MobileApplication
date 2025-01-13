//
//  EditProfileViewController.swift
//  FinalProject_35
//
//  Created by Mingxuan Wang on 12/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

class EditProfileViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapChangePhoto), for: .touchUpInside)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.font = .systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return button
    }()
    
    private var selectedImage: UIImage?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        setupUI()
        fetchCurrentUserData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(changePhotoButton)
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            changePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Fetch Current User Data
    private func fetchCurrentUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user data: \(error)")
                return
            }
            guard let data = snapshot?.data() else { return }
            self.nameTextField.text = data["name"] as? String ?? ""
            if let avatarURL = data["avatarURL"] as? String, let url = URL(string: avatarURL) {
                self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.circle"))
            }
        }
    }
    
    // MARK: - Change Photo
    @objc private func didTapChangePhoto() {
        let alert = UIAlertController(title: "Choose Profile Photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.openCamera() }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in self.openGallery() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Save Changes
    @objc private func didTapSave() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let name = nameTextField.text, !name.isEmpty else {
            print("Name cannot be empty")
            return
        }
        
        let db = Firestore.firestore()
        if let image = selectedImage {
            uploadProfileImage(image) { [weak self] avatarURL in
                guard let self = self, let avatarURL = avatarURL else { return }
                db.collection("users").document(currentUser.uid).updateData(["name": name, "avatarURL": avatarURL]) { error in
                    if let error = error {
                        print("Failed to update profile: \(error)")
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            db.collection("users").document(currentUser.uid).updateData(["name": name]) { error in
                if let error = error {
                    print("Failed to update name: \(error)")
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func uploadProfileImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let filename = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference().child("avatars/\(filename)")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, _ in completion(url?.absoluteString) }
        }
    }
    
    // MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self = self, let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.profileImageView.image = image
                self.selectedImage = image
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
            selectedImage = image
        }
    }
}
