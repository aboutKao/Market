//
//  AddItemViewController.swift
//  Market
//
//  Created by Kao on 2020/8/30.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    

    var category: Category!
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    
    var activityIndicator: NVActivityIndicatorView?

    var itemImages: [UIImage?] = []
    
    
    //view 生命週期
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), padding: nil)
    }
    
    
    @IBAction func btDoneAction(_ sender: Any) {
        if fieldsAreCompleted() {
            saveToFirebase()
        } else {
            print("請輸入文字匡")
            self.hud.textLabel.text = "文字輸入匡不能為空"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }

    @IBAction func btImageAction(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    @IBAction func tapBackground(_ sender: Any) {
        dismissKeyboard()
    }
    
    //Helper func
    //鍵盤收起
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    private func fieldsAreCompleted() -> Bool {
        return (tfTitle.text != "" && tfPrice.text != "" && tvDescription.text != "")
    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //儲存Item
    private func saveToFirebase() {
        showLoadingIndicator()
        
        let item = Item()
        item.id = UUID().uuidString
        item.name = tfTitle.text!
        item.categoryId = category.id
        item.description = tvDescription.text
        item.price = Double(tfPrice.text!)
        
        if itemImages.count > 0 {
            uploadImage(images: itemImages, itemId: item.id) { (imageLinkArray) in
                item.imageLinks = imageLinkArray
                saveItemToFirestore(item)
                
                self.hideLoadingIndicator()
                self.popTheView()
            }
        } else {
            saveItemToFirestore(item)
            popTheView()
        }
    }
    
    //載入中動畫
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    //載入中動畫結束
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    
    //show gallery
    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
}

extension AddItemViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
         controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
         controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
