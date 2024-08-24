/* Триггер 1: если необходимость переноса по вине клинике = true, 
срабатывает триггер, который создает запись на следующий прием */


CREATE OR REPLACE FUNCTION create_next_appointment()
RETURNS TRIGGER AS $$
DECLARE
    new_appointment_id integer;
    next_appointment_time time;
	next_appointment_date date;
	
	tmp integer;
BEGIN
    IF NEW.the_need_to_transfer_clinic_fault THEN
        next_appointment_time := NEW.time_ + INTERVAL '1 hour';
		next_appointment_date := NEW.date_;
		
		tmp = NEW.appointment_id;

        LOOP
            IF NOT EXISTS (
                SELECT 1
                FROM appointment
                WHERE date_ = next_appointment_date
                AND time_ = next_appointment_time
                AND time_ < '22:00:00' -- время закрытия клиники
            ) THEN
			
                INSERT INTO appointment (date_, time_, urgency, the_need_to_transfer_clinic_fault, the_need_to_transfer_owner_fault)
                VALUES (next_appointment_date, next_appointment_time, NEW.urgency, false, NEW.the_need_to_transfer_owner_fault)
                RETURNING appointment_id INTO new_appointment_id;

                -- обновляем связанные таблицы
                UPDATE doctor_to_appointment
                SET appointment_id = new_appointment_id
                WHERE appointment_id = tmp;

				UPDATE pet_to_appointment 
                SET appointment_id = new_appointment_id
                WHERE appointment_id = tmp;
				
				UPDATE service_to_appointment
                SET appointment_id = new_appointment_id
                WHERE appointment_id = tmp;

                EXIT; -- выходим из цикла, если свободное окно найдено
            END IF;

            next_appointment_time := next_appointment_time + INTERVAL '1 hour';

            IF next_appointment_time >= '22:00:00' THEN
                next_appointment_date := next_appointment_date + 1;
				next_appointment_time := '08:30:00';
            END IF;
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_next_appointment_trigger
AFTER INSERT ON appointment
FOR EACH ROW
EXECUTE FUNCTION create_next_appointment();