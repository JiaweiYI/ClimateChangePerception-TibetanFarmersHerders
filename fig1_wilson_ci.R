library(DescTools)

#Gender-female
BinomCI(8011,24296,method="wilson")

#Education-elementary or below
BinomCI(20316,21161,method="wilson")

#Credit-yes
BinomCI(3789,7891,method="wilson")

#Water access-good
BinomCI(9686,13419,method="wilson")

#Media-trust
BinomCI(12756,15069,method="wilson")

#Temperature change perception
BinomCI(15637,24303,method="wilson") #no change
BinomCI(6297,24303,method="wilson") #increase
BinomCI(2048,24303,method="wilson") #decrease
BinomCI(321,24303,method="wilson") #unknown

#Precipitation change perception
BinomCI(13878,24303,method="wilson") #no change
BinomCI(6849,24303,method="wilson") #increase
BinomCI(3170,24303,method="wilson") #decrease
BinomCI(406,24303,method="wilson") #unknown

#Climate impact
BinomCI(8949,24303,method="wilson") #great
BinomCI(7419,24303,method="wilson") #average
BinomCI(7935,24303,method="wilson") #little

#Adaptive capacity
BinomCI(20740,24303,method="wilson") #good
BinomCI(3016,24303,method="wilson") #average
BinomCI(547,24303,method="wilson") #weak

#Mitigation effect
BinomCI(13194,24303,method="wilson") #great
BinomCI(6788,24303,method="wilson") #average
BinomCI(4321,24303,method="wilson") #little

#Future climate
BinomCI(22200,24303,method="wilson") #better
BinomCI(2103,24303,method="wilson") #worse





