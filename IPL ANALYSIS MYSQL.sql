/* 1 TOTAL RUNS SCORED EVERY SEASON*/
SELECT LEFT(MAT.DATE,4) AS SEASON,sum(BA.TOTAL_RUNS) AS TOTALRUNSSCORED FROM
MATCHES MAT
INNER JOIN
BALLS BA
ON MAT.ID=BA.ID
GROUP BY LEFT(MAT.DATE,4)

/* 2 TOTAL WICKETS TAKEN EVERY SEASON */
SELECT LEFT(MAT.DATE,4) AS SEASONS,SUM(BA.IS_WICKET) AS TOTAL_WICKETS_TAKEN FROM 
MATCHES MAT
INNER JOIN
BALLS BA
ON MAT.ID=BA.ID
GROUP BY LEFT(MAT.DATE,4)

/* 3 HIGHEST SCORER(PLAYER) OF ALL TIME */
SELECT BATSMAN,SUM(BATSMAN_RUNS) FROM BALLS
GROUP BY BATSMAN 
ORDER BY SUM(BATSMAN_RUNS) DESC

/* 4 HIGHEST WICKET TAKER(PLAYER) OF ALL TIME */
SELECT BOWLER,SUM(IS_WICKET) FROM BALLS
GROUP BY BOWLER
ORDER BY SUM(IS_WICKET) DESC

/* 5 RUNS SCORED BY VIRAT KOHLI IN 2016 EDITION OF IPL */
SELECT LEFT(MA.DATE,4),BA.BATSMAN,SUM(BA.BATSMAN_RUNS) FROM MATCHES MA 
INNER JOIN BALLS BA
ON MA.ID=BA.ID
WHERE BA.BATSMAN IN ("V KOHLI") AND LEFT(MA.DATE,4)="2016"
GROUP BY BA.BATSMAN

/* 6  Match won by the maximum margin of runs.*/
SELECT LEFT(DATE,4) AS SEASON,TEAM1,TEAM2,WINNER,CONCAT(MAX(RESULT_MARGIN)," ","RUNS") AS WON_BY FROM MATCHES 
WHERE RESULT="RUNS"
GROUP BY ID
ORDER BY MAX(RESULT_MARGIN) DESC
LIMIT 1

/*7  Match won by maximum wickets.*/
 SELECT LEFT(DATE,4) AS SEASON,TEAM1,TEAM2,WINNER,CONCAT(MAX(RESULT_MARGIN)," ","WICKETS") AS WON_BY FROM MATCHES 
WHERE RESULT="WICKETS"
GROUP BY ID
ORDER BY MAX(RESULT_MARGIN) DESC
LIMIT 1

/*8  Match won by the minimum margin of runs.*/
 SELECT LEFT(DATE,4) AS SEASON,TEAM1,TEAM2,WINNER,CONCAT(MIN(RESULT_MARGIN)," ","RUNS") AS WON_BY FROM MATCHES 
WHERE RESULT="RUNS"
GROUP BY ID
ORDER BY MAX(RESULT_MARGIN) ASC
LIMIT 1

/*9 Match won by minimum wickets.*/
 SELECT LEFT(DATE,4) AS SEASON,TEAM1,TEAM2,WINNER,CONCAT(MIN(RESULT_MARGIN)," ","WICKETS") AS WON_BY FROM MATCHES 
WHERE RESULT="WICKETS"
GROUP BY ID
ORDER BY MAX(RESULT_MARGIN) ASC
LIMIT 1

/* 10 Matches where D/L method was and wasn't applied.*/
SELECT * FROM MATCHES WHERE METHOD="D/L"

/* 11 No. of matches held in each city.*/
select city,count(id) as no_of_matches from matches 
group by city
order by no_of_matches desc

/* 12) No. of matches won by each team. */
select winner,count(winner) as NO_OF_MATCHES_WON from matches
group by winner 
order by count(winner) desc

/*13 No. of matches held every season and in each venue */
SELECT LEFT(DATE,4),COUNT(ID) AS NUMBER_OF_MATCHES FROM MATCHES
GROUP BY LEFT(DATE,4)

SELECT VENUE,COUNT(ID) AS NO_OF_MATCHES FROM MATCHES
GROUP BY VENUE
ORDER BY COUNT(ID) DESC

