//
//  ViewController.swift
//  listadecompras
//
//  Created by Paola Pagotto on 16/09/2020.
//  Copyright © 2020 Paola Pagotto. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var labelAppTitle: UILabel!
    
    @IBOutlet weak var textFieldPrdtName: UITextField!
    
    
    @IBOutlet weak var textFieldPrdtQnt: UITextField!
    
    
    @IBOutlet weak var labelTextProductInformation: UILabel!
    
    @IBOutlet weak var labelProductsList: UILabel!
    
    
    var arrayProducts = [Product]()
    
    var deleteProduct: Bool?
    var editProduct: Bool?
    var saveProduct: Bool?
    var listPrinted = ""
    
    
    //  MARK: Actions
    
    @IBAction func buttonSaveProduct(_ sender: UIButton) {
        if verifyProduct() {
            addNewProduct(name: textFieldPrdtName.text!, quantity: textFieldPrdtQnt.text!)
        }
        labelProductsList.text = listPrinted
    }
    
    @IBAction func buttonEditProduct(_ sender: UIButton) {
        if verifyProduct() {
            editProduct(name: textFieldPrdtName.text!, quantity: textFieldPrdtQnt.text!)
        } else {
            print("Produto não existe")
        }
        labelProductsList.text = listPrinted
    }
    
    @IBAction func buttonDeleteProduct(_ sender: UIButton) {
        if verifyProduct() {
            deleteProduct(name: textFieldPrdtName.text!)
        }
        labelProductsList.text = listPrinted
    }
    
    @IBAction func stepperQuantity(_ sender: UIStepper) {
        
    }
    
    private func isProductAvailable(name:String, quantity:String) -> Product? {
        for product in arrayProducts {
            if product.name == name && !product.quantity.isEmpty {
                labelProductsList.text = ("\n \(product.name), \(product.quantity)")
                return product
            }
        }
        labelProductsList.text = ""
        return nil
    }
    
    private func verifyProduct() -> Bool {
        if textFieldPrdtName.text == nil || textFieldPrdtName.text!.isEmpty {
            return false
        }
        if textFieldPrdtQnt.text == nil || textFieldPrdtQnt.text!.isEmpty {
            return false
        }
        return true
    }
    
    private func getProductByName(name: String) -> Product? {
        for product in arrayProducts {
            return product
        }
        return nil
    }
    
    func addNewProduct(name: String, quantity: String) {
        
        let product = Product(name: name, quantity: quantity)
        
        if ((isProductAvailable(name: name, quantity: quantity)) != nil){
            //não pode adicionar produto já cadastrado
            labelTextProductInformation.text = "Produto já existente"
            listPrinted += ("\n \(name), \(quantity)")
        } else {
            //pode cadastrar novo produto ainda não cadastrado
            arrayProducts.append(product)
            
            labelTextProductInformation.text = "Produto novo"
            listPrinted += ("\n \(product.name), \(product.quantity)")
        }
        cleanFields()
    }
    
    func editProduct(name: String, quantity: String) -> Product? {
        if (isProductAvailable(name: name, quantity: quantity) != nil){
            for product in arrayProducts where product.name == name {
                product.name = name
                product.quantity += quantity
                return product
            }
        } else {
            labelTextProductInformation.text = "Este produto não existe na lista"
        }
        cleanFields()
        return nil
    }
    
    func deleteProduct(name: String) {
        var index = 0;
        for product in arrayProducts{
            if product.name == name {
                arrayProducts.remove(at: index)
            } else {
                index += 1
            }
        }
         cleanFields()
    }
    
    private func cleanFields() {
        textFieldPrdtName.text = ""
        textFieldPrdtQnt.text = ""
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldPrdtName.delegate = self
        textFieldPrdtQnt.delegate = self
        labelAppTitle.text = "📝 Lista de Compras 🛒"
        labelTextProductInformation.text = ""
        labelProductsList.text = "LISTA... \n "
        
    }


}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldPrdtName {
            textFieldPrdtQnt.becomeFirstResponder()
            textFieldPrdtQnt.text = ""
        } else {
            if verifyProduct() {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldPrdtName {
            if let productName = textFieldPrdtName.text, !productName.isEmpty {
                if let product = getProductByName(name: productName) {
                    textFieldPrdtQnt.text = product.quantity
                }
            }
        }
    }
    
    
    
    
}
