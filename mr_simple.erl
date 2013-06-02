-module(mr_simple).
-export([map_reduce/3,test_mr/0]).

-define(PONCTUATION, [<<" ">>,<<"'">>,<<".">>,<<";">>,<<":">>,<<"?">>,<<",">>,<<"!">>]).


map_reduce(Mapper,Reducer,Seq)->
    Mapped=[Mapper(Item) || Item <- Seq],
    io:format("Mapped:~p~n",[lists:flatten(Mapped)]),
    Collected=lists:foldl(fun({K,Vs},Acc) -> dict:update(K,fun(V)->[{K,Vs}|V] end,[],Acc) end,
                dict:new(),
                lists:flatten(Mapped)),
    lists:foldl(fun({K,Vs},Acc)-> dict:store(K,Reducer(K,Vs),Acc) end,
                dict:new(),
                Collected).




test_mr()->
    Input = [<<"Maintenant tu marches dans Paris tout seul parmi la foule">>,
<<"Des troupeaux d'autobus mugissants près de toi roulent">>,
<<"L'angoisse de l'amour te serre le gosier">>,
<<"Comme si tu ne devais jamais plus être aimé">>,
<<"Si tu vivais dans l'ancien temps tu entrerais dans un monastère">>,
<<"Vous avez honte quand vous vous surprenez à dire une prière">>,
<<"Tu te moques de toi et comme le feu de l'Enfer ton rire pétille">>,
<<"Les étincelles de ton rire dorent le fond de ta vie">>,
<<"C'est un tableau pendu dans un sombre musée">>,
<<"Et quelquefois tu vas la regarder de près">>],

    Mapper= fun(Line)-> 
                    Words =binary:split(Line,?PONCTUATION,[global]),
                    [{W,1} || W <- Words]
            end,

    Reducer= fun(Key,Pairs)->
                io:format("Pairs:~p~n",[Pairs]),
                {Key,lists:foldl(fun({_,Count},Acc)->Acc+Count end,0,Pairs)}
             end,

    map_reduce(Mapper,Reducer,Input).

