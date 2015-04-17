class Policy < ActiveRecord::Base
  validates :content_id, presence: true, uniqueness: true
  validates :name, :slug, presence: true, uniqueness: true
  validates :description, presence: true

  validate :applicable_to_at_least_one_nation
  validate :alternative_urls_are_valid

  has_many :policy_relations
  has_many :related_policies, class_name: 'Policy', through: :policy_relations, source: :related_policy

  has_many :inverse_policy_relations, class_name: 'PolicyRelation', foreign_key: 'related_policy_id'
  has_many :parent_policies,  through: :inverse_policy_relations, source: :policy

  before_validation on: :create do |object|
    object.slug = object.name.to_s.parameterize
    object.content_id = SecureRandom.uuid
  end

  scope :areas, -> { joins("LEFT OUTER JOIN policy_relations
                            ON policies.id = policy_relations.related_policy_id
                            WHERE policy_relations.related_policy_id IS NULL") }

  # Virtual attribute used to identify a new record as a programme
  attr_writer :programme
  def programme
    @programme || parent_policies.any?
  end
  alias_method :programme?, :programme

  def base_path
    "/government/policies/#{slug}"
  end

  def possible_nations
    [
      :england,
      :northern_ireland,
      :scotland,
      :wales,
    ]
  end

  def applicable_nations
    applicable_nations = possible_nations.select { |n|
      self.send(n) == true
    }
  end

  def inapplicable_nations
    possible_nations - applicable_nations
  end

private

  def applicable_to_at_least_one_nation
    if applicable_nations.empty?
      errors.add(:applicability, "must have at least one nation")
    end
  end

  def alternative_urls_are_valid
    alt_policy_urls = inapplicable_nations.select { |nation|
      self.send(:"#{nation}_policy_url").present?
    }

    nations_with_bad_urls = alt_policy_urls.reject { |nation|
      self.send(:"#{nation}_policy_url") =~ /\A#{URI::regexp(['http', 'https'])}\z/
    }

    nations_with_bad_urls.each do |nation|
      errors.add(nation, "must have a valid alternative policy URL")
    end
  end
end
