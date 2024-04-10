
-- 1. Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetPals”
CREATE SCHEMA IF NOT EXISTS `Pet_Pals` DEFAULT CHARACTER SET utf8 ;
USE `Pet_Pals` ;

-- 2. Create tables for pets, shelters, donations, adoption events, and participants
-- 3. Define appropriate primary keys, foreign keys, and constraints
-- 4. Ensure the script handles potential errors, such as if the database or tables already exist.

CREATE TABLE IF NOT EXISTS `Pet_Pals`.`Pets` (
  `PetID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NULL,
  `Age` INT NULL,
  `Breed` VARCHAR(255) NULL,
  `Type` VARCHAR(255) NULL,
  `AvailableForAdoption` BIT NULL,
  PRIMARY KEY (`PetID`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Pet_Pals`.`Donations` (
  `DonationID` INT NOT NULL AUTO_INCREMENT,
  `DonorName` VARCHAR(255) NULL,
  `DonationType` VARCHAR(255) NULL,
  `DonationAmount` VARCHAR(255) NULL,
  `DonationItem` VARCHAR(255) NULL,
  `DonationDate` DATE NULL,
  PRIMARY KEY (`DonationID`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Pet_Pals`.`Shelters` (
  `ShelterID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NULL,
  `Location` VARCHAR(255) NULL,
  `PetID` INT NULL,
  `DonationID` INT NULL,
  PRIMARY KEY (`ShelterID`),
  INDEX `fk_Shelters_Pets1_idx` (`PetID` ASC) ,
  INDEX `fk_Shelters_Donations1_idx` (`DonationID` ASC) ,
  CONSTRAINT `fk_Shelters_Pets1`
    FOREIGN KEY (`PetID`)
    REFERENCES `Pet_Pals`.`Pets` (`PetID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Shelters_Donations1`
    FOREIGN KEY (`DonationID`)
    REFERENCES `Pet_Pals`.`Donations` (`DonationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Pet_Pals`.`AdoptionEvents` (
  `EventID` INT NOT NULL AUTO_INCREMENT,
  `EventName` VARCHAR(255) NULL,
  `EventDate` VARCHAR(255) NULL,
  `Location` VARCHAR(255) NULL,
  `PetID` INT NULL,
  PRIMARY KEY (`EventID`),
  INDEX `fk_AdoptionEvents_Pets_idx` (`PetID` ASC) ,
  CONSTRAINT `fk_AdoptionEvents_Pets`
    FOREIGN KEY (`PetID`)
    REFERENCES `Pet_Pals`.`Pets` (`PetID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Pet_Pals`.`Participants` (
  `ParticipantID` INT NOT NULL AUTO_INCREMENT,
  `ParticipantName` VARCHAR(255) NULL,
  `ParticipantType` VARCHAR(255) NULL,
  `EventID` INT NULL,
  PRIMARY KEY (`ParticipantID`),
  INDEX `fk_Participants_AdoptionEvents1_idx` (`EventID` ASC) ,
  CONSTRAINT `fk_Participants_AdoptionEvents1`
    FOREIGN KEY (`EventID`)
    REFERENCES `Pet_Pals`.`AdoptionEvents` (`EventID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


use Pet_Pals;
describe Participants;


insert into AdoptionEvents(EventName,EventDate,Location)
values
('Pet Friends','2024-04-14','GandhiGround'),
('Pet Camp','2024-03-28','BHEL Ground'),
('Companion Pet','2024-05-02','New Market');

insert into Participants(ParticipantName,ParticipantType,EventID)
values 
('John Wick','Adopter',2),
('Bruce Wayne','Adopter',3),
('Wade Wilson','Shelter',1),
('Chris Hemsworth','Adopter',2),
('Bruce Banner','Shelter',3);

insert into Pets(Name,Age,Breed,Type,AvailableForAdoption,EventID)
values
('Tuffy',2,'Labrador','Dog',1,1),
('Boni',3,'Persian','Cat',1,1),
('Chopper',1,'Hamster','Mouse',1,2),
('Chichi',2,'White','Pegion',0,2),
('Bruno',5,'Doberman','Dog',0,3);


insert into Donations(DonorName,DonationType,DonationAmount,DonationItem)
values 
('Tony Stark','Cash',20000,NULL,'2024-04-14'),
('Steve Rogers','Item',NULL,'Pet collar','2024-04-03'),
('Nick Fury','Cash and Item',10000,'Pet Food','2024-04-10'),
('Pepper Potts','Cash and Item',35000,'Pet Wash','2024-04-01'),
('Gwen Stacy','Cash',10000,NULL,'2024-04-09');

insert into Shelters(Name,Location,PetID,DonationID)
values 
('Pets World','Mumbai',2,1),
('Pet Pal','Chennai',1,4),
('Richie Pet','Pune',3,3),
('Daisy Pets','Bhopal',2,2),
('Pet Land','Chennai',2,5);


/*Write an SQL query that retrieves a list of available pets (those marked as available for adoption)
from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure that
the query filters out pets that are not available for adoption.*/
select Name,Age,Breed,Type
from Pets
where AvailableForAdoption = 1;
/*Tuffy	2	Labrador	Dog
Boni	3	Persian	Cat
Chopper	1	Hamster	Mouse*/ 


/*6. Write an SQL query that retrieves the names of participants (shelters and adopters) registered
for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query
joins the necessary tables to retrieve the participant names and types.*/
select ParticipantName,ParticipantType
from Participants p
join AdoptionEvents ae on p.EventID = ae.EventID
where ae.EventID = 3;
/*Bruce Wayne	Adopter
Bruce Banner	Shelter*/


/*7. Create a stored procedure in SQL that allows a shelter to update its information (name and
location) in the "Shelters" table. Use parameters to pass the shelter ID and the new information.
Ensure that the procedure performs the update and handles potential errors, such as an invalid
shelter ID*/
update Shelters set PetID = 3 where ShelterID = 2;

/*8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by
shelter name) from the "Donations" table. The result should include the shelter name and the
total donation amount. Ensure that the query handles cases where a shelter has received no
donations.*/
select s.Name, SUM(d.DonationAmount) as 'Donation_Amount'
from Donations d
join Shelters s on s.DonationID = d.DonationID
group by s.ShelterID;
/*Pets World	20000
Pet Pal	35000
Richie Pet	10000
Daisy Pets	NULL
Pet Land	10000*/

/*9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an
owner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the result
set.

Owner Column not specified

*/

/*10. Write an SQL query that retrieves the total donation amount for each month and year (e.g.,
January 2023) from the "Donations" table. The result should include the month-year and the
corresponding total donation amount. Ensure that the query handles cases where no donations
were made in a specific month-year.
*/
select month(DonationDate),year(DonationDate),sum(DonationAmount)
from Donations
group by month(DonationDate);
/*4	2024	75000*/

-- 11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years
select distinct Breed
from Pets
where (Age between 1 and 3) or (age > 5);
/*Labrador
Persian
Hamster
White*/

-- 12. Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.
select p.Name,s.Name
from Pets p
join Shelters s on s.PetID = p.PetID;
/*
Boni	Pets World
Chopper	Pet Pal
Chopper	Richie Pet
Boni	Daisy Pets
Boni	Pet Land
*/

-- 13. Find the total number of participants in events organized by shelters located in specific city. Example: City=Chennai
select ae.EventName,count(*) as 'Total_Participants'
from Participants p
join AdoptionEvents ae on p.EventID = ae.EventID
where ae.Location = 'BHEL Ground';
/*Pet Camp	2*/

-- 14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
select Breed,count(*) as 'Uniqueness'
from Pets
where Age between 1 and 5;

-- 15. Find the pets that have not been adopted by selecting their information from the 'Pet' table.
select *
from Pets
where AvailableForAdoption = 1;
/*1	Tuffy	2	Labrador	Dog	1	1
2	Boni	3	Persian	Cat	1	1
3	Chopper	1	Hamster	Mouse	1	2
						*/

-- 16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.
select Name 
from Pets 
where AvailableForAdoption = 0;
/*Chichi
Bruno*/

-- 17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter.
select s.*,count(p.Name) as 'pet_Count'
from Shelters s 
join Pets p on s.PetID = p.PetID
where p.AvailableForAdoption = 1
group by s.Name;
/*Daisy Pets	Bhopal	2	2	1
Pet Land	Chennai	2	5	1
Pet Pal	Chennai	3	4	1
Pets World	Mumbai	2	1	1
Richie Pet	Pune	3	3	1*/

-- 18. Find pairs of pets from the same shelter that have the same breed.


-- 19. List all possible combinations of shelters and adoption events.

-- 20. Determine the shelter that has the highest number of adopted pets.
select s.Name, count(*) as 'Count_Of_Pets'
from Shelters s
join Pets p on s.PetID = p.PetID
where p.AvailableForAdoption = 0
order by Count_of_Pets desc;
/*NULL*/






