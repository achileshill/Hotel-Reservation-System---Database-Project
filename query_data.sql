use hotel;

-- QUERY 1
-- Write a query that returns a list of reservations that end in July 2023,
-- including the name of the guest, the room number(s), and the reservation dates.
select s3.FirstName, s3.LastName, s4.RoomNumber, s1.CheckInDate from hotel.reservation s1
join guestreservation s2 on s1.ReservationId = s2.ReservationId
join guest s3 on s2.GuestId = s3.GuestId
join roomreservation s4 on s1.ReservationId = s4.ReservationId
where extract(month from CheckOutDate) = 7;
-- Result (4 rows)
-- Eric         Riddle  205     2023-06-28
-- Bettyann     Seery   303     2023-07-28
-- Walter       Holaway 204     2023-07-13
-- Wilfred      Vise    401     2023-07-18

-- QUERY 2
-- Write a query that returns a list of all reservations for rooms with a jacuzzi,
-- displaying the guest's name, the room number, and the dates of the reservation.
select s3.FirstName, s3.LastName, s4.RoomNumber, s1.CheckInDate from hotel.reservation s1
join guestreservation s2 on s1.ReservationId = s2.ReservationId
join guest s3 on s2.GuestId = s3.GuestId
join roomreservation s4 on s1.ReservationId = s4.ReservationId
join hotel.room r on s4.RoomNumber = r.RoomNumber
where r.HasJacuzzi = 1;
-- Result (11 rows)
-- Karie,Yang,201,2023-03-06
-- Bettyann,Seery,203,2023-02-05
-- Karie,Yang,203,2023-09-13
-- Eric,Riddle,205,2023-06-28
-- Wilfred,Vise,207,2023-04-23
-- Walter,Holaway,301,2023-04-09
-- Mack,Simmer,301,2023-11-22
-- Bettyann,Seery,303,2023-07-28
-- Duane,Cullison,305,2023-02-22
-- Bettyann,Seery,305,2023-08-30
-- Eric,Riddle,307,2023-03-17

-- QUERY 3
-- Write a query that returns all the rooms reserved for a specific guest,
-- including the guest's name, the room(s) reserved, the starting date of the reservation,
-- and how many people were included in the reservation. (Choose a guest's name from the existing data.)
select s2.FirstName, s2.LastName, s5.RoomNumber, s4.CheckInDate, s4.Adults + s4.Children as Total_People from guestreservation s1
join guest s2 on s1.GuestId = s2.GuestId
join roomreservation s3 on s1.ReservationId = s3.ReservationId
join reservation s4 on s1.ReservationId = s4.ReservationId
join room s5 on s3.RoomNumber = s5.RoomNumber
where s2.GuestId = 2;
-- Result (4 rows)
-- Mack,Simmer,308,2023-02-02,1
-- Mack,Simmer,208,2023-09-16,2
-- Mack,Simmer,206,2023-11-22,2
-- Mack,Simmer,301,2023-11-22,4

-- QUERY 4
-- Write a query that returns a list of rooms, reservation ID, and per-room cost for each reservation.
-- The results should include all rooms, whether or not there is a reservation associated with the room.
select s3.RoomNumber, s1.ReservationId, s3.BasePrice + (s2.Children+s2.Adults)*s3.ExtraPerson as per_room_cost from roomreservation s1
join reservation s2 on s1.ReservationId = s2.ReservationId
right outer join room s3 on s1.RoomNumber = s3.RoomNumber
order by s3.RoomNumber;
-- Result (27 rows)
/*
RoomNumber, ReservationId, Per-roomCost
201,4,239.99
202,7,214.99
203,2,229.99
203,21,239.99
204,16,214.99
205,15,174.99
206,12,149.99
206,23,149.99
207,10,174.99
208,13,149.99
208,20,149.99
301,9,209.99
301,24,239.99
302,6,204.99
302,25,194.99
303,18,229.99
304,8,194.99
304,14,204.99
305,3,174.99
305,19,174.99
306,,
307,5,174.99
308,1,149.99
401,11,519.99
401,17,519.99
401,22,479.99
402,,*/

-- QUERY 5
-- Write a query that returns all the rooms accommodating at least
-- three guests and that are reserved on any date in April 2023.
select s3.RoomNumber from reservation s1
join roomreservation s2 on s1.ReservationId=s2.ReservationId
join room s3 on s2.RoomNumber=s3.RoomNumber
where extract(month from s1.CheckInDate) = 4
-- and extract(month from s1.CheckOutDate) = 4
and s1.Children + s1.Adults >= 3;
-- No rows returned

-- QUERY 6
-- Write a query that returns a list of all guest names and the number of reservations per guest,
-- sorted starting with the guest with the most reservations and then by the guest's last name.
select s2.FirstName, s2.LastName, count(*) as num_reservation from guestreservation s1
join guest s2 on s1.GuestId = s2.GuestId
group by s2.FirstName, s2.LastName
order by num_reservation DESC, s2.LastName ASC;
-- Result (12 rows)
/* Mack,Simmer,4
Bettyann,Seery,3
Duane,Cullison,2
Walter,Holaway,2
Aurore,Lipton,2
Eric,Riddle,2
Maritza,Tilton,2
Joleen,Tison,2
Wilfred,Vise,2
Karie,Yang,2
Zachery,Luechtefield,1
Jeremiah,Pendergrass,1
 */

-- QUERY 7
-- Write a query that displays the name, address, and phone number of a guest
-- based on their phone number. (Choose a phone number from the existing data.)
select FirstName, LastName,City, State, Zip, Phone from guest
where Phone like '%50%'
-- Result (2 rows)
/*
Mack,Simmer,Council Bluffs,IA,51501,(291) 553-0508
Aurore,Lipton,Saginaw,MI,48601,(377) 507-0974
*/
