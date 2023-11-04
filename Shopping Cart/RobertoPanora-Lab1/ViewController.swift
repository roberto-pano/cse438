//
//  ViewController.swift
//  RobertoPanora-Lab1
//
//  Created by Roberto Panora on 9/6/23.
//
import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var shoppingCart: UITableView!;
    var cart = [String: String]();
    var cartKeys = [String]();
        
    @IBAction func addToCart(_ sender: Any) {
        if(!item.text!.isEmpty) {
            cartKeys.append(item.text!);
            cart[item.text!] = finalPriceOutlet.text!;
            shoppingCart.reloadData();
        }
    }
    
    
    
    @IBOutlet weak var discountSlider: UISlider!;
    
    @IBOutlet weak var warning: UILabel!;
    
    @IBOutlet weak var item: UITextField! = {
        let item = UITextField();
        item.placeholder = "Enter Item";
        return item;
    }()
    
    @IBOutlet weak var originalPrice: UITextField! = {
        let originalPrice = UITextField();
        originalPrice.placeholder = "0";
        originalPrice.isUserInteractionEnabled = false;
        return originalPrice;
    }()
    
    @IBOutlet weak var salesTax: UITextField! = {
        let salesTax = UITextField();
        salesTax.placeholder = "0";
        salesTax.isUserInteractionEnabled = false;
        return salesTax;
    }()
    
    @IBOutlet weak var finalPriceOutlet: UITextField! = {
        let finalPriceOutlet = UITextField();
        finalPriceOutlet.placeholder = "$0.00";
        return finalPriceOutlet;
    }()
    
    @IBAction func finalPriceUpdate(_ sender: UITextField) {
        let ogPrice = Double(originalPrice.text!) ?? 0;
        let dis = (Double(discount.text!) ?? 0)/100;
        let sT = ((Double(salesTax.text!) ?? 0))/100;
        let finalPrice: Double = (ogPrice - ogPrice * dis) * (sT + 1.0);
        print(finalPrice);
        let displayText = "$\(String(format: "%.2f", finalPrice))";
        sender.text = displayText;
    }
    
    @IBAction func discountSlider(_ sender: UISlider) {
        discount.text = "\(String(format: "%.2f", sender.value * 100))";
        finalPriceUpdate(finalPriceOutlet);
    }
    
    
    @IBAction func change(_ sender: UITextField) {
//        sender.isUserInteractionEnabled = false
//        sender.becomeFirstResponder();
        sender.keyboardType = UIKeyboardType.decimalPad;
        if(Array(originalPrice.text!).filter({$0 == "."}).count <= 1 && Array(salesTax.text!).filter({$0 == "."}).count <= 1){
            warning.text = "";
            finalPriceUpdate(finalPriceOutlet);
        }
        else{
            finalPriceOutlet.text = "$0.00";
            warning.text = "TOO MANY DECIMALS!"
        }
    }
    
    @IBOutlet weak var discount: UILabel!
    
    @IBAction func clickOn(_ sender: UITextField) {
        print("here")
//        sender.isUserInteractionEnabled = false
        sender.becomeFirstResponder();
        sender.keyboardType = UIKeyboardType.decimalPad;
    }
    @IBAction func clickOut(_ sender: UITextField) {
        sender.resignFirstResponder();
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
            view.endEditing(true)
    }
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        warning.text = "";
        discountSlider.value = 0;
        let didTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
                view.addGestureRecognizer(didTap)
        shoppingCart.dataSource = self;
        shoppingCart.delegate = self;
        
    }
    
   
    
    @IBAction func clear(_ sender: UIButton) {
        originalPrice.text = "0";
        discount.text = "0";
        discountSlider.value = 0;
        salesTax.text = "0";
        finalPriceOutlet.text = "$0.00";
        item.text = "Enter Item...";
        cartKeys.removeAll();
        cart.removeAll();
        shoppingCart.reloadData();
    }
    

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cart);
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = "\(cartKeys[indexPath.row]): \( cart[cartKeys[indexPath.row]] ?? "$0.00")";
        return cell;
    }
    
    
}
