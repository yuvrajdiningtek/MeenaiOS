

import Foundation

struct IntialSetUp {
    
    func do_intial_api_call(completion : @escaping (Bool)->()){
        get_merchant_token { (succtoken) in
            if succtoken{
                self.get_merchant_id { (succ) in
                    if succ{
                        self.get_merchant_detail(completion: { (succ) in
                            if succ{
                                self.get_currncy(completion: { (succ) in
                                    
                                    self.getGalleryImg(completion: { (_) in
                                        self.getNumberOfItemsInCurrentCart(completion: { (_) in
                                            SomeInformationApi.restraunt_timing(secVersion: false, callback: { (_, _) in
                                                completion(true)
                                            })
                                        })
                                        
                                    })
                                    
                                })
                                
                            }
                            else{
                                completion(false)
                            }
                        })
                    }else{
                        completion(false)
                    }
                }
            }else{
                completion(false)
            }
        }
        
    }
    
    func getNumberOfItemsInCurrentCart(completion : @escaping (Bool)->()){
        self.get_numberofItems_in_cart(callback: { (succ) in
            if succ{
                completion(true)
            }else{
                completion(false)
            }
        })
    }
    
   
    
    // intial parametrs
    
    fileprivate func get_merchant_id(completion : @escaping (Bool)->()){

        RegisterApi.merchant_id { (succ, rst, err) in
            completion(succ)
        }
    }
    
    fileprivate func get_merchant_detail(completion : @escaping (Bool)->()){
        RegisterApi.merchant_detail { (succ, rst) in
            if succ{

                completion(true)
            }else{
                completion(false)
            }
        }
    }
    fileprivate func get_currncy(completion : @escaping (Bool)->()){

        SomeInformationApi.getcurrency { (succ, rst) in
            if succ{

                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    fileprivate func get_merchant_token(completion : @escaping (Bool)->()){

        RegisterApi.merchant_token { (succ, _) in
            if succ{
                
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    
    
    
    fileprivate func get_numberofItems_in_cart(callback:@escaping ((Bool )->())){
        
        if isUserLoggedIn{
            SomeInformationApi.get_bucketid(callback: { (succ, err) in
                if succ{
                    ProductsApi.detail_Cart_Info(callback: { (ss, _, _) in
                        callback(ss)
                    })
                }else{
                    callback(false)
                }
            })
        }else{
            ProductsApi.detail_Cart_Info { (succ, rst,_) in
                if succ{
                    
                    callback(true)
                }
                else{
                    callback(false)
                }
            }
        }
        
    }

    // gallery images
    
    fileprivate func getGalleryImg(completion : @escaping (Bool)->()){
        SomeInformationApi.get_galleryImages { (succ, _, _) in
            completion(succ)
        }
    }
}
