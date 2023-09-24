class ExpensesController < ApplicationController
  before_action :update_totals, only: [:index]

    def index
      @expenses = Expense.all  
      update_totals

      @expenses = Expense.all
      @debit_expense = Expense.where('amount > 0').sum(:amount)
      @credit_expense= Expense.where('amount < 0').sum(:amount)
      @total=@debit_expense+@credit_expense
    end

    def create
        @expense = Expense.create(expense_params)
        if @expense.valid?
          flash[:success] = "Your expense has been posted!"
          update_totals
        else
          flash[:alert] = "Woops! Looks like there has been an error!"
        end
        redirect_to root_path
    end

    def edit
        @expense = Expense.find(params[:id])
        update_totals
    end

    def update
        @expense = Expense.find(params[:id])
        if @expense.update(expense_params)
            flash[:success] = "The expense has been updated!"
            update_totals
          redirect_to root_path
        else
          flash[:alert] = "Woops! Looks like there has been an error!"
          redirect_to edit_expense_path(params[:id])
        end
    end
    

    def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    flash[:success] = "The expense was successfully deleted!"
    update_totals
    redirect_to root_path
    end

    private

    def update_totals
      @debit_total = Expense.sum(:debit)
      @credit_total = Expense.sum(:credit)
      @balance = @credit_total - @debit_total
    end

    def expense_params
        params.require(:expense).permit(:title, :amount, :date, :debit, :credit)
    end
end
