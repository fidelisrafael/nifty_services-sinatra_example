class User < ActiveRecord::Base
  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :posts
  
  has_secure_password

  scope :not_activated, -> { where(activated_at: nil) }
  scope :account_activated, -> { where.not(activated_at: nil) }

  before_save :generate_activation_token

  validates :email, uniqueness: true, on: [:create]

  validates :email, format: { with: EMAIL_REGEXP }, if: -> {
    self.email.present?
  }

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user.try(:authenticate, password)
  end

  def clear_auth_token!
    self.update_attribute(:auth_token, nil)
  end

  def generate_auth_token!
    self.update_attribute(:auth_token, generate_unique_token(:auth_token))
    self.auth_token
  end

  def activate_account!
    return true if self.account_activated?
    self.update_attributes(activated_at: Time.now)
  end

  def deactivate_account!
    self.update_attributes(activated_at: nil, activation_token: nil)
  end

  def account_activated?
    [self.activation_token, self.activated_at].all?
  end

  def account_deactivated?
    !account_activated?
  end

  def send_account_activation_mail!
    Pony.mail(:to => self.email, :subject => I18n.t('mailers.activate_acount') , :body => "Token: #{self.activation_token}")

    self.update_attribute(:activation_sent_at, Time.now)
  end

  def name=(full_name)
    names = full_name.split(/\s/)
    self.first_name = names.shift
    self.last_name  = names.join(' ')
  end

  def name
    [self.first_name, self.last_name].join(' ')
  end

  private
  def generate_activation_token
    return self if self.activation_token

    self.activation_token = generate_unique_token(:activation_token)

    nil
  end

  def generate_unique_token(column)
    begin
      token = SecureRandom.hex
    end while self.class.exists?(column => token)

    token
  end
end