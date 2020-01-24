

import Foundation
import RealmSwift

struct Parse_Produvt_CategoryData{
    // map prodCat
    func map_prodCat( data: NSDictionary)-> ProductCatData{
        let prod_cat = ProductCatData()
        guard let allCat = data.value(forKey: "data") as? [NSDictionary] else {return prod_cat}
        let allcat = map_data(data: allCat)
        guard let request_status = data.value(forKey: "request_status") as?  Int else {return prod_cat}
        prod_cat.data = allcat
        prod_cat.request_status = request_status
        return prod_cat
    }
    
    // map variationAttribute
    private func map_VariationAttribute(data : NSDictionary)-> VarianceAttribute {
        let varianceAttribute = VarianceAttribute()
        guard let group = data.value(forKey: "Group") as? NSDictionary  else { return varianceAttribute}
        let grp = map_GroupVarianceAttribute(data: group)
        varianceAttribute.Group = grp
        return varianceAttribute
        
    }
    private func map_GroupVarianceAttribute(data : NSDictionary)->GroupVarianceAttribute{
        guard let cat = data.value(forKey: "Category") as? [String:[String]] else {return GroupVarianceAttribute()}
        
        let catAtt_Arr = List<CategoryVarianceAttribute>()
        for (key,value) in cat{
            let catAtt = CategoryVarianceAttribute()
            catAtt.category_key = key
            for i in value{
                catAtt.value.append(i)
            }
            catAtt_Arr.append(catAtt)
        }
        
        let groupAtt_Arr = GroupVarianceAttribute()
        groupAtt_Arr.Category = catAtt_Arr
        return groupAtt_Arr
        
    }
    
    // map variations
    
    
    private func map_variations(variations : [NSDictionary])-> List<Variations>{
        let varAtt_Arr = List<Variations>()
        
        for value in variations{
            let Att = Variations()
            
            Att.productVariationId = value.value(forKey: "productVariationId") as? String ?? ""
            Att.name = value.value(forKey: "name") as? String ?? ""
            Att.slug = value.value(forKey: "slug") as? String ?? ""
            Att.shortDescription = value.value(forKey: "shortDescription") as? String ?? ""
            Att.descriptions = value.value(forKey: "descriptions") as? String ?? ""
            
            let images = value.value(forKey: "image") as? [String] ?? [String]()
            for i in images{
                Att.image.append(i)
            }
            Att.price = value.value(forKey: "price") as? Double ?? 0.0
            
            if let att = value.value(forKey: "varianceAttribute") as? NSDictionary{
                let varatt = map_VariationAttribute(data: att)
                Att.varianceAttribute = varatt
            }
            varAtt_Arr.append(Att)
        }
        return varAtt_Arr
        
    }
    
    
    
    // map products
    private func map_Products(_ products: [NSDictionary])-> List<Products>{
        let proAtt_Arr = List<Products>()
        for value in products{
            let Att = Products()
            Att.productId = value.value(forKey: "productId") as? String ?? ""
            Att.name = value.value(forKey: "name") as? String ?? ""
            Att.slug = value.value(forKey: "slug") as? String ?? ""
            Att.shortDescription = value.value(forKey: "shortDescription") as? String ?? ""
            Att.descriptions = value.value(forKey: "descriptions") as? String ?? ""
            
            let images = value.value(forKey: "image") as? [String] ?? [String]()
            for i in images{
                Att.image.append(i)
            }
            
            //            Att.attributes : Attributes?
            
            Att.price = value.value(forKey: "price") as? Double ?? 0.0
            if let att = value.value(forKey: "varianceAttribute") as? NSDictionary{
                let varatt = map_VariationAttribute(data: att)
                Att.varianceAttribute = varatt
            }
            
            if let att = value.value(forKey: "variations") as? [NSDictionary]{
                let varatt = map_variations(variations: att)
                Att.variations = varatt
            }
            proAtt_Arr.append(Att)
            
            //ADDONS
            if let AddObData = value.value(forKey: "addonsGroups") as? [NSDictionary]{
                
                for i in AddObData{
                    let addons = AddOnsGroup(value: i)
                    Att.addonsGroups.append(addons)
                    
                }
            }
            
        }
        return proAtt_Arr
    }
    
    // map Categories
    private func map_Category(category : NSDictionary)->ProdCategory{
        let Att = ProdCategory()
        Att.categoryId = category.value(forKey: "categoryId") as? String ?? ""
        Att.categoryName = category.value(forKey: "categoryName") as? String ?? ""
        Att.bundleId = category.value(forKey: "bundleId") as? String ?? ""
        Att.slug = category.value(forKey: "slug") as? String ?? ""
        Att.longDescription = category.value(forKey: "longDescription") as? String ?? ""
        return Att
    }
    // map data
    private func map_data(data : [NSDictionary])-> List<AllCategory>{
        
        let AllCategoryArr = List<AllCategory>()
        for i in data{
            let allcat = AllCategory()
            guard let cat = i.value(forKey: "category") as? NSDictionary else{return AllCategoryArr}
            let category = map_Category(category: cat)
            
            guard let products = i.value(forKey: "products") as? [NSDictionary] else{return AllCategoryArr}
            let prods = map_Products(products)
            allcat.category = category
            allcat.products = prods
            AllCategoryArr.append(allcat)
        }
        return AllCategoryArr
    }
    
}
