class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true 
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:public_key],
                                  secret_token: Rails.application.credentials.iex_client[:secret_key],
                                  endpoint: 'https://cloud.iexapis.com/v1')
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name,
          last_price: client.price(ticker_symbol))
    rescue StandardError => e
      return nil
    end
  end
    
  def self.check_db(ticker)
    where(ticker: ticker).first
  end
end
