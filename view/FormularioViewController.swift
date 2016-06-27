//
//  FormularioViewController.swift
//  ContatosApp
//
//  Created by Fernando on 06/06/16.
//  Copyright © 2016 Fernando. All rights reserved.
//

import UIKit

class FormularioViewController: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UIActionSheetDelegate {

    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var enderecoTextiField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var fotoButton: UIButton!
    
    var contato:Contato?
    let dao = ContatoDAO.sharedInstance()
    var delegate:FormularioContatoViewControllerDelegation?
    
    override func viewDidLoad() {
        colocaContatoNoFormulario()
        
        if contato != nil {
            addButton.enabled = false
            
            let alterarButton = UIBarButtonItem(title: "Alterar", style: .Plain, target: self, action:#selector(FormularioViewController.atualizaContato))
            
            self.navigationItem.rightBarButtonItem = alterarButton
            
        }
        
    }

    @IBAction func gravar(sender: AnyObject) {
        adicionaContato()
    }
    
    @IBAction func selecionarFoto(sender: UIButton) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let sheet = UIActionSheet(title: "Escolha a foto do contato", delegate: self, cancelButtonTitle: "Cancelar", destructiveButtonTitle: nil, otherButtonTitles: "Tirar Foto", "Escolher da biblioteca")
            
            sheet.showInView(self.view)
            
        }else{
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
        
        
    }
    
    private func pegaContatoDoFormulario()  {
        
        if contato == nil {
            contato = Contato()
        }
        
        self.contato?.nome = nomeTextField.text
        self.contato?.telefone = telefoneTextField.text
        self.contato?.endereco = enderecoTextiField.text
        self.contato?.site = siteTextField.text
        
        self.contato?.foto = self.fotoButton.backgroundImageForState(.Normal)
        
    }
    
    private func colocaContatoNoFormulario(){
        nomeTextField.text = contato?.nome
        telefoneTextField.text = contato?.telefone
        enderecoTextiField.text = contato?.endereco
        siteTextField.text = contato?.site
        
        fotoButton.setBackgroundImage(contato?.foto, forState: .Normal)
        
        
        if fotoButton.backgroundImageForState(.Normal) != nil {
            fotoButton.setTitle(nil, forState: .Normal)
        }
        
        
    }
    
    func atualizaContato(){
        pegaContatoDoFormulario()
        
        if delegate != nil {
            delegate?.contatoAtualizado(contato!)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func adicionaContato(){
        pegaContatoDoFormulario()
        dao.add(self.contato!)
        
        if delegate != nil {
            delegate?.contatoAdicionado(contato!)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK: delegate -  UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imagemSelecionada: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.fotoButton.setBackgroundImage(imagemSelecionada, forState: UIControlState.Normal)
        self.fotoButton.setTitle(nil, forState: UIControlState.Normal)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    //MARK: delegate  - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        switch buttonIndex {
        case 1:
            picker.sourceType = .Camera
            break
        case 2:
            picker.sourceType = .PhotoLibrary
            break
        default:
            break
        }
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
}
