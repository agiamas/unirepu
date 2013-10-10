class DashboardController < ApplicationController
  def index
    # render text: session.inspect
    # return
    client = Twitter.configure do |config|
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
      config.oauth_token = session['twitter_account_token']
      config.oauth_token_secret = session['twitter_account_token_secret']
    end

    @user_tweets = client.user_timeline(:count => 50)

    # start fetching data to feed to our super algorithm
    @tweet_text = ''
    @user_tweets.each do |t|
      @tweet_text = @tweet_text + t.text
    end
    @tweet_text = @tweet_text.downcase


    @number_of_friends = 110#client.user.friends_count
    @number_of_followers = 500 #client.user.followers_count*4

    @scores = algorithm(@tweet_text, @number_of_friends, @number_of_followers)

    fb_data = fetch_facebook_data
    @fb_scores = algorithm(fb_data[:posts], fb_data[:number_of_friends])
  end

  # returns a has of overall score for the user and sub scores for products, politics, technology and sports
  def algorithm (tweet_text, number_friends, number_followers=1)
    total_count = tweet_text.split(" ").size
    #tech
    @tech_freq = get_frequency_of_word_in_text(tweet_text, 'mongodb oracle #tech', total_count)
    #products
    @product_freq = get_frequency_of_word_in_text(tweet_text, 'yahoo google #google apple', total_count)
    #politics
    @politics_freq = get_frequency_of_word_in_text(tweet_text, 'communists πασοκ thalassa', total_count)
    #sports
    @sports_freq = get_frequency_of_word_in_text(tweet_text, 'panathinaikos olympiakos', total_count)
    @highest_freq = [@tech_freq.to_i, @product_freq.to_i, @politics_freq.to_i, @sports_freq.to_i].sort.last

    puts "total_count: #{total_count}"
    puts "tech_freq: #{@tech_freq}"
    puts "product_freq: #{@product_freq}"
    puts "politics_freq: #{@politics_freq}"
    puts "sports_freq: #{@sports_freq}"
    puts "highest_freq: #{@highest_freq}"

    # higher ratio indicates famous person
    @friend_follow_ratio = number_friends / number_followers

    @normalize_factor = @friend_follow_ratio.to_f * @highest_freq.to_f
    @tech_relative_freq = @tech_freq / @normalize_factor
    @product_relative_freq = @product_freq / @normalize_factor
    @politics_relative_freq = @politics_freq / @normalize_factor
    @sports_relative_freq = @sports_freq / @normalize_factor
    @avg_relative_freq = (@tech_relative_freq + @product_relative_freq + @politics_relative_freq + @sports_relative_freq) / 4
    @score = {:overall => @avg_relative_freq*1000, :tech => @tech_relative_freq*1000, :product => @product_relative_freq*1000, :politics => @politics_relative_freq*1000, :sports => @sports_relative_freq*1000}

    return @score
  end

  def get_frequency_of_word_in_text(tweet_text, keyphrases, total_count)
    @count_kp = 0

    keyphrases.split(" ").each do |kp|
      @count_kp = @count_kp + tweet_text.split(" ").count(kp)
    end

    if (@count_kp>0) then
      return (total_count/@count_kp)
    else
      return 0
    end

  end

  def fetch_facebook_data
    graph = Koala::Facebook::API.new(session[:facebook_account_token])

    data = {}
    posts = graph.fql_query("SELECT message FROM stream WHERE source_id = me() LIMIT 100")
    data[:number_of_friends] = graph.fql_query("select friend_count from user where uid = me()").first['friend_count']
    data[:posts] = posts.map(&:values).flatten.join(' ').downcase #normilize the post results

    data
  end

end
