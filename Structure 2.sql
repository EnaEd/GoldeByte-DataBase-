use master
go
Create Database Infrastructure
go
use Infrastructure
go
--Названия областей
Create Table Region
(
	Id bigint primary key identity NOT NULL,
	RegionName nvarchar(30) NOT NULL
)
go
--Названия населённых пунктов
Create Table Locality
(
	Id bigint primary key identity NOT NULL,
	IdRegion bigint foreign key references Region(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	TownName nvarchar(30) NOT NULL
)
go
--Названия районов
Create Table District
(
	Id bigint primary key identity NOT NULL,
	IdLocality bigint foreign key references Locality(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	DistrictName nvarchar(100) NOT NULL
)
go
--Улицы входящие в состав Районов и Городов

Create Table Street
(
	Id bigint primary key identity NOT NULL,
	IdLocality bigint foreign key references Locality(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	IdDistrict bigint foreign key references District(Id), 
	StreetName nvarchar(30) NOT NULL
)
go
--*********
--Добавить Номер дома
--Create Table Build
--(
--	Id bigint primary key identity NOT NULL,
--	IdStreet bigint FOREIGN KEY REFERENCES Street(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
--	BuildNumb int NOT NULL CHECK(BuildNumb > 0)
--)
--*********
--Квартира
--Добавить ссылку на Дом
Create Table Flat
(
	Id bigint primary key identity NOT NULL,
	--IDBuildNumb bigint foreign key references Build(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	IDStreet bigint foreign key references Street(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	--Ограничения можно кидать на положительные номера
	FlatNumber int NOT NULL--CHECK(BuildNumb > 0)
)
go
--Данные Людей
Create Table People
(
	Id bigint primary key identity NOT NULL,
	Surname nvarchar(50) NOT NULL,
	FirstName nvarchar(50) NOT NULL,
	MiddleName nvarchar(50) NOT NULL,
	Birthday date NOT NULL,		
	Gender nvarchar(8) NOT NULL,
	PassportID nvarchar(8) NOT NULL,
	INN numeric NOT NULL,
	IDStreet bigint foreign key references Street(Id),
	IDFlat bigint foreign key references Flat(Id),
	PhoneNumber nvarchar(13),
	Photo varbinary(MAX)
)
go
--Названия Учреждений
Create Table Institutions
(
	Id bigint primary key identity NOT NULL,
	--Адресс не атомарен)))
	--Разбивать на улицу, дом
	InstitutionsAdress bigint foreign key references Street(Id) NOT NULL,
	InstitutionsName nvarchar(100) NOT NULL
)
go
--Отделения учреждения
Create Table InstitutionDepartments
(
	Id bigint primary key identity NOT NULL,
	IDInstitutions bigint foreign key references Institutions(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	DepartmentsName nvarchar(50) NOT NULL	
)
go
--Обслуживаемые учреждением участки
--************************
--учереждение обслуживает район
--участки врач
--************************
Create Table Area
(
	Id bigint primary key identity NOT NULL,
	IDInstitutions bigint foreign key references Institutions(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	AreaNumber int NOT NULL,
	IDStreet bigint foreign key references Street(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
) 
go
--Таблица связывающая людей с должностями и учреждением
Create Table Staff
(
	Id bigint primary key identity NOT NULL,
	IDPeople bigint foreign key references People(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	IDInstitutions bigint foreign key references Institutions(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	IDInstitutionDepartments bigint foreign key references InstitutionDepartments(Id) NOT NULL,
	--************
	--Не понял почта чья?
	--************
	Post nvarchar(30) NOT NULL,	
	UserPassword varbinary(max)
)
--go
----Обслуживаемый врачём участки
--Create Table EmployeeSites
--(
--	Id bigint primary key identity NOT NULL,
--	IDStaff bigint foreign key references Staff(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
--	IDArea bigint foreign key references Area(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
--)
go
--Карточка пациента
Create Table PatientsCard
(
	Id bigint primary key identity NOT NULL,
	IDPeople bigint foreign key references People(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	BloodGroup nvarchar (10) NOT NULL,
	RhesusFactor nvarchar(10) NOT NULL,
	MansHeight float(4) NOT NULL,
	MansWeight float(4) NOT NULL,
	Notes text
	--Добавить анализиы???
)
go
--Клиенты врачей
Create Table DoctorsClients
(
	Id bigint primary key identity NOT NULL,
	IDPeople bigint foreign key references People(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	IDStaff bigint foreign key references Staff(Id),
	IDPatientsCard bigint foreign key references PatientsCard(Id)
)
go
--Карты льготного населения
Create Table UserAccessCards
(
	Id bigint primary key identity NOT NULL,
	IDPeople bigint foreign key references People(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	IdentificationСode bigint unique NOT NULL
)
go
--Документирование использования карты льготника
Create Table RegistrationVisits
(
	Id bigint primary key identity NOT NULL,
	IDPeople bigint foreign key references People(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	Times datetime NOT NULL
)
go
--Документирование входа и выхода персаонала в систему
--?????Избыточно???
Create Table AccessStaffRecord
(
	Id bigint primary key identity NOT NULL,
	IDStaff bigint foreign key references Staff(Id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	Times datetime NOT NULL
)

go
Insert Into Region(RegionName)
Values (N'Автономная Республика Крым'),
(N'Винницкая'),
(N'Волынская'),
(N'Днепропетровская'),
(N'Донецкая'),
(N'Житомирская'),
(N'Закарпатская'),
(N'Запорожская'),
(N'Ивано-Франковская'),
(N'Киевская'),
(N'Кировоградская'),
(N'Луганская'),
(N'Львовская'),
(N'Николаевская'),
(N'Одесская'),
(N'Полтавская'),
(N'Ровенская'),
(N'Сумская'),
(N'Тернопольская'),
(N'Харьковская'),
(N'Херсонская'),
(N'Хмельницкая'),
(N'Черкасская'),
(N'Черниговская'),
(N'Черновицкая')

go
Insert Into Locality(IdRegion, TownName)
Values(20, N'Харьков'),
(8, N'Запорожье'),
(7, N'Уж'),
(7, N'смт. Мирное'),
(7, N'смт. Солнечный')

go 
Insert Into District(IdLocality, DistrictName)
Values (1, N'Шевченковский'),
(1, N'Киевский'),
(1, N'Слободской'),
(1, N'Основянский'),
(1, N'Холодногорский'),
(1, N'Московский'),
(1, N'Новобаварский'),
(1, N'Индустриальный'),
(1, N'Немышлянский'),
(2, N'Александровский'),
(2, N'Вознесеновский'),
(2, N'Днепровский'),
(2, N'Заводский'),
(2, N'Коммунарский'),
(2, N'Хортицкий'),
(2, N'Шевченковский')

go
Insert Into Street(IdLocality, IdDistrict, StreetName)
Values (1, 6, N'ул.Тракторостроителей 160'),
(1, 6, N'ул.Тракторостроителей 161'),
(1, 6, N'ул.Тракторостроителей 162'),
(1, 6, N'ул.Боровина 100'),
(1, 6, N'ул.Боровина 101'),
(1, 6, N'ул.Боровина 102'),
(1, 6, N'ул.Героев Труда 80'),
(1, 6, N'ул.Героев Труда 81'),
(1, 6, N'ул.Героев Труда 82'),
(1, 6, N'ул.Тракторостроителей 105'),
(1, 6, N'ул.Тракторостроителей 106'),
(1, 6, N'ул.Тракторостроителей 107'),
(1, 6, N'ул.Тракторостроителей 108'),
(1, 6, N'ул.Тракторостроителей 109'),
(1, 6, N'ул.Тракторостроителей 110'),
(2, 11, N'ул.Щукова 5'),
(2, 11, N'ул.Щукова 6'),
(2, 11, N'ул.Щукова 7'),
(2, 11, N'ул.Ильина 10'),
(2, 11, N'ул.Ильина 11'),
(2, 11, N'ул.Ильина 12'),
(2, 11, N'ул.Коммунаров 35'),
(2, 11, N'ул.Коммунаров 36'),
(2, 11, N'ул.Коммунаров 37'),
(3, NULL, N'ул. Заречная 22'),
(3, NULL, N'ул. Заречная 23'),
(4, NULL, N'ул. Миргородская 15'),
(4, NULL, N'ул. Миргородская 16'),
(5, NULL, N'ул.Заводская 21'),
(5, NULL, N'ул.Заводская 23')

go
Insert Into Flat(IDStreet, FlatNumber)
Values(15, 35),
(22, 5),
(1, 100)


go
Insert Into People(Surname,	FirstName, MiddleName, Birthday, Gender, PassportID, INN, IDStreet, IDFlat, PhoneNumber)
Values (N'Семёнов', N'Семён', N'Ильич', N'1967-05-12', N'Мужской', N'ВК123456', 4598264755, 15, 1, N'380551234567'),
(N'Семакин', N'Михаил', N'Андреевич', N'1958-12-01', N'Мужской', N'МИ789012', 6534231256, 22, 2, N'380635552217'),
(N'Петров', N'Николай', N'Семёнович', N'1942-10-10', N'Мужской', N'ВС456789', 9878572287, 1, 3, N'380934565656'),
(N'Семёнова', N'Лариса', N'Ивановна', N'1970-07-07', N'Женский', N'ВК654456', 9867343422, 15, 1, N'380556789856'),
(N'Пирогова', N'Анна', N'Семёновна', N'1987-07-07', N'Женский', N'ВМ987654', 5654545435, 25, NULL, N'380994554456')

go
Insert Into Institutions(InstitutionsAdress, InstitutionsName)
Values (10, N'11 Поликлиника'),
(19, N'5 Поликлиника'),
(26, N'1 Поликлиника')

go
Insert Into InstitutionDepartments(IDInstitutions, DepartmentsName)
Values (1, N'Терапевтическое отделение 1'),
 (1, N'Терапевтическое отделение 2'),
 (1, N'Терапевтическое отделение 3'),
 (1, N'Неврологическое отделение'),
 (1, N'Рентгенологическое отделение'),
 (1, N'Отеделение Профилактики'),
 (2, N'Терапевтическое отделение'),
 (2, N'Неврологическое отделение'),
 (2, N'Рентгенологическое отделение'),
 (2, N'Отеделение Профилактики'),
 (3, N'Терапевтическое отделение'),
 (3, N'Неврологическое отделение'),
 (3, N'Рентгенологическое отделение')

 go
 Insert Into Area(IDInstitutions, AreaNumber, IDStreet)
 Values(1, 1, 1),
 (1, 1, 2),
 (1, 1, 3),
 (1, 1, 4),
 (1, 1, 5),
 (1, 2, 6),
 (1, 2, 7),
 (1, 2, 8),
 (1, 3, 9),
 (1, 3, 10),
 (1, 3, 11),
 (1, 3, 12),
 (1, 4, 13),
 (1, 4, 14),
 (1, 4, 15),
 (2, 1, 16),
 (2, 1, 17),
 (2, 1, 18),
 (2, 2, 19),
 (2, 2, 20),
 (2, 2, 21),
 (2, 3, 22),
 (2, 3, 23),
 (2, 3, 24),
 (3, 1, 25),
 (3, 1, 26),
 (3, 2, 27),
 (3, 2, 28),
 (3, 3, 29),
 (3, 3, 30)
 
 go
 DECLARE @HashThis1 varbinary(max) = CONVERT(varbinary,'12345'); 
 DECLARE @HashThis2 varbinary(max) = CONVERT(varbinary,'0000'); 
 Insert Into Staff(IDPeople, IDInstitutions, IDInstitutionDepartments, Post, UserPassword)
 Values (4, 1, 1, N'Терапевт', HashBytes('SHA1', @HashThis1)),
 (5, 3, 11, N'Терапевт', HashBytes('SHA1', @HashThis2))

 --go
 --Insert Into EmployeeSites(IDStaff, IDArea)
 --Values (1, 1),
 --(1, 2),
 --(1, 3),
 --(1, 4),
 --(1, 5),
 --(2, 25),
 --(2, 26)

 go
 Insert Into PatientsCard(IDPeople, BloodGroup, RhesusFactor, MansHeight, MansWeight, Notes)
 Values (1, N'A(II)', N'Rh−', 187, 71.5, N'Выраженная гиперчувствительность к препаратам симпатолитической группы'),
 (2, N'A(II)', N'Rh+', 165, 60, N'Отклонений от норм не выявлено'),
 (3, N'B(III) ', N'Rh+', 190, 90, N'Выявлена аллергическая реакция на препарат Аскорутин'),
 (4, N'A(II)', N'Rh+', 173, 65.7, N'Отклонений от норм не выявлено'),
 (5, N'O(I)', N'Rh+', 170, 60.5, N'Отклонений от норм не выявлено')

 go
 Insert Into DoctorsClients(IDPeople, IDStaff, IDPatientsCard)
 Values (1, 1, 1)

 go
 Insert Into UserAccessCards(IDPeople, IdentificationСode)
 Values (1, 17616414827155)
