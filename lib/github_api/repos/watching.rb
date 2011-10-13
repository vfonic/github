# encoding: utf-8

module Github
  class Repos
    module Watching

      # List repo watchers
      #
      # = Examples
      #  @github = Github.new :user => 'user-name', :repo => 'repo-name'
      #  @github.repos.watchers
      #  @github.repos.watchers { |watcher| ... }
      #
      def watchers(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/watchers")
        return response unless block_given?
        response.each { |el| yield el }
      end

      # List repos being watched by a user
      #
      # = Examples
      #  @github = Github.new :user => 'user-name'
      #  @github.repos.watched
      #
      # List repos being watched by the authenticated user
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.repos.watched
      #
      def watched(user_name=nil, params={})
        _update_user_repo_params(user_name)
        _normalize_params_keys(params)

        response = if user
          get("/users/#{user}/watched")
        else
          get("/user/watched")
        end
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Check if you are watching a repository
      #
      # Returns <tt>true</tt> if this repo is watched by you, <tt>false</tt> otherwise
      # = Examples
      #  @github = Github.new
      #  @github.repos.watching? 'user-name', 'repo-name'
      #
      def watching?(user_name, repo_name, params={})
        _validate_presence_of user_name, repo_name
        _normalize_params_keys(params)
        get("/user/watched/#{user_name}/#{repo_name}")
        true
      rescue Github::ResourceNotFound
        false
      end

      # Watch a repository
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.start_watching 'user-name', 'repo-name'
      #
      def start_watching(user_name, repo_name, params={})
        _validate_presence_of user_name, repo_name
        _normalize_params_keys(params)
        put("/user/watched/#{user_name}/#{repo_name}")
      end

      # Stop watching a repository
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.start_watching 'user-name', 'repo-name'
      #
      def stop_watching(user_name, repo_name, params={})
        _validate_presence_of user_name, repo_name
        _normalize_params_keys(params)
        delete("/user/watched/#{user_name}/#{repo_name}")
      end

    end # Watching
  end # Repos
end # Github
