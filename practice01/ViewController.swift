//
//  ViewController.swift
//  practice01
//
//  Created by 张长虹 on 15/6/22.
//  Copyright (c) 2015年 张长虹. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var button:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame=CGRectMake(10,150,100,30)
        button.setTitle("JSON", forState: .Normal)
        button.addTarget(self, action: Selector("tapped"), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        var button2:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button2.frame=CGRectMake(10,250,100,30)
        button2.setTitle("XML", forState: .Normal)
        button2.addTarget(self, action: Selector("tapped2"), forControlEvents: .TouchUpInside)
        self.view.addSubview(button2)
    }
    
    func tapped(){
        let user = ["uname" : "user1",
            "tel":["mobile":"138138000101","home":"010"]]
        var jsonstring=(user as NSDictionary).JSONString()
        println(jsonstring)
        println(jsonstring.objectFromJSONString() as! NSDictionary)
        var jsondata = (user as NSDictionary).JSONData()
        println(jsondata)
        println(jsondata.objectFromJSONData() as! NSDictionary)
        //NSJSONSerialization.isValidJSONObject(obj: AnyObject)  这个函数很有用处
    }
    
    func tapped2(){
        //获取xml文件路径
        var path = NSBundle.mainBundle().pathForResource("users", ofType:"xml")
        //获取xml文件内容
        var xmlData = NSData(contentsOfFile:path!)
        //可以转换为字符串输出查看
        //println(NSString(data:xmlData, encoding:NSUTF8StringEncoding))
        
        //使用NSData对象初始化文档对象
        //这里的语法已经把OC的初始化函数直接转换过来了
        var doc:GDataXMLDocument = GDataXMLDocument(data:xmlData, options : 0, error : nil)
        
        //获取Users节点下的所有User节点，显式转换为element类型编译器就不会警告了
        //var users = doc.rootElement().elementsForName("User") as GDataXMLElement[]
        
        //通过XPath方式获取Users节点下的所有User节点，在路径复杂时特别方便
        var users = doc.nodesForXPath("//User", error:nil) as! [GDataXMLElement]
        
        for user in users {
            //User节点的id属性
            let uid = user.attributeForName("id").stringValue()
            //获取name节点元素
            let nameElement = user.elementsForName("name")[0] as! GDataXMLElement
            //获取元素的值
            let uname =  nameElement.stringValue()
            //获取tel子节点
            let telElement = user.elementsForName("tel")[0] as! GDataXMLElement
            //获取tel节点下mobile和home节点
            let mobile = (telElement.elementsForName("mobile")[0] as! GDataXMLElement).stringValue()
            let home = (telElement.elementsForName("home")[0] as! GDataXMLElement).stringValue()
            //输出调试信息
            println("User: uid:\(uid),uname:\(uname),mobile phone:\(mobile),home:\(home)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

