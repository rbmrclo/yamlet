require "yaml/store"
require "yamlet/version"

module Yamlet
  RepositoryNotFound = Class.new(StandardError)

  @@repository_file = nil

  def self.repository_file
    @@repository_file
  end

  def self.repository_file=(file)
    @@repository_file = file
  end

  module Repository

    def self.store
      @store ||= YAML::Store.new Yamlet.repository_file
    rescue
      raise Yamlet::RepositoryNotFound.new("YAML file can't be located")
    end

  end

  module Model

    def self.included(klass)
      klass.define_singleton_method :resource_name, -> {
        name = klass.to_s.downcase
        name.gsub!("::", "_") if name.include? "::"

        return name
      }

      klass.define_singleton_method :store, -> { Yamlet::Repository.store }

      klass.store.transaction { klass.store[klass.resource_name] ||= [] }

      klass.define_singleton_method :all, -> {
        store.transaction { store[resource_name] }
      }

      klass.define_singleton_method :find, ->(id) {
        store.transaction { store[resource_name].select { |s| s["id"] == id }[0] }
      }

      klass.define_singleton_method :create, ->(attributes = {}) {
        # Auto increment ids
        ids = all.empty? ? [0] : all.map { |s| s["id"] }
        id  = ids[-1].zero? ? 1 : ids[-1].succ

        if attributes.empty?
          store.transaction { store[resource_name].push({ "id" => id }) }
        else
          store.transaction {
            store[resource_name].push(
              {}.tap do |hash|
                hash["id"] = id
                attributes.each_pair { |k, v| hash[k.to_s] = v }
              end
            )
          }
        end
      }

      klass.define_singleton_method :update, ->(id, attributes) {
        store.transaction {
          store[resource_name].select { |s| s["id"] == id }[0].tap do |record|
            attributes.each_pair { |k, v| record[k.to_s] = v } unless record.nil?
          end
        }
      }

      klass.define_singleton_method :destroy, ->(id) {
        store.transaction { store[resource_name].delete_if { |h| h["id"] == id } }
      }

      klass.define_singleton_method :destroy_all, -> {
        store.transaction { store[resource_name] = [] }
      }

    end
  end

  def self.model
    Yamlet::Model
  end

end
