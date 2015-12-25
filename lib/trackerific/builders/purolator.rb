class Trackerific::Builders::Purolator < Trackerific::Builders::Base::SOAP.new(:package_id)

  def self.soap_header
    {
      'ns1:RequestContext' =>
        {
          'ns1:Version' => '1.0',
          'ns1:Language' => 'en',
          'ns1:GroupID' => 'xxx',
          'ns1:RequestReference' => 'Freight Track'
        }
    }
  end


  protected

  # Builds the FedEx track request XML
  # @api private
  def build
    { PINs: { PIN: { Value: package_id } } }
  end

end
