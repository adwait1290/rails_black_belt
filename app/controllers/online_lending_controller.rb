class OnlineLendingController < ApplicationController
  def register
  	@lender = Lender.new
  	@borrower = Borrower.new
  	@lender_errors = flash[:lender_errors]
  	@borrower_errors = flash[:borrower_errors]
  end

  def create_lender
  	@lender = Lender.create(lender_params)
  	if @lender.save
  		session[:user_id] = @lender.id
  		session[:user_type] = 'lender'
  		redirect_to lender_path @lender
  	else
  		flash[:lender_errors] = @lender.errors.full_messages
  		redirect_to online_lending_register_path
  	end
  end

    def create_borrower
  	@borrower = Borrower.create(borrower_params)
  	if @borrower.save
  		session[:user_id] = @borrower.id
  		session[:user_type] = 'borrower'
  		redirect_to borrower_path @borrower
  	else
  		flash[:borrower_errors] = @borrower.errors.full_messages
  		redirect_to online_lending_register_path
  	end
  end

  def login
  	@message = flash[:message]
  	@error = flash[:login_error]
  end

  def lender
  	if session[:user_type] == 'lender'
	  	@lender = Lender.find(params[:id])
	  	@borrowers = Borrower.all
	  	@history = History.new
	  	@lendees = History.joins(:borrower).select('*').where(lender:Lender.find(params[:id]))
    else 
		  redirect_to online_lending_login_path
    end
  end


  def borrower
  	if session[:user_type] == 'borrower'
  		@borrower = Borrower.find(params[:id])
  		@lenders = History.joins(:lender).select('*').where(borrower:Borrower.find(params[:id]))
  	else 
  		redirect_to online_lending_login_path
  	end
  end

  def lend_money
    if session[:user_type] != 'lender'
    	redirect_to online_lending_login_path
    end

    @lender = Lender.find(session[:user_id])
    @lender.skip_password_validation = true
    puts @lender.first_name
    cash = params[:amount].to_i

    puts cash
    puts @lender.money
    puts @lender.money - cash
    @lender.update(money: @lender.money - cash)

    @borrower = Borrower.find(params[:id])
    @borrower.skip_password_validation = true
    puts @borrower.first_name
    if @borrower.raised.nil?
    	@borrower.update(raised: cash)
    else
      @borrower.update(raised: @borrower.raised + cash)
    end
    begin 
      h = History.find_by(lender: @lender, borrower: @borrower)
      h.update(amount: h.amount + cash)
    rescue
      @history = History.create(amount:cash, lender:@lender, borrower:@borrower)
    end
    redirect_to :back
end

  private
  def lender_params
    params.require(:lender).permit(:first_name, :last_name, :email, :password, :money)
  end

  def borrower_params
    params.require(:borrower).permit(:first_name, :last_name, :email, :password, :money, :purpose, :description, :raised)
  end
end
