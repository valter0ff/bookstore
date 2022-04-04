class AddressesController < ApplicationController
#     before_action :set_address, only: [:show, :edit, :update, :destroy]
   
   # GET /recipes
   # GET /recipes.json
#    def index
#        @recipes = Recipe.all
#    end
   
   # GET /recipes/1
   # GET /recipes/1.json
#    def show
#    end
   
   # GET /recipes/new
   def new
      @address = Address.new
   end
   
   # GET /recipes/1/edit
#    def edit
#    end
   
   # POST /recipes
   # POST /recipes.json
   def create
    @address = Address.new(address_params)
    if @address.save
      redirect_to new_address_path, notice: 'Address was successfully created.'
    else
      render :new
    end
   end
   
   # PATCH/PUT /recipes/1
   # PATCH/PUT /recipes/1.json
#    def update
#       respond_to do |format|
#          if @address.update(address_params)
#             format.html { redirect_to @address, notice: 'Address was successfully updated.' }
#             format.json { render :show, status: :ok, location: @address }
#          else
#             format.html { render :edit }
#             format.json { render json: @address.errors, status: :unprocessable_entity }
#          end
#       end
#    end
   
   # DELETE /recipes/1
   # DELETE /recipes/1.json
#    def destroy
#       @address.destroy
#          respond_to do |format|
#          format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
#          format.json { head :no_content }
#       end
#    end
   
   private
   
#    # Use callbacks to share common setup or constraints between actions.
#    def set_address
#       @address = Address.find(params[:id])
#    end
   
   # Never trust parameters from the scary internet, only allow the white list through.
   def address_params
      params.require(:address).permit(:first_name, :last_name, :address,
                                      :city, :country_code, :zip, :phone, :type, :user_account_id)
   end
end
