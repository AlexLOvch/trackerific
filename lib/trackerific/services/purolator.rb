class Trackerific::Services::Purolator < Trackerific::Services::Base
  register :purolator, as: :SOAP

  configure do |config|
    config.track_operation = :track_packages_by_pin
    config.builder = Trackerific::Builders::Purolator
    config.parser = Trackerific::Parsers::Purolator
    config.wsdl = 'purolator/FreightTrackingService'
    config.package_id_matchers = [ /^\d{12}$/ ]
    config.basic_auth_required = true
    config.client_params = {
      namespace: 'http://purolator.com/pws/datatypes/v1',
      element_form_default: :qualified,
      namespace_identifier: :ns1,
      env_namespace: 'SOAP-ENV',
      pretty_print_xml: true,
      convert_request_keys_to: :none
    }
  end
end

