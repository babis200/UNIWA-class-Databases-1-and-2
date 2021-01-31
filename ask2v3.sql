DROP DATABASE IF EXISTS InsuranceCovers;
CREATE DATABASE InsuranceCovers;

USE InsuranceCovers;

CREATE TABLE Covers (
    CoverID INT(2) NOT NULL,
    CoverName VARCHAR(50),
    CostPerYear FLOAT(4),
    MinDuration INT(2),
    PRIMARY KEY (CoverID)
);

CREATE TABLE Coverage (
    CoverageID INT(2) NOT NULL auto_increment,
    CoverageName VARCHAR(50),
    PRIMARY KEY (CoverageID)
);

CREATE TABLE Customers (
    CustomerID INT(2) NOT NULL,
    CustomerName VARCHAR(50),
    Address VARCHAR(50),
    PhoneNumber INT(10),
    AFM INT(2) UNIQUE,
    DOY VARCHAR(50),
    PRIMARY KEY (CustomerID)
);

CREATE TABLE Contracts (
    ContractID INT(2) NOT NULL,
    CoverID INT(2),
    StartDate DATE,
    EndDate DATE,
    Cost FLOAT(4 , 1 ),
    CustomerID INT(2) NOT NULL,
    PRIMARY KEY (ContractID),
    FOREIGN KEY (CoverID)
        REFERENCES Covers (CoverID),
    FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
);

INSERT INTO Customers VALUES
	(1,'Δημήτρης Χατζηστεφάνου','Ευελιπίδων 69',2104769852,180319944,'Α` Αθηνών'),
    (2,'Στέφανος Χατζηπαύλου','Λ. Βασιλίσσης Σοφίας 64',2105874963,241119935,'Δ` Αθηνών'),
    (3,'Παύλος Χατζηκώστας','Μιχαλακοπούλου 36',2106974851,140419917,'ΙΔ` Αθηνών'),
    (4,'Κωνσταντίνος Παπαδόπουλος','Υμηττού 46',2107256987,130619894,'ΙΓ` Αθηνών')
;
INSERT INTO Covers VALUES
	(1,'Ασφάλεια Υγείας',179.40,12),
    (2,'Σοβαρής Ασθένειας',319.10,12),
    (3,'Ασφάλεια Σπιτιού',187.62,24),
    (4,'Ασφάλεια Αυτοκινήτου',164.30,6)
;
INSERT INTO Contracts VALUES
	(1,2,'2020-06-15','2022-06-15',638.2,2),
    (2,1,'2018-12-01','2020-12-01',358.8,3),
    (3,4,'2019-03-09','2021-03-09',657.2,1),
    (4,1,'2020-11-14','2021-11-14',179.4,2),
    (5,3,'2019-09-27','2022-09-27',281.43,4)
;

INSERT INTO Coverage VALUES
    (1,'Ετήσιο check up, Ιατρικές Επισκέψεις'),
    (2,'Επίδομα ανάρρωσης, Καταβολή εξόδων νοσηλείας'),
    (3,'Πυρκαγιά, Κλοπή & ζημιές, Διάρρηξη σωληνώσεων'),
    (4,'ΚΤΕΟ, Ατύχημα,Ολική κλοπή')
;
SELECT * FROM Customers;
SELECT * FROM Covers;
SELECT * FROM Contracts;
SELECT * FROM Coverage;


-- 4.1 Μη ενημερώσιμη
CREATE VIEW Customers_contracts_view (e_name,e_enddate) AS SELECT CustomerName,MAX(EndDate) AS "Τέλος συμβολαίου"
FROM Customers
JOIN Contracts ON Customers.CustomerID = Contracts.CustomerID
GROUP BY Customers.CustomerID;

SELECT * FROM Customers_contracts_view;

-- Παράδειγμα
INSERT INTO Customers VALUES (5,'Παλαιολόγου Δημήτρης','Υμηττού 46',2107256987,140619894,'ΙΓ` Αθηνών');
INSERT INTO Customers_contracts_view (e_name,e_enddate) VALUES ('Δημητρακόπουλος Χρήστος','2001-03-09');

-- 4.2
CREATE VIEW Covers_view_update (e_coverName_up,e_minDuration_up) AS
SELECT CoverName,MinDuration FROM Covers;

-- Παράδειγμα
UPDATE Covers_view_update
SET  e_minDuration_up = 12
WHERE e_coverName_up = "Ασφάλεια Σπιτιού";

INSERT INTO Covers_view_update VALUES ("Τρομοκρατική επίθεση", 18);

SELECT * FROM Covers;
SELECT * FROM Covers_view_update;

-- 5.1
SELECT CoverID,COUNT(ContractID) AS "Πλήθος ανά ασφαλιστικό προιόν" FROM Contracts GROUP BY CoverID;

-- 5.2
SELECT Customers.CustomerName,SUM(cost) FROM Customers
JOIN Contracts ON Customers.CustomerID = Contracts.CustomerID GROUP BY Customers.CustomerID;


