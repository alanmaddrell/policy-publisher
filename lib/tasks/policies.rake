namespace :policies do
  desc "Alphabetise all policies and republish them to the Publishing API"
  task alphabetise: :environment do
    policies = Policy.all.order(:name)
    policies.reverse.each do |policy|
      Publisher.new(policy).publish!
    end
  end
end
