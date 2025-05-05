class SellersController < ApplicationController
  def index
    @sellers = Seller.all
  end
  
  def show
    @seller = Seller.find(params[:id])
    @product_sellers = @seller.product_sellers.includes(:product)
  end

  def new
    if Current.user.seller?
      redirect_to seller_path(Current.user.seller), notice: "Zaten bir satıcı hesabınız var."
    else
      @seller = Seller.new
    end
  end
  
  def create
    @seller = Current.user.build_seller(seller_params)
    
    if @seller.save
      redirect_to seller_path(@seller), notice: "Satıcı hesabınız başarıyla oluşturuldu."
    else
      render :new
    end
  end
  
  def edit
    authorize_seller
  end
  
  def update
    authorize_seller
    
    if @seller.update(seller_params)
      redirect_to seller_path(@seller), notice: "Satıcı bilgileriniz güncellendi."
    else
      render :edit
    end
  end
  
  private
  
  def set_seller
    @seller = Seller.find(params[:id])
  end
  
  def authorize_seller
    unless @seller.user == Current.user
      redirect_to root_path, alert: "Bu işlemi yapma yetkiniz yok."
    end
  end
  
  def seller_params
    params.require(:seller).permit(:name, :email_address)
  end
end
