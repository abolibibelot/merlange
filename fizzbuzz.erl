-module(fizzbuzz).
-export([fizz_buzz/0]).

fizz_buzz(N) when N rem 15 == 0 -> "FizzBuzz!";
fizz_buzz(N) when N rem 5 == 0  -> "Buzz";
fizz_buzz(N) when N rem 3 == 0 -> "Fizz";
fizz_buzz(N) -> N.


fizz_buzz()->
	[io:format("~p~n",[fizz_buzz(N)]) || N <- lists:seq(1,100)].