/*14 Top 10 players based on no. of Man of Match (MOM) awards won. */
SELECT PLAYER_OF_MATCH,COUNT(PLAYER_OF_MATCH) AS MOST_MOM_WON FROM MATCHES
GROUP BY PLAYER_OF_MATCH 
ORDER BY COUNT(PLAYER_OF_MATCH) DESC

/*15 Does winning the toss means winning the match?*/
select left(date,4) AS SEASONS,if(round((sum(teamswhowonthetossandwonthematch)/sum(totalnumberofmatches))*100,2)>"50.00","YES MORE THAN 50% MATCHES WON BY TEAMS WHO WON THE TOSS","NO LESS THAN 50% MATCHES WON BY TEAMS WHO WON THE TOSS") AS RESULT from (
select date, if(toss_winner=winner,count(winner),null) as teamswhowonthetossandwonthematch,count(id) as totalnumberofmatches from matches
group by id) as temptable
group by left(date,4)

/*16 What was the decision taken by captains when they won the toss?*/
select left(date,4)as season,concat(sum(bat)," ","times") as batfirst,concat(sum(ball)," ","times") as fieldfirst from (
select date,if(toss_decision="bat",count(toss_decision),null) as bat,if(toss_decision="field",count(toss_decision),null) as ball from matches
group by date) as temptable
group by left(date,4)

/*17 No. of matches where D/L method was applied every season.*/
select left(date,4) as seasons,CONCAT(count(method)," ","TIMES") as DL_APPLIED from matches
where method="d/l"
group by left(date,4)

/* 18 ANALYSIS OF PLAYERS IN EACH SEASON (VIRAT KOHLI) USING WINDOWS FUNCTIONS*/
SELECT SEASONS,LAG(RUNS_SCORED) OVER ( ORDER BY SEASONS ASC) AS PREVIOUS_SEASON_SCORE,RUNS_SCORED AS CURRENT_SEASON_SCORE,LEAD(RUNS_SCORED) OVER ( ORDER BY SEASONS ASC) AS NEXT_SEASON_SCORE FROM (
SELECT LEFT(MA.DATE,4) AS SEASONS,BA.BATSMAN,SUM(BA.BATSMAN_RUNS) AS RUNS_SCORED FROM MATCHES MA 
INNER JOIN BALLS BA
ON MA.ID=BA.ID
WHERE BA.BATSMAN IN ("V KOHLI") 
GROUP BY LEFT(MA.DATE,4) ) AS TEMPTABLE

/* 19 NO OF SIX'S HIT EVERY SEASON*/
SELECT LEFT(MA.DATE,4) AS SEASONS ,COUNT(BA.BATSMAN_RUNS) AS NO_OF_SIX_HIT FROM MATCHES MA
INNER JOIN BALLS BA 
ON MA.ID=BA.ID 
WHERE BA.BATSMAN_RUNS="6"
GROUP BY LEFT(MA.DATE,4)

/* 20 NO OF FOURS HIT EVERY SEASON*/
SELECT LEFT(MA.DATE,4) AS SEASON,COUNT(BA.BATSMAN_RUNS) AS NO_OF_FOURS_HIT FROM MATCHES MA
INNER JOIN BALLS BA 
ON MA.ID=BA.ID 
WHERE BA.BATSMAN_RUNS="4"
GROUP BY LEFT(MA.DATE,4)

/* 21 TEAMS WHO HIT THE MAXIMUM NUMBER OF SIXES */
SELECT BA.BATTING_TEAM,COUNT(BA.BATSMAN_RUNS) AS TOTAL_NO_OF_SIX_HIT FROM MATCHES MA
INNER JOIN BALLS BA 
ON MA.ID=BA.ID 
WHERE BA.BATSMAN_RUNS="6"
GROUP BY BA.BATTING_TEAM
ORDER BY COUNT(BA.BATSMAN_RUNS) DESC

/* 22 TEAMS WHO HIT THE MAXIMUM NUMBER OF FOURS */
SELECT BA.BATTING_TEAM,COUNT(BA.BATSMAN_RUNS) AS TOTAL_NO_OF_4S_HIT FROM MATCHES MA
INNER JOIN BALLS BA 
ON MA.ID=BA.ID 
WHERE BA.BATSMAN_RUNS="4"
GROUP BY BA.BATTING_TEAM
ORDER BY COUNT(BA.BATSMAN_RUNS) DESC
