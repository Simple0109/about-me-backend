require "json"
require "net/http"
require "uri"

class GithubService
  attr_reader :username

  def initialize(username)
    @username = username
  end

  def fetch_user_profile
    response = make_request("users/#{username}")
    response if response
  end

  def fetch_repositories
    response = make_request("users/#{username}/repos")
    response if response
  end

  def fetch_commits(repository)
    response = make_request("repos/#{username}/#{repository}/commits")
    response if response
  end

  private

  def make_request(endpoint)
    uri = URI.parse("https://api.github.com/#{endpoint}")
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/vnd.github.v3+json"
    request["User-Agent"] = "RailsApp"

    if ENV["GITHUB_ACCESS_TOKEN"].present?
      request["Authorization"] = "token #{ENV['GITHUB_ACCESS_TOKEN']}"
    end

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    return JSON.parse(response.body) if response.code == "200"

    Rails.logger.error("GitHub API error: #{response.code} - #{response.body}")
    nil
  end
end
