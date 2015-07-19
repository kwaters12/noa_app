class NoaApplicationPDFForm < FillablePdfForm
  def initialize(noa_application)
    @noa_application = noa_application
    super()
  end

  protected

  def fill_out
    fill :date, Date.today.to_s
    [:sin, :first_name, :last_name, :dob].each do |field|
      fill field, @noa_application.send(field)
    end
  end
end