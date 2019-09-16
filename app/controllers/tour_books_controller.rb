class TourBooksController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tour_book, except: [:index, :new, :create, :add_item]
  before_action :set_user

  def index
    @tour_books = @user.tour_books
    @tour_books = @tour_books.page(params[:page])
  end

  def show

  end

  def new
    @tour_book = TourBook.new
  end

  def create
    @tour_book = @user.tour_books.build(tour_book_params)

    authorize @tour_book
    if @tour_book.save
      flash[:success] = 'You TourBook was created!'
      redirect_to user_tour_books_path
    else
      flash[:error] = @tour_book.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    authorize @tour_book
  end

  def update
    authorize @tour_book

    if @tour_book.update(tour_book_params)
      flash[:success] = 'You TourBook was updated!'
      redirect_to user_tour_book_path(@tour_book.user, @tour_book)
    else
      flash[:error] = @tour_book.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    authorize @tour_book
  end

  def add_item
    @tour_book = TourBook.friendly.find(params[:tour_book_id])
    authorize @tour_book

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])

      begin
        @tour_book.tours << @tour
        flash.now[:notice] = "Tour was added to your TourBook #{@tour_book.name}"
      rescue ActiveRecord::RecordInvalid => e
        flash.now[:error] = e.message
      end
    end
  end

  private

    def set_tour_book
      @tour_book = TourBook.friendly.find(params[:id])
    end

    def tour_book_params
      params.require(:tour_book).permit(*permitted_params)
    end

    def permitted_params
      [
          :name,
          :description
      ]
    end

end
