class DecksController < BehindSessionController
  before_action :set_deck, only: %i[ show edit update destroy ]

  # GET /decks or /decks.json
  def index
    @decks = current_user ? current_user.decks : Deck.all
  end

  # GET /decks/1 or /decks/1.json
  def show
    @search_cards = []
    query = clean_query_params.reject { |q_p| q_p.blank? }
    if query.keys.size >= 2 || !query[:card_name].blank?
      @search_cards = Card.all
      @search_cards = @search_cards.where(race_id: query[:card_race]) unless query[:card_race].blank?
      @search_cards = @search_cards.where(card_type_id: query[:card_type]) unless query[:card_type].blank?
      @search_cards = @search_cards.where(edition_id: query[:card_edition]) unless query[:card_edition].blank?
      @search_cards = @search_cards.where("lower(name) like ?", "%#{query[:card_name]}%") unless query[:card_name].blank?
    end
  end

  # GET /decks/new
  def new
    @deck = current_user ? current_user.decks.new : Deck.new
  end

  # GET /decks/1/edit
  def edit
  end

  # POST /decks or /decks.json
  def create
    @deck = current_user.decks.new(deck_params)

    respond_to do |format|
      if @deck.save
        format.html { redirect_to @deck, notice: "Deck was successfully created." }
        format.json { render :show, status: :created, location: @deck }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /decks/1 or /decks/1.json
  def update
    respond_to do |format|
      if @deck.update(deck_params)
        format.html { redirect_to @deck, notice: "Deck was successfully updated." }
        format.json { render :show, status: :ok, location: @deck }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /decks/1 or /decks/1.json
  def destroy
    @deck.destroy!

    respond_to do |format|
      format.html { redirect_to decks_path, status: :see_other, notice: "Deck was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deck
    @deck = Deck.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def deck_params
    params.expect(deck: [ :name, :description, :user_id ])
  end

  def clean_query_params
    params.permit(:card_type, :card_race, :card_edition, :card_name)
  end
end
