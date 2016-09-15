require_relative '../db/database_connection.rb'
require_relative './spec.rb'

# Factory for spec objects
class SpecFactory
  def parse_string(parsed_json, key)
    parsed_json[key] ||= '' unless parsed_json.nil?
  end

  def valid_entry?(v)
    if v.respond_to? :empty?
      !v.empty?
    else
      !v.nil?
    end
  end

  def validate_json(spec_json, min_spec)
    json = {}
    json[:OS] = parse_string(spec_json, :OS)
    json[:CPU] = parse_string(spec_json, :Processor)
    json[:GPU] = parse_string(spec_json, :Graphics)
    json[:RAM] = parse_string(spec_json, :Memory)
    json[:storage] = parse_string(spec_json, :Storage)
    json[:directx] = parse_string(spec_json, :DirectX)
    json[:min_spec] = true if min_spec
    json if json.values.all? { |v| valid_entry? v }
  end

  def create(parsed_json, min_spec)
    json = validate_json(parsed_json, min_spec)
    Spec.create(json) unless json.nil?
  end

  def self.create(parsed_json, min_spec = true)
    factory = SpecFactory.new
    factory.create(parsed_json, min_spec)
  end
end
