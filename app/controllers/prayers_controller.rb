class PrayersController < ApplicationController
  before_action :set_prayer, only: %i[ show edit update destroy ]

  def index
    @prayers = Prayer.all
  end

  def new
    @prayer = Prayer.new
  end

  def edit
    render inertia: 'prayers/edit', props: { prayer_id: @prayer.id, prayer: @prayer.data }
  end

  def create
    @prayer = Prayer.new(prayer_params)

    respond_to do |format|
      if @prayer.save
        format.html { redirect_to prayer_url(@prayer), notice: "Prayer was successfully created." }
        format.json { render :show, status: :created, location: @prayer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prayer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @prayer.update(prayer_params)
        format.html { redirect_to prayer_url(@prayer), notice: "Prayer was successfully updated." }
        format.json { render :show, status: :ok, location: @prayer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prayer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_group
    prayer = Prayer.find(params[:prayer_id])
    index = prayer.data['groups'].find_index { |group| group['id'] == params[:group][:id] }
    prayer.data['groups'][index] = params[:group]
    prayer.save!
    render json: nil, status: :ok
  end

  def insert_group
    prayer = Prayer.find(params[:prayer_id])
    index = if params[:group_id]
      prayer.data['groups'].find_index { |group| group['id'] == params[:group_id] }
    else
      prayer.data['groups'].length
    end
    prayer.data['groups'].insert(index, params[:new_group])
    prayer.save!
    render json: nil, status: :ok
  end

  def destroy
    @prayer.destroy

    respond_to do |format|
      format.html { redirect_to prayers_url, notice: "Prayer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_prayer
      @prayer = Prayer.find(params[:id])
    end

    def prayer_params
      params.require(:prayer).permit(:title, :data)
    end
end