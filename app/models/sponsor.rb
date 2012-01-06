class Sponsor < ActiveRecord::Base
  attr_accessible :company_name, :sponsor_level, :sponsor_date,
  :logo_file_name, :logo_content_type, :logo_file_size, :logo_updated_at,
  :logo, :url, :blurb

  validates_presence_of :company_name
  validates_presence_of :sponsor_level

  named_scope :ruby,      :conditions => ["upper(sponsor_level) = ?",
                                          "1-RUBY"],
                          :order => 'sponsor_date desc'

  named_scope :gold,      :conditions => ["upper(sponsor_level) = ?",
                                          "2-GOLD"],
                          :order => 'sponsor_date desc'

  named_scope :silver,    :conditions => ["upper(sponsor_level) = ?",
                                          "3-SILVER"],
                          :order => 'sponsor_date desc'

  named_scope :bronze,    :conditions => ["upper(SPONSOR_LEVEL) = ?",
                                          "4-Bronze"],
                          :order => 'sponsor_date desc'

  has_attached_file :logo, 
                    :storage => :s3,
                    :bucket => 'larubyconf',
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :styles => {
                    :default_url => '/sponsors/'}

  SPONSOR_LEVELS = ['1-Ruby','2-Gold','3-Silver','4-Bronze','9-Media']

  before_create :set_sponsor_date

  def to_param
    "#{id}-#{company_name.parameterize}"
  end


  def sponsorship_title
    case sponsor_level.to_i
      when 1
      "Platinum"
      when 2
      "Gold"
      when 3
      "Silver"
      when 4
      "Bronze"
      when 9
      "Media"
      else
      "{missing}"
    end
  end

  private

  def set_sponsor_date
    self.sponsor_date ||= Date.today
  end
end
