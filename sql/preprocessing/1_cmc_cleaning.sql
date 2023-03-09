-- prepare codes in cmc_adult_zero_std (largest table)
ALTER TABLE cmc_adult_zero_std ADD vocabulary_id VARCHAR(50);

UPDATE cmc_adult_zero_std 
SET vocabulary_id = LEFT(code, INSTR(code, ' ') - 1);

UPDATE cmc_adult_zero_std 
SET code = REPLACE(REPLACE(code, 'CPT ', ''), 'HCPCS ', '');

UPDATE cmc_adult_zero_std
SET code = NULLIF(code, 'n/a'), 
    vocabulary_id = NULLIF(vocabulary_id, 'n/a'), 
    ip_gross_charge = NULLIF(ip_gross_charge, ''), 
    ip_negotiated_charge = NULLIF(ip_negotiated_charge, ''), 
    op_gross_charge = NULLIF(op_gross_charge, ''), 
    op_negotiated_charge = NULLIF(op_negotiated_charge, ''),
	ip_gross_charge = NULLIF(ip_gross_charge, ' n/a '), 
    ip_negotiated_charge = NULLIF(ip_negotiated_charge, ' n/a '), 
    op_gross_charge = NULLIF(op_gross_charge, ' n/a '), 
    op_negotiated_charge = NULLIF(op_negotiated_charge, ' n/a ');
   
-- prepare codes in cmc_adult_one_std
ALTER TABLE cmc_adult_one_std ADD vocabulary_id VARCHAR(50);

UPDATE cmc_adult_one_std 
SET vocabulary_id = LEFT(code, INSTR(code, ' ') - 1);

UPDATE cmc_adult_one_std 
SET code = REPLACE(REPLACE(code, 'CPT ', ''), 'HCPCS ', '');

UPDATE cmc_adult_one_std
SET code = NULLIF(code, 'n/a'), 
    vocabulary_id = NULLIF(vocabulary_id, 'n/a'), 
    ip_gross_charge = NULLIF(ip_gross_charge, ''), 
    ip_negotiated_charge = NULLIF(ip_negotiated_charge, ''), 
    op_gross_charge = NULLIF(op_gross_charge, ''), 
    op_negotiated_charge = NULLIF(op_negotiated_charge, ''),
    ip_gross_charge = NULLIF(ip_gross_charge, ' n/a '), 
    ip_negotiated_charge = NULLIF(ip_negotiated_charge, ' n/a '), 
    op_gross_charge = NULLIF(op_gross_charge, ' n/a '), 
    op_negotiated_charge = NULLIF(op_negotiated_charge, ' n/a ');
    
-- prepare codes in cmc_cash_prices 
ALTER TABLE cmc_cash_prices ADD vocabulary_id VARCHAR(50);

UPDATE cmc_cash_prices 
SET vocabulary_id = LEFT(code, INSTR(code, ' ') - 1);

UPDATE cmc_cash_prices
SET code = REPLACE(REPLACE(REPLACE(code, 'CPT® ', ''), 'Custom ', ''), 'HCPCS ', '');

UPDATE cmc_cash_prices
SET code = NULLIF(code, 'n/a'),
	vocabulary_id = NULLIF(vocabulary_id, ''),
    ip_gross_charge = NULLIF(ip_gross_charge, ''),
    ip_discounted_charge = NULLIF(ip_discounted_charge, ''),
    op_gross_charge = NULLIF(op_gross_charge, 'n/a'),
    op_discounted_charge = NULLIF(op_discounted_charge, 'n/a');

UPDATE cmc_cash_prices
SET vocabulary_id = REPLACE(vocabulary_id, '®', '');