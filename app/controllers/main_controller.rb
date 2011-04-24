class MainController < ApplicationController
  layout false
  def classifier
    @groups = Gpc.all :select => "DISTINCT(gpcs.segment_description)", :order => 'segment_description'
    respond_to do |format| 
      format.js
    end
  end
  
  def subgroups
    @subgroups = Gpc.all :select => "DISTINCT(gpcs.description)", :order => 'description', :conditions => ['segment_description = ?', CGI::unescape(params[:id])]
  end
  
  def categories
    @categories = Gpc.all :select => "code, name", :order => 'code,name', :conditions => ['description = ?', CGI::unescape(params[:id])]
  end
  
  def countries
    @countries = Country.all :order => 'description'
    respond_to do |format| 
      format.js
    end
  end
  
  def cases
    @id = if PackagingItem.find_by_id(params[:packagin_item_id])
      PackagingItem.find(params[:packagin_item_id]).id
    else
      0
    end
    @results = BaseItem.packaging_types 
    respond_to do |format| 
      format.js
    end
  end
  
  def show_man
    hash = {}
    hash[1] = "A gas-tight, pressure-resistant container with a valve and propellant.  When the valve is opened, propellant forces the product from the container in a fine or coarse spray pattern or stream.  (e.g., a spray can dispensing paint, furniture polish, etc, under pressure).  It does not include atomizers, because atomizers do not rely on a pressurised container to propel product from the container. "
    hash[2] = "A relatively small container made from glass or plastic tubing, the end of which is drawn into a stem and closed by fusion after filling.  The bottom may be flat, convex, or drawn out.  An ampoule is opened by breaking the stem. "
    hash[3] = "A device for reducing a liquid to a fine spray. (i.e. medicine, perfume, etc).  An atomizer does not rely on a pressurised container for the propellant.  Usually air is provided by squeezing a rubber bulb attached to the atomizer. "
    hash[4] = "A preformed, flexible container, generally enclosed on all but one side, which forms an opening that may or may not be sealed after filling. "
    hash[5] = "Bag-In-Box or BIB is a type of container for the storage and transportation of liquids. It consists of a strong bladder, usually made of aluminium PET film or other plastics seated inside a corrugated fibreboard box. The box and internal bag can be fused together. In most cases there is nozzle or valve fixed to the bag. The nozzle can be connected easily to a dispensing installation or the valve allows for convenient dispensing. "
    hash[6] = "Something used to bind, tie, or encircle the item or its packaging to secure and maintain unit integrity. "
    hash[7] = "A cylindrical packaging whose bottom end is permanently fixed to the body and top end (head) is either removable or non-removable. "
    hash[8] = "A semi rigid container usually open at the top traditionally used for gathering, shipping and marketing agricultural products. "
    hash[9] = "A type of packaging in which the item is secured between a preformed (usually transparent plastic) dome or “bubble” and a paperboard surface or “carrier.” Attachment may be by stapling, heat-sealing, gluing, or other means.  In other instances, the blister folds over the product in clam-shell fashion to form an enclosing container.  Blisters are most usually thermoformed from polyvinyl chloride; however, almost any thermoplastic can be thermoformed into a blister."
    hash[10] = "A container having a round neck of relatively smaller diameter than the body and an opening capable of holding a closure for retention of the contents. Specifically, a narrow-necked container as compared with a jar or wide-mouth container.  The cross section of the bottle may be round, oval, square, oblong, or a combination of these.  Bottles generally are made of glass or plastics, but can also be earthenware or metal. Bottle may be disposable, recyclable, returnable, or reusable. "
    hash[11] = "A non-specific term used to refer to a rigid, three-dimensional container with closed faces that completely enclose its contents and may be made out of any material. Even though some boxes might be reused or become resealed they could also be disposable depending on the product hierarchy. "
    hash[12] = "A rectangular-shaped, stackable package designed primarily for liquids such as juice or milk "
    hash[13] = "A container, usually cylindrical, can be equipped with a lid and a handle. (e.g., a pail made of metal, plastic, or other appropriate material). "
    hash[14] = "A container enclosed on at least one side by a grating of wires or bars that lets in air and light. "
    hash[15] = "A metallic and generally cylindrical container of unspecified size which can be used for items of consumer and institutional sizes. "
    hash[16] = "A flat package to which the product is hung or attached for display. "
    hash[17] = "A non-specific term for a re-closable container used mostly for perishable foods (e.g. eggs, fruit).  "
    hash[18] = "A non-specific term for a container designed to hold, house, and sheath or encase its content while protecting it during distribution, storage and/or exhibition. Cases are mostly intended to store and preserve its contents during the product's entire lifetime. "
    hash[19] = "A non-specific term usually referring to a rigid three-dimensional container with semi-closed faces that enclose its contents for shipment or storage. Crates could have an open or closed top and may have internal divers. Even though some crates might be reused or become resealed they could also be disposable depending on the product hierarchy. "
    hash[20] = "A small bowl shaped container for beverages, often with a handle.  "
    hash[21] = "A rigid cylindrical container with straight sides and circular ends of equal size.  "
    hash[22] = "A non-specific container with some device or mechanism to supply or extract its contents. "
    hash[23] = "A predominantly flat container of flexible material having only two faces, and joined at three edges to form an enclosure.  The non-joined edge provides a filling opening, which may later be closed by a gummed or adhesive flap, heat seal, tie string, metal clasp, or other methods.  "
    hash[24] = "A non-rigid container used for transport and storage of fluids and other bulk materials. The construction of the IBC container and the materials used are chosen depending on the application.   "
    hash[25] = "A rectangular-shaped, non-stackable package designed primarily for liquids such as juice or milk "
    hash[26] = "A rigid container made of glass, stone, earthenware, plastic or other appropriate material with a large opening, which is used to store products, (e.g., jams, cosmetics). "
    hash[27] = "A container, normally cylindrical, with a handle and/or a lid or spout for holding and pouring liquids"
    hash[28] = "A bundle of products held together for ease of carriage by the consumer. A multipack is always a consumer unit. "
    hash[29] = "A container of meshwork material made from threads or strips twisted or woven to form a regular pattern with spaces between the threads that is used for holding, carrying, trapping, or confining something. "
    hash[30] = "The item is provided without packaging. "
    hash[31] = "Packaging of the product (or products) is currently not on the list. Use this code when no suitable options are available and only while a Change Request is approved for the proper packaging type.  "
    hash[32] = "A platform used to hold or transport unit loads. "
    hash[33] = "A three-dimensional container which either has a pallet platform permanently attached at its base or alternatively requires a platform for its handling and storage as due to its constitution it cannot be handled without it. The characteristics of the platform should be specified using the pallet type code list "
    hash[34] = "A package used for sterile products which may be torn open without touching the product inside. "
    hash[35] = "A preformed, flexible container, generally enclosed with a gusset seal at the bottom of the pack can be shaped/arranged to allow the pack to stand on shelf. "
    hash[36] = "A non specific term identifying a framework or stand for carrying, holding, or storing items.  Commonly on wheels and primarily used in the logistical functions to deliver items such as hanging garments, or items on shelves such as dairy products and bakery items and flowers. "
    hash[37] = "A spool on which thread, wire, film, etc, is wound. Any device on which a material may be wound.  Usually has flanged ends and is used for shipping or processing purposes. "
    hash[38] = "In packaging, a plastic film around an item or group of items which is heated causing the film to shrink, securing the unit integrity. The use of shrunken film to tightly wrap a package or a unit load in order to bind, protect and immobilize it for further handling or shipping. "
    hash[39] = "A non-rigid container usually made of paper, cardboard or plastic, that is open- ended and is slid over the contents for protection or presentation. "
    hash[40] = "In packaging, a high-tensile plastic film, stretched and wrapped repeatedly around an item or group of items to secure and maintain unit integrity.  The use of stretch film to tightly wrap a package or a unit load in order to bind, protect and immobilize it for further handling or shipping. "
    hash[41] = "A shallow container, which may or may not have a cover, used for displaying or carrying items. "
    hash[42] = "Generally, a round flat-bottomed container closed with a large lid, typically used to contain ice cream, margarine, sour cream, confections, and other products. "
    hash[43] = "A cylindrical container sealed on one end that could be closed with a cap or dispenser on the other end. "
    hash[44] = "Packaging in containers, either rigid or flexible, from which substantially all gases have been removed prior to final sealing of the container. "
    hash[45] = "The process of enclosing all or part of an item with layers of flexible wrapping material (e.g., for an individually packed ice cream). Does not include items which are shrink-wrapped or vacuum-packed "
    id = BaseItem.packaging_types.find{|i|i[:code]==params[:id]}[:id]
    @case = {:id => id, :description => hash[id]}
    if [5, 12, 17, 18, 25, 28, 33, 35, 38, 45].include?(id)
      @case[:img] = "pi/#{id}.png"
    end
  end
  
end
