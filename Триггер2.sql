/* Триггер 2: если у прививки истек срок действия, необходимо внести ее в таблицу стационарное лечение */


CREATE OR REPLACE FUNCTION vaccine_expiration_handler()
RETURNS TRIGGER AS $$
DECLARE
    new_service_id integer;
    new_bill_id integer;
    new_bill_number integer;
    new_pet_to_vaccination_id integer;
    new_inpatient_treatment_id integer;
    new_service_to_inpatient_treatment_id integer;
	bill_to_service_id integer;
BEGIN
    IF NEW.expiration_date <= CURRENT_DATE THEN
        INSERT INTO vaccination (vaccination_name, date_, expiration_date, vaccination_type)
        VALUES (NEW.vaccination_name, CURRENT_DATE, NEW.expiration_date + 365, NEW.vaccination_type)
        RETURNING vaccination_id INTO NEW.vaccination_id;

        INSERT INTO service (name_, cost_, binding_to_cabinet, date_)
        VALUES (NEW.vaccination_name, 1000.0, true, CURRENT_DATE)
        RETURNING service_id INTO new_service_id;

        SELECT INTO new_bill_number floor(random() * 1000000) + 1;

        WHILE EXISTS (SELECT 1 FROM bill WHERE number_ = new_bill_number) LOOP
            SELECT INTO new_bill_number floor(random() * 1000000) + 1;
        END LOOP;

        INSERT INTO bill (number_, cost_, payment_mark)
        VALUES (new_bill_number, 1000.0, 'without a refund')
        RETURNING bill_id INTO new_bill_id;

        INSERT INTO bill_to_service (bill_id, service_id)
        VALUES (new_bill_id, new_service_id)
		RETURNING id_ INTO bill_to_service_id;
		
		INSERT INTO pet_to_vaccination (pet_id, vaccination_id)
                    SELECT p.pet_id, NEW.vaccination_id
                    FROM pet p
                    JOIN pet_to_vaccination ptv ON p.pet_id = ptv.pet_id
                    WHERE ptv.vaccination_id = OLD.vaccination_id
		RETURNING id_ INTO new_pet_to_vaccination_id;

        INSERT INTO inpatient_treatment (effectiveness, date_)
        VALUES (true, CURRENT_DATE)
        RETURNING inpatient_treatment_id INTO new_inpatient_treatment_id;

        INSERT INTO service_to_inpatient_treatment (service_id, inpatient_treatment_id)
        VALUES (new_service_id, new_inpatient_treatment_id)
        RETURNING id_ INTO new_service_to_inpatient_treatment_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER vaccine_expiration_trigger
AFTER INSERT OR UPDATE OF expiration_date ON vaccination
FOR EACH ROW
EXECUTE PROCEDURE vaccine_expiration_handler();