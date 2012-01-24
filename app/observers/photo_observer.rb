class PhotoObserver < Mongoid::Observer
  def after_create(photo)
    photo.product.log_event("create", photo)
  end
  
  def after_destroy(photo)
    photo.product.log_event("destroy", photo)
  end
end