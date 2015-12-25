class Trackerific::Parsers::Purolator < Trackerific::Parsers::Base
  protected

  def response_error
    @response_error ||= if response_information.try(:errors).try(:any?)
      Trackerific::Error.new(informational_messages.map{|k,v| "Code: #{k}, Message: #{v}"}.join(';'))
    else
      false
    end
  end

  def summary
    { status: shipment_status, details: shipment_details }
  end

  def events
    return nil unless shipment_pin_history
    shipment_pin_history.map do |event|
      Trackerific::Event.new("#{event[:date]} #{event[:time]}", event[:description] , event[:location])
    end
  end

  private

  def track_reply
    @response.hash[:envelope][:body][:tracking_response]
  end


  def response_information
    track_reply[:response_information]
  end

  def informational_messages
    response_information()[:informational_messages]
  end

  def tracking_information_list
    track_reply[:tracking_information_list]
  end

  def tracking_information
    tracking_information_list[:tracking_information]
  end

  def shipment_details
    tracking_information[:shipment_details]
  end

  def shipment_status
    tracking_information[:shipment_status]
  end

  def shipment_pin_history
    return nil unless tracking_information[:shipment_pin_history]
    @shipment_pin_history ||= begin
      tracking_information[:shipment_pin_history][:scan_details].map do |scan_details|
        {
          date: scan_details[:hist_date], time: scan_details[:hist_date],
          code: scan_details[:hist_code], description: scan_details[:hist_desc],
          location: scan_details[:hist_cocation]
        }
      end

    end
  end

end
