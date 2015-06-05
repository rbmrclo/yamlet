require 'spec_helper'

RSpec.describe Yamlet do

  context "with missing repository_file" do
    it "raises an error" do
      expect {

        class User
          include Yamlet.model
        end

      }.to raise_error(Yamlet::RepositoryNotFound)
    end
  end

  context "with configured repository_file" do
    before do
      Yamlet.repository_file = File.join(Dir.pwd, "spec", "fixtures", "repository.yml")

      class Animal
        include Yamlet.model
      end
    end

    after { Animal.destroy_all }

    it { expect { Animal.new }.not_to raise_error }

    it { expect(Animal).to respond_to(:resource_name) }
    it { expect(Animal).to respond_to(:store) }
    it { expect(Animal).to respond_to(:all) }
    it { expect(Animal).to respond_to(:find) }
    it { expect(Animal).to respond_to(:create) }
    it { expect(Animal).to respond_to(:update) }
    it { expect(Animal).to respond_to(:destroy) }
    it { expect(Animal).to respond_to(:destroy_all) }

    describe "methods" do
      describe ".store" do
        it "returns a YAML::Store instance" do
          expect(Animal.store).to be_a YAML::Store
        end
      end

      describe ".resource_name" do
        it "returns a formatted string of the class" do
          expect(Animal.resource_name).to eq "animal"
        end
      end

      describe ".all" do
        it "returns an array" do
          expect(Animal.all).to be_a Array
        end

        it "returns all records" do
          5.times { Animal.create(name: "grumpy") }

          expect(Animal.all.count).to eq 5
        end
      end

      describe ".find" do
        before :each do
          Animal.create(name: "grumpy")
        end

        context "with valid id" do
          it "returns a record" do
            record = Animal.find(1)
            expect(record["name"]).to eq "grumpy"
          end
        end

        context "with invalid id" do
          it "returns nil" do
            record = Animal.find(99999)
            expect(record).to be_nil
          end
        end
      end

      describe ".create" do
        context "with attributes" do
          it "creates a record with id and the given attributes" do
            expect(Animal.all.count).to eq 0
            Animal.create(breed: "cat")
            expect(Animal.all.count).to eq 1
            expect(Animal.find(1)["breed"]).to eq "cat"
          end
        end

        context "with blank attributes" do
          it "creates a record with id and empty attributes" do
            expect(Animal.all.count).to eq 0
            Animal.create
            expect(Animal.all.count).to eq 1
            expect(Animal.find(1).keys[0]).to eq "id"
            expect(Animal.find(1).keys.count).to eq 1
          end
        end
      end

      describe ".update" do
        it "updates attributes of a record" do
          Animal.create(name: "grumpy")
          expect(Animal.find(1)["name"]).to eq "grumpy"

          Animal.update(1, name: "wazzup")
          expect(Animal.find(1)["name"]).to eq "wazzup"
        end
      end

      describe ".destroy" do
        before { Animal.create(name: "grumpy") }

        context "with valid id" do
          it "deletes the record" do
            expect(Animal.all.count).to eq 1
            Animal.destroy(1)
            expect(Animal.all.count).to eq 0
          end
        end

        context "with invalid id" do
          it "does nothing" do
            expect(Animal.all.count).to eq 1
            Animal.destroy(99999)
            expect(Animal.all.count).to eq 1
          end
        end
      end

      describe ".destroy_all" do
        it "deletes all the record" do
          5.times { Animal.create(name: "grumpy") }
          expect(Animal.all.count).to eq 5

          Animal.destroy_all
          expect(Animal.all.count).to eq 0
        end
      end

    end
  end

end
