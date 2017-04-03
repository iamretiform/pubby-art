class CreatesLocation
  attr_reader :location_attrs
  attr_reader :errors, :location

  def initialize(location_attrs)
    @location_attrs = location_attrs
    @errors = []
  end

  def call
    @location = Location.new(location_attrs)

    if @location.invalid?
      @errors = @location.errors.full_messages
      return
    end

    @location.save
    send_text_message
  end

  def success?
    errors.none?
  end

  private

  def send_text_message
    TextAdminJob.perform_later(@location)
  end
end