ALTER TABLE Contracts ADD cost_of_contracts (SELECT SUM(cost) FROM Customers
JOIN Contracts ON Customers.CustomerID = Contracts.CustomerID GROUP BY Customers.CustomerID);


-- 6
CREATE TABLE Customer(
    ecumst_id INT(2) NOT NULL,
    cust_name VARCHAR(50),
    e
);

CREATE TABLE Contract(
    ecumst_id INT(2) NOT NULL,
    con_name VARCHAR(50),
    cost_of_contracts )


CREATE TABLE Contract(
    ecumst_id INT(2) NOT NULL,
    cost_of_contracts FLOAT(4,1)
);

INSERT INTO Contract SELECT CustomerID,0 FROM Customers;



INSERT INTO Customer SELECT FROM Customers;
CREATE TABLE cost_of_contracts (
    CustomerID INT(2) NOT NULL,
    Cost_of_Contracts FLOAT
);

ALTER TABLE Contracts ADD (cost_of_contracts FLOAT (4,1) );

delimiter //
CREATE TRIGGER update_contracts
BEFORE UPDATE ON Contracts
FOR EACH ROW
BEGIN
SET NEW.cost_of_contracts = (
    SELECT SUM(old.Cost) FROM Contracts
    WHERE Contracts.CustomerID=Customers.CustomerID);
END;
//
delimiter ;

INSERT INTO contracts VALUE (5,2,'2020-06-15','2022-06-15',888.2,3);
UPDATE Contracts SET Cost = 123.21 WHERE Contract.ContractID =4;

CREATE TRIGGER cost_of_contracts_ins BEFORE INSERT
ON contracts
FOR EACH ROW
SET NEW.cost_of_contracts = (SELECT SUM(NEW.Cost)
FROM Contracts WHERE GROUP BY CustomerID );


BEGIN
SET New.cost_of_contracts = (
    SELECT SUM(New.Cost) FROM Contracts
    WHERE Contracts.ContractID=New.ContractID
	GROUP BY Contracts.CustomerID);


INSERT INTO contracts
(ContractID,CoverID,StartDate,EndDate,Cost,CustomerID) VALUE (6,2,'2020-06-15','2022-06-15',543.2,3);

-- 7
DROP FUNCTION IF EXISTS contract_duration
DELIMITER //
CREATE FUNCTION contract_duration(x DATE,y DATE)
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE f INT;
SET f= FLOOR(DATEDIFF(x,y)/30);
RETURN f;
END;
//
DELIMITER ;

SELECT contract_duration ('2022-09-27','2019-09-27')

-- 8
DELIMITER $$
CREATE PROCEDURE `cost_month`(IN `afm` INT, IN `return_date` DATE)
    DETERMINISTIC
BEGIN
	SET @custID =(SELECT CustomerID 
					FROM Customers
                    WHERE Customers.afm = afm);
	SET @cost_of_month = (SELECT SUM(Cost)
							FROM contracts
                            WHERE Contracts.CustomerID = @custID);
    SET @contracts = (SELECT COUNT(ContractID)
							FROM Contracts
                            WHERE Contracts.CustomerID = @custID);
     SELECT @cost_of_month AS "Συνολικό ποσό πληρωμής", @contracts AS "Πλήθος Συμβολαίων" ;                                        
END$$
DELIMITER ;


CALL cost_month(241119935, "2020-03-09");


-- 6
DROP TABLE IF EXISTS cost_of_contracts;
CREATE TABLE cost_of_contracts (CustID INT, CostOfContracts FLOAT);

INSERT INTO cost_of_contracts(CustID)  SELECT DISTINCT CustomerID FROM Contracts;

DROP TRIGGER IF EXISTS cost_of_contracts_trigg_ins ;
DROP TRIGGER IF EXISTS cost_of_contracts_trigg_upd ;

DELIMITER //
CREATE TRIGGER cost_of_contracts_trigg_ins
AFTER INSERT ON Contracts 
FOR EACH ROW
BEGIN 
UPDATE 	cost_of_contracts
   SET CostOfContracts = (SELECT SUM(Cost)
							FROM contracts
                            WHERE CustomerID = new.CustomerID)
                            WHERE CustID = new.CustomerID;
END;
//
CREATE TRIGGER cost_of_contracts_trigg_upd
AFTER UPDATE ON Contracts 
FOR EACH ROW
BEGIN 
UPDATE 	cost_of_contracts
   SET CostOfContracts = (SELECT SUM(Cost)
							FROM contracts
                            WHERE CustomerID = new.CustomerID)
                            WHERE CustID = new.CustomerID;
END;
//
DELIMITER ;

INSERT INTO contracts(ContractID,CoverID,StartDate,EndDate,Cost,CustomerID) VALUES (12, 2, '2022-09-27', '2019-09-27', 39.5,2);

SELECT SUM(Cost) FROM contracts WHERE CustomerID = 2 ;



