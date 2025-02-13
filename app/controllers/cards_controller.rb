class CardsController < ApplicationController
  before_action :set_card, only: %i[ show edit update destroy ]

  # GET /cards or /cards.json
  def index
    @cards = Card.all
    # @card_types = CardType.all
    # @card_races = Race.all.uniq(:name)
    # @card_editions = Edition.all
    query = clean_query_params.reject { |q_p| q_p.blank? }
    if query.keys.size.positive?
      @cards = @cards.where(race_id: query[:card_race]) unless query[:card_race].blank?
      @cards = @cards.where(card_type_id: query[:card_type]) unless query[:card_type].blank?
      @cards = @cards.where(edition_id: query[:card_edition]) unless query[:card_edition].blank?
      @cards = @cards.where("lower(name) like ?", "%#{query[:card_name]}%") unless query[:card_name].blank?
    end
  end

  # GET /cards/1 or /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards or /cards.json
  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: "Card was successfully created." }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1 or /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: "Card was successfully updated." }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1 or /cards/1.json
  def destroy
    @card.destroy!

    respond_to do |format|
      format.html { redirect_to cards_path, status: :see_other, notice: "Card was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def card_params
      params.expect(card: [ :name, :legend, :artist_id, :card_type_id, :edition_id, :cost, :force, :ability, :rarity_id, :race_id ])
    end

    def clean_query_params
      params.permit(:card_type, :card_race, :card_edition, :card_name)
    end
end
