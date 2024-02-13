# DATA TYPES **************************************************************************************************************

SELECT (2.0::INTEGER); # 2
SELECT (2.01::DECIMAL); # 2.01

SELECT (2.01::REAL); # 2.01 

# Rules for numeric 
# ID PK - SERIAL | INTEGER AUTOINCREMENT 
# Numbers without a point - INTEGER 
# Big precision - NUMERIC
# Small precision - DECIMAL

SELECT ('CHARS'::CHAR(3)); # CHA
SELECT ('A'::CHAR(3)); # A__ (Adds two spaces)
SELECT ('CHARS'::VARCHAR(3)) # CHA 
SELECT ('A'::VARCHAR(3)); # A (without spaces)
SELECT ('Really long string'::TEXT) 

# Char types are optimized so no need to think what type

SELECT ('yes'::BOOLEAN); # true 
SELECT ('y'::BOOLEAN); # true 
SELECT (1::BOOLEAN); # true 


SELECT('10-20-2022'::DATE); # 2022-10-20 (Will recognize any formatting) (DATE)
SELECT('10:20:11'::TIME); # Time without a timezone
SELECT('10:20:11 PST'::TIME WITH TIME ZONE); # Time with a timezone
SELECT('10:20:11 z'::TIME WITH TIME ZONE); # UTC

SELECT('12-11-2021 10:20:11'::TIMESTAMP); # Date-time without timezone
SELECT('12-11-2021 10:20:11 EST'::TIMESTAMP WITH TIME ZONE); # with tz


SELECT ('1D 20H 10M'::INTERVAL) - ('1D':INTERVAL);
SELECT('NOV-20-1980 1:23 AM EST'::TIMESTAMP WITH TIME ZONE) - ('1D'::INTERVAL);

