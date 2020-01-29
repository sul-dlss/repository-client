# frozen_string_literal: true

module SdrClient
  module Deposit
    # This represents the metadata that we send to the server for doing a deposit
    class Request
      # @param [String] label the required object label
      # @param [String] type (http://cocina.sul.stanford.edu/models/object.jsonld) the required object type.
      # @param [Array<FileSet>] file_sets the file sets to attach.
      # rubocop:disable Metrics/ParameterLists
      def initialize(label: nil,
                     apo:,
                     collection:,
                     source_id:,
                     catkey: nil,
                     type: 'http://cocina.sul.stanford.edu/models/object.jsonld',
                     file_sets: [])
        @label = label
        @type = type
        @source_id = source_id
        @collection = collection
        @catkey = catkey
        @apo = apo
        @file_sets = file_sets
      end
      # rubocop:enable Metrics/ParameterLists

      def as_json
        {
          access: {},
          type: type,
          administrative: administrative,
          identification: identification,
          structural: structural
        }.tap do |json|
          json[:label] = label if label
        end
      end

      # @return [Request] a clone of this request with the file_sets added
      def with_file_sets(file_sets)
        Request.new(label: label,
                    apo: apo,
                    collection: collection,
                    source_id: source_id,
                    catkey: catkey,
                    type: type,
                    file_sets: file_sets)
      end

      private

      attr_reader :label, :file_sets, :source_id, :catkey, :apo, :collection, :type

      def administrative
        {
          hasAdminPolicy: apo
        }
      end

      def identification
        { sourceId: source_id }.tap do |json|
          json[:catkey] = catkey if catkey
        end
      end

      def structural
        {
          isMemberOf: collection,
          hasMember: file_sets.map(&:as_json)
        }
      end
    end
  end
end
