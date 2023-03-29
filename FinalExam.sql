-- Q1 Show first name, last name, phone number, and full address of customers (return total 4 columns)

SELECT 
    CustFirstName,
    CustLastName,
    CustPhoneNumber,
    CONCAT(CustStreetAddress, ', ', CustCity, ', ', CustState,', ', CustZipCode) AS CustFullAddress
FROM 
    Customers;
    
-- Q2 Find customers who like Standards but not Jazz.

SELECT 
     c.*
FROM 
    Musical_Preferences c
    JOIN Musical_Styles g ON c.StyleID = g.StyleID
WHERE 
    g.StyleName = 'Standards'
    AND c.CustomerID NOT IN (
        SELECT 
            c.CustomerID
        FROM 
            Musical_Preferences c
            JOIN Musical_Styles g ON c.StyleID = g.StyleID
        WHERE 
            g.StyleName = 'Jazz'
    );

-- Q3 Show the entertainers who have no booking.

SELECT 
    e.*
FROM 
    Engagements e
WHERE 
   e.EntertainerID IS NULL;
   
-- Q4 Show agents who have never booked a Country or Country Rock group.
  
SELECT 
    a.*
FROM 
    agents a
WHERE 
    a.AgentID NOT IN (
        SELECT 
            DISTINCT b.AgentID
        FROM 
            Engagements b
            JOIN Musical_Preferences g ON b.CustomerID = g.CustomerID
        WHERE 
            g.StyleID = 6 OR g.StyleID = 11);
            
-- Q5 List the entertainers who played engagement for either customers Berg or Hallmark

SELECT 
    e.EntertainerID, e.EntStageName, c.CustLastName
FROM 
    entertainers e
    JOIN engagements b ON e.entertainerid = b.entertainerid
    JOIN customers c ON b.customerid = c.Customerid
WHERE 
    c.CustLastName IN ('Berg', 'Hallmark');
    
-- Q6 Delete musical styles that aren’t played by any entertainer.

DELETE FROM 
    Musical_Styles
WHERE 
    StyleID NOT IN (
        SELECT 
            DISTINCT StyleID
        FROM 
            Entertainer_Styles
    );

--  Q7 Add five percent to the salary of agents.

UPDATE 
    Agents
SET 
    salary = salary * 1.05;

-- Q8 Show the entertainers who have more than two overlapped bookings.

SELECT 
    e.EntStageName
FROM 
    entertainers e
JOIN 
    engagements b1 ON e.EntertainerID = b1.EntertainerID
JOIN 
    engagements b2 ON e.EntertainerID = b2.EntertainerID AND b2.StartDate < b1.EndDate AND b2.EndDate > b1.StartDate
JOIN 
    engagements b3 ON e.EntertainerID = b3.EntertainerID AND b3.StartDate < b2.EndDate AND b3.EndDate > b2.StartDate
GROUP BY 
    e.EntStageName
HAVING 
    COUNT(*) > 2;
    
-- Q9 List customers who have booked entertainers who play country or country rock or classical.

SELECT 
    DISTINCT c.CustFirstName, c.CustLastName
FROM 
    Customers c
JOIN 
    Engagements b ON c.CustomerID = b.CustomerID
JOIN 
    Entertainer_Styles e ON b.EntertainerID = e.EntertainerID
WHERE 
    e.StyleID = 6 OR  e.StyleID= 7 OR e.StyleID =11;

-- Q10 Show all entertainers and the number (count) of each entertainer’s engagement.

SELECT 
    e.EntStageName,
    COUNT(b.EntertainerID) AS num_of_engagements
FROM 
    entertainers e
LEFT JOIN 
    engagements b ON e.EntertainerID = b.EntertainerID
GROUP BY 
    e.EntStageName;

