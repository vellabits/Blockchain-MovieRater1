App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // TODO: refactor conditional
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("MovieRater.json", function(movieRater) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.MovieRater = TruffleContract(movieRater);
      // Connect provider to interact with contract
      App.contracts.MovieRater.setProvider(App.web3Provider);

      return App.render();
    });
  },

  render: function() {
    var movieRatingInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.MovieRater.deployed().then(function(instance) {
      movieRatingInstance = instance;
      return movieRatingInstance.numMovies();
    }).then(function(numMovies) {
      var ratingResults = $("#ratingResults");
      ratingResults.empty();

      for (var i = 1; i <= numMovies; i++) {
        movieRatingInstance.movies(i).then(function(movie) {
          var name = movie;
          var ratings;
          movieRatingInstance.seeRating.call(name).then(function(rating) {
            name=rating;
            ratings=rating;
          });

         // var ratings = movie[1];
         // var totalScore = movie[2];

          // Render candidate Result
          var movieTemplate = "<tr><td>" + name + "</td><td>" + ratings + "</td></tr>"
          ratingResults.append(movieTemplate);


        });
      }


        var ratingOption;
         for (var i=1; <=5; i++) {
            "<option value='" + ratingOption + "' >" + i + "</ option>"
          }
          //var ratingOption = "<option value='" + id + "' >" + 1 + "</ option>"
          selectRating.append(ratingOption);
         //movieRatingInstance.seeMovies.call();
      loader.hide();
      content.show();
    }).catch(function(error) {
      console.warn(error);
    });

  /*var listOfMovies = $("#moviesList");
  listOfMovies = */

  }

  rateMovie: function() {
      var movie = $('#selectRating').val();
      App.contracts.Election.deployed().then(function(instance) {
        return instance.addRating(movie, { from: App.account });
      }).then(function(result) {
        // Wait for votes to update
        $("#content").hide();
        $("#loader").show();
      }).catch(function(err) {
        console.error(err);
      });
    }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
