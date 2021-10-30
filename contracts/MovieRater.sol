pragma solidity ^0.5.16;

contract MovieRater {

    // number of movies in theatres
    uint public numMovies;

    struct Movie {
        string name;
        uint numRatings;
        uint totalScore;
    }

    constructor () public{
        addMovie("James Bond");
        addMovie("Avengers");
        addMovie("Star Wars");
    }
    // Get movies
    mapping(string => Movie) public movies;

    // Get raters, list of movies they've rated
    mapping(address => mapping(string => uint)) public ratings;

    function addMovie(string memory _name) private {
        numMovies++;
        movies[_name] = Movie(_name, 0, 0);
    }

    function seeMovies() public returns (string memory) {
        return string(abi.encodePacked("Star Wars: ", getRating("Star Wars"), ", ",
            "Avengers: ", getRating("Avengers"), ", ",
            "James Bond: ", getRating("James Bond")));
    }


    /**
     * Add rating to a movie
     * @param _name: name of the movie to rate
	 * @param _score: score of 1 - 5 received by the movie
	 */
    function addRating(string memory _name, uint _score) public {

       /* require(!ratings[msg.sender][_name]);
        require(_score >= 1 && _score <= 5);

        // keep track the rater has rated this movie
        ratings[msg.sender][_name] = _score;

        // update ratings
        movies[_name].numRatings++;
        movies[_name].totalScore += _score;*/

        require(ratings[msg.sender][_name] == 0, "You have already rated this movie.");
        require(_score >= 1 && _score <= 5, "Please enter a rating between 1 and 5.");

        // keep track the rater has rated this movie
        ratings[msg.sender][_name] = _score;

        // update ratings
        movies[_name].numRatings++;
        movies[_name].totalScore += _score;
    }

   /* *//**
     * Get rating of a movie.
     * @param _name: name of the movie
	 *//*
    function getRating(string memory _name) public returns (uint) {
        return movies[_name].numRatings == 0 ? 0 :
        movies[_name].totalScore / movies[_name].numRatings;
    }*/

    /**
	 * See the current overall ratings of a movie.
	 * @param _name: name of the movie
	 */
    function seeRating(string memory _name) public returns (string memory) {
        return string(abi.encodePacked(_name, ": ", getRating(_name)));
    }

    /**
	 * Edit rating of a movie
	 * @param _name: name of the movie to rate
	 * @param _score: score of 1 - 5 received by the movie
	 */
    function editRating(string memory _name, uint _score) public {

        require(ratings[msg.sender][_name] != 0, "You have not rated this movie.");
        require(_score >= 1 && _score <= 5, "Please enter a rating between 1 and 5.");

        uint prevRating = ratings[msg.sender][_name];

        movies[_name].totalScore -= prevRating;
        movies[_name].totalScore += _score;

    }

    /**
     * Delete your rating of a movie.
     * @param _name: name of the movie
	 */
    function deleteRating(string memory _name) public {

        require(ratings[msg.sender][_name] != 0, "You have not rated this movie.");

        uint prevRating = ratings[msg.sender][_name];
        ratings[msg.sender][_name] = 0;

        movies[_name].numRatings--;
        movies[_name].totalScore -= prevRating;

    }

    /**
	 * Get rating of a movie.
	 * @param _name: name of the movie
	 */
    function getRating(string memory _name) private returns (string memory) {
        return uint2str(movies[_name].numRatings == 0 ? 0 :
            movies[_name].totalScore / movies[_name].numRatings);
    }

    /**
     * Helper function, converts int to str
     * _i: int to convert to str
      */
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
