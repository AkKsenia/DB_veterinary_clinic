create table if not exists pet (
	pet_id serial primary key,
	sex varchar(6) check (sex in ('male', 'female')) not null,
	age interval not null,
	registration_date date not null,
	species varchar(30) not null, 
    nickname varchar(20) not null, 
	weight decimal not null, 
	condition_ varchar(5) check (condition_ in ('dead', 'alive')) not null, 
	height decimal not null
);

create table if not exists vaccination (
	vaccination_id serial primary key,
	vaccination_name varchar(30) not null,
	date_ date not null,
	expiration_date date not null,
	vaccination_type varchar(30) not null
);

create table if not exists pet_to_vaccination (
	id_ serial primary key,
	pet_id integer null references pet(pet_id) on delete cascade,
	vaccination_id integer null references vaccination(vaccination_id) on delete cascade
);

create table if not exists doctor (
	doctor_id serial primary key, 
	specialization varchar(30) not null, 
	work_phone_number varchar(25) not null, 
	passport_data varchar(40) not null, 
	education_information varchar(70) not null, 
	full_name varchar(50) not null
);

create table if not exists appointment (
	appointment_id serial primary key, 
	date_ date not null, 
	time_ time not null,
	urgency varchar(10) check (urgency in ('urgent', 'not urgent')) not null,
	the_need_to_transfer_clinic_fault boolean not null, 
	the_need_to_transfer_owner_fault boolean not null
);

create table if not exists doctor_to_appointment (
	id_ serial primary key,
	doctor_id integer references doctor(doctor_id) on delete cascade,
	appointment_id integer references appointment(appointment_id) on delete cascade
);

create table if not exists pet_to_appointment (
	id_ serial primary key,
	pet_id integer references pet(pet_id) on delete cascade,
	appointment_id integer references appointment(appointment_id) on delete cascade
);

create table if not exists service (
	service_id serial primary key, 
	name_ varchar(40) not null, 
	cost_ decimal not null, 
	binding_to_cabinet boolean not null,
	date_ date not null
);

create table if not exists service_to_appointment (
	id_ serial primary key,
	service_id integer references service(service_id) on delete cascade,
	appointment_id integer null references appointment(appointment_id) on delete cascade
);

create table if not exists bill (
	bill_id serial primary key,
	number_ integer not null,
	cost_ decimal not null,
	payment_mark varchar(20) check (payment_mark in ('with a refund', 'without a refund')) not null
);

create table if not exists bill_to_service (
	id_ serial primary key,
	bill_id integer references bill(bill_id) on delete cascade,
	service_id integer references service(service_id) on delete cascade
);

create table if not exists room (
	room_id serial primary key,
	number_ integer not null, 
	level_ integer not null
);

create table if not exists doctor_to_room (
	id_ serial primary key,
	doctor_id integer null references doctor(doctor_id) on delete cascade,
	room_id integer null references room(room_id) on delete cascade
);

create table if not exists service_to_room (
	id_ serial primary key,
	service_id integer references service(service_id) on delete cascade,
	room_id integer null references room(room_id) on delete cascade
);

create table if not exists health_indicator (
	health_indicator_id serial primary key, 
	name_ varchar(25) not null, 
	units_of_measurement varchar(25) not null,
	minimum decimal not null, 
	maximum decimal not null
);

create table if not exists pet_to_health_indicator (
	id_ serial primary key,
	pet_id integer references pet(pet_id) on delete cascade,
	health_indicator_id integer references health_indicator(health_indicator_id) on delete cascade
);

create table if not exists observation (
	observation_id serial primary key, 
	diagnosis varchar(40) not null, 
	date_ date not null, 
	time_ time not null, 
	indicator_value decimal not null
);

create table if not exists pet_to_observation (
	id_ serial primary key,
	pet_id integer references pet(pet_id) on delete cascade,
	observation_id integer null references observation(observation_id) on delete cascade
);

create table if not exists observation_to_health_indicator (
	id_ serial primary key,
	observation_id integer null references observation(observation_id) on delete cascade,
	health_indicator_id integer references health_indicator(health_indicator_id) on delete cascade
);

create table if not exists inpatient_treatment (
	inpatient_treatment_id serial primary key,
	effectiveness boolean not null,
	date_ date not null
);

create table if not exists observation_to_inpatient_treatment (
	id_ serial primary key,
	observation_id integer null references observation(observation_id) on delete cascade,
	inpatient_treatment_id integer null references inpatient_treatment(inpatient_treatment_id) on delete cascade
);

create table if not exists service_to_inpatient_treatment (
	id_ serial primary key,
	service_id integer references service(service_id) on delete cascade,
	inpatient_treatment_id integer null references inpatient_treatment(inpatient_treatment_id) on delete cascade
);

create table if not exists outpatient_treatment (
	outpatient_treatment_id serial primary key,
	name_of_drug varchar(20) not null,
	date_ date not null,
	duration_of_administration interval not null,
	dosage varchar(15) not null
);

create table if not exists observation_to_outpatient_treatment (
	id_ serial primary key,
	observation_id integer references observation(observation_id) on delete cascade,
	outpatient_treatment_id integer null references outpatient_treatment(outpatient_treatment_id) on delete cascade
);