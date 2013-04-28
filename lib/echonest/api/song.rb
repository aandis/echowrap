require 'echonest/api/utils'
require 'echonest/song'

module Echonest
  module API
    module Song
      include Echonest::API::Utils
      # Search for songs given different query types
      #
      # @see http://developer.echonest.com/docs/v4/song.html
      # @authentication Requires api key
      # @raise [Echonest::Error::Unauthorized] Error raised when supplied api key is not valid.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :title The title of the song.
      # @option options [String] :artist The artist of the song.
      # @option options [String] :combined Query both artist and title fields.
      # @option options [String] :description A description of the artist, some examples are: 'alt-rock','-emo', 'harp^2'. Warning Description cannot be used in conjunction with title, artist, combined, or artist_id.
      # @option options [String] :style A musical style or genre like rock, jazz, or funky, some examples are: 'jazz', 'metal^2'.
      # @option options [String] :mood A mood like happy or sad, some examples are: 'happy', 'sad^.5'.
      # @option options [String] :rank_type For search by description, style or mood indicates whether results should be ranked by query relevance or by artist familiarity, must be one of ['relevance', 'familiarity'], with 'relevance' as default
      # @option options [String] :artist_id The artist ID. An Echo Nest ID or a Rosetta ID.
      # @option options [Integer] :results The desired number of results to return, the valid range is 0 to 100, with 15 as the default
      # @option options [Integer] :start The desired index of the first result returned, must be on of [0, 15, 30] with 0 as the default
      # @option options [String] :song_type Controls the type of songs returned. Supported song_types are: 'christmas', 'live' and 'studio'. A song type can optionally be followed by ':' and a state, where the state can be one of 'true', 'false' or 'any'. If no state is given, the desired state is assumed to be 'true'.
      # @option options [Float] :max_tempo The maximum tempo for the song, the valid range for max_tempo is 0.0 to 500.0 (BPM), with 500.0 as default.
      # @option options [Float] :min_tempo The minimum tempo for the song, the valid range for min_tempo is 0.0 to 500.0 (BPM), with 0.0 as default.
      # @option options [Float] :max_duration The maximum duration of any song, the valid range for max_duration is 0.0 to 3600.0 (seconds), with 3600.0 as default.
      # @option options [Float] :min_duration The minimum duration of any song, the valid range for min_duration is 0.0 to 3600.0 (seconds), with 0.0 as default.
      # @option options [Float] :max_loudness The maximum loudness of any song, the valid range for max_loudness is -100.0 to 100.0 (decibels), with 100.0 as default.
      # @option options [Float] :min_loudness The minimum loudness of any song, the valid range for min_loudness is 0.0 to -100.0 (decibels), with -100.0 as default.
      # @option options [Float] :artist_max_familiarity The maximum familiarity of any song, the valid range for artist_max_familiarity is 0.0 to 1.0, with 1.0 as default.
      # @option options [Float] :artist_min_familiarity The minimum familiarity of any song, the valid range for artist_min_familiarity is 0.0 to 1.0, with 0.0 as default.
      # @option options [String] :artist_start_year_before Matches artists that have an earliest start year before the given value, some examples are '1970', '2011', 'present'.
      # @option options [String] :artist_start_year_after Matches artists that have an earliest start year after the given value, some examples are '1970', '2011', 'present'.
      # @option options [String] :artist_end_year_before Matches artists that have an latest start year before the given value, some examples are '1970', '2011', 'present'.
      # @option options [String] :artist_end_year_after Matches artists that have an latest start year after the given value, some examples are '1970', '2011', 'present'.
      # @option options [Float] :song_max_hotttnesss The maximum hotttnesss of any song, the valid range for song_max_hotttnesss is 0.0 to 1.0, with 1.0 as default.
      # @option options [Float] :song_min_hotttnesss The minimum hotttnesss of any song, the valid range for the song_min_hotttnesss is 0.0 to 1.0, with 0.0 as default.
      # @option options [Float] :artist_max_hotttnesss The maximum hotttnesss of any song's artist, the valid range for artist_max_hotttnesss is 0.0 to 1.0, with 1.0 as default.
      # @option options [Float] :artist_min_hotttnesss The minimum hotttnesss of any song's artist, the valid range for the artist_min_hotttnesss is 0.0 to 1.0, with 0.0 as default.
      # @option options [Float] :max_longitude The maximum longitude of the primary artist location, the valid range for max_longitude is -180.0 to 180.0, with 180.0 as default.
      # @option options [Float] :min_longitude The minimum longitude of the primary artist location, the valid range for min_longitude is -180.0 to 180.0, with -180.0 as default.
      # @option options [Float] :max_latitude The maximum latitude of the primary artist location, the valid range for max_latitude is -90.0 to 90.0, with 90.0 as default.
      # @option options [Float] :min_latitude The minimum longitude of the primary artist location, the valid range for max_latitude is -90.0 to 90.0, with -90.0 as default.
      # @option options [Float] :max_danceability The maximum danceability of any song, the valid range for max_danceability is 0.0 to 1.0, with 1.0 as default.
      # @option options [Float] :min_danceability The minimum danceability of any song, the valid range for min_danceability is 0.0 to 1.0, with 0.0 as default.
      # @option options [Float] :max_energy The maximum energy of any song, the valid range for max_energy is 0.0 to 1.0, with 1.0 as default.
      # @option options [Float] :min_energy The minimum energy of any song, the valid range for min_energy is 0.0 to 1.0, with 0.0 as default.
      # @option options [Float] :max_liveness The maximum liveness of any song, the valid range for max_liveness is 0.0 to 1.0, with 1.0 as default.
      # @option options [Float] :min_liveness The minimum liveness of any song, the valid range for min_liveness is 0.0 to 1.0, with 0.0 as default.
      # @option options [Float] :max_speechiness The maximum speechiness of any song, the valid range for max_speechiness is 0.0 to 1.0, with 1.0 as default.
      # @option options [Float] :min_speechiness The minimum speechiness of any song, the valid range for min_speechiness is 0.0 to 1.0, with 0.0 as default.
      # @option options [Integer] :key The key of songs in the playlist, the valid range for key is 0 to 11 (C, C-sharp, D, D-sharp, E... with 0 representing C and 11 representing B).
      # @option options [Integer] :mode The mode of songs, must be one of [0, 1] (minor, major), with 0 representing minor and 1 represeting major.
      # @option options [String] :bucket Indicates what data should be returned for each song. If specifying the "tracks" bucket, a bucket with an id space must also be specified. Must be one of ['audio_summary', 'artist_familiarity', 'artist_hotttnesss', 'artist_location', 'song_hotttnesss', 'song_type', 'tracks', 'id:Rosetta-space'].
      # @option options [String] :sort Indicates how the songs results should be ordered. Must be one of ['tempo-asc', 'duration-asc', 'loudness-asc', 'speechiness-asc', 'liveness-asc', 'artist_familiarity-asc', 'artist_hotttnesss-asc', 'artist_start_year-asc', 'artist_start_year-desc', 'artist_end_year-asc', 'artist_end_year-desc', 'song_hotttness-asc', 'latitude-asc', 'longitude-asc', 'mode-asc', 'key-asc', 'tempo-desc', 'duration-desc', 'loudness-desc', 'liveness-desc', 'speechiness-desc', 'artist_familiarity-desc', 'artist_hotttnesss-desc', 'song_hotttnesss-desc', 'latitude-desc', 'longitude-desc', 'mode-desc', 'key-desc', 'energy-asc', 'energy-desc', 'danceability-asc', 'danceability-desc'].
      # @option options [String] :limit If 'true', limit the results to any of the given idspaces or catalogs. Must be on of ['true', 'false'] with 'false' as the default.
      # @return [Array<Echonest::Song>]
      # @example Return an array of songs with artist 'Daft Punk'
      #   Echonest.song_search(:artist => "Daft Punk")
      def song_search(options={})
        song_objects_from_response(:get, "/api/v4/song/search", options)
      end

      private

        # @param request_method [Symbol]
        # @param path [String]
        # @param params [Hash]
        # @return [Array]
        def song_objects_from_response(request_method, path, params={})
          objects_from_array(Echonest::Song, send(request_method.to_sym, path, params)[:body][:response][:songs])
        end
    end
  end
end