module Trackerific::Services::Concerns::SOAP
  extend ActiveSupport::Concern

  protected

  def request(id)
    client.call(config.track_operation, message: builder(id).hash)
  end

  def client
    @client ||= Savon.client({convert_request_keys_to: :camelcase, wsdl: Trackerific::SOAP::WSDL.path(config.wsdl)}
      .merge(config.client_params)
      .merge(config.builder.respond_to?(:soap_header) ? { soap_header: config.builder.soap_header} : {})
      .merge(config.basic_auth_required ? { basic_auth: [self.class.credentials[:login], self.class.credentials[:password]]} : {})
    )
  end
end
