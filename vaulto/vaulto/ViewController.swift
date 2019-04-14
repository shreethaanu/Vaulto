//
//  ViewController.swift
//  vaulto
//
//  Created by PRoVMac on 19/11/18.
//  Copyright © 2018 strlab. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import ImagePicker


class ViewController: UIViewController, ImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var  imagesArray: [UIImage] = []
    
    var filepath:String = ""
    
    var url:URL!
  
    var fileURLs:[URL] = []
    
    @IBOutlet weak var justImg: UIImageView!
    
    @IBOutlet weak var savedImagesColl: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func pickImg(_ sender: Any) {
       
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = ImagePickerController()
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)

        }
    }
    @IBAction func retriveall(_ sender: Any) {
        
        let fileManager = FileManager.default
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
             fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
          print(fileURLs)
            savedImagesColl.reloadData()
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
      // Get random names
        let calendar = Calendar.current
        let time=calendar.dateComponents([.hour,.minute,.second], from: Date())
        let Fname = ("\(time.hour!):\(time.minute!):\(time.second!)")
        let fileName = Fname + "png" // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
       
        for image in imagesArray {
        let imgName = imagesArray.first
        if let data = imgName?.jpegData(compressionQuality: 1),!FileManager.default.fileExists(atPath: fileURL.path){
        
            do {
                try data.write(to: fileURL)
                print(fileURL)
                print("file saved")
                justImg.image = UIImage(contentsOfFile: fileURL.path)
                imagesArray.remove(at: 0)
            } catch {
                print("error saving file:", error)
            }
        }
        }
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imagesArray = images
        print(images.count)
        }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
         imagePicker.dismiss(animated: true, completion: nil)
            imagesArray = images
            print(images.count)
             print(images.count)
        }
    

    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
       imagePicker.dismiss(animated: true, completion: nil)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgCollectionViewCell", for: indexPath) as! ImgCollectionViewCell
        let currentImgPrev = fileURLs[indexPath.row].path
        cell.savedImg.image = UIImage(contentsOfFile: currentImgPrev)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileURLs.count
    }
}

