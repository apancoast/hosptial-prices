SET SESSION sql_mode = '';
-- import carolinas medical center standard charges lists, subtables of interest
-- table 1, og titled HosCMCAdultDeindentified MInMax
CREATE TABLE cmc_adult_min_max (
    `procedure` VARCHAR(50),
    code_type VARCHAR(50),
    code VARCHAR(50),
    ndc VARCHAR(50),
    rev_code VARCHAR(150),
    procedure_description VARCHAR(150),
    quantity VARCHAR(50),
    plans VARCHAR(50),
    ip_price VARCHAR(50),
    ip_expected_reimbursment VARCHAR(50),
    op_price VARCHAR(50),
    op_expected_reimbursement VARCHAR(50),
    tabname VARCHAR(50)
);

LOAD DATA INFILE 'D:/Data Projects/HosCMCAdultDeindentified MInMax.csv'
INTO TABLE cmc_adult_min_max
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(`procedure`, code_type, code, ndc, rev_code, procedure_description, quantity, plans, ip_price, ip_expected_reimbursment, op_price, op_expected_reimbursement, tabname);

-- table 3, HosPedDeidentiifed MinMax
CREATE TABLE cmc_peds_min_max (
    `procedure` VARCHAR(50),
    code_type VARCHAR(50),
    code VARCHAR(50),
    ndc VARCHAR(50),
    rev_code VARCHAR(150),
    procedure_description VARCHAR(200),
    quantity VARCHAR(50),
    plans VARCHAR(50),
    ip_price VARCHAR(50),
    ip_expected_reimbursement VARCHAR(50),
    op_price VARCHAR(50),
    op_expected_reimbursement VARCHAR(50),
    tabname VARCHAR(50)
);

LOAD DATA INFILE 'D:/Data Projects/HosPedDeidentiifed MinMax.csv'
INTO TABLE cmc_peds_min_max
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(`procedure`, code_type, code, ndc, rev_code, procedure_description, quantity, plans, ip_price, ip_expected_reimbursement, op_price, op_expected_reimbursement, tabname);

-- table 4, Hospital Discounted Cash Price
CREATE TABLE cmc_cash_prices (
    `procedure` VARCHAR(50),
    code_type VARCHAR(50),
    code VARCHAR(50),
    rev_code VARCHAR(150),
    procedure_description VARCHAR(200),
    quantity VARCHAR(50),
    payer VARCHAR(50),
    plans VARCHAR(50),
    ip_gross_charge VARCHAR(50),
    ip_discounted_charge VARCHAR(50),
    op_gross_charge VARCHAR(50),
    op_discounted_charge VARCHAR(50),
    tabname VARCHAR(50)
);

LOAD DATA INFILE 'D:/Data Projects/Hospital Discounted Cash Price.csv'
INTO TABLE cmc_cash_prices
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(`procedure`, code_type, code, rev_code, procedure_description, quantity, payer, plans, ip_gross_charge, ip_discounted_charge, op_gross_charge, op_discounted_charge, tabname);

-- table 5, HospPedStdChargeALL Payer
CREATE TABLE cmc_ped_std (
    `procedure` VARCHAR(50),
    code_type VARCHAR(50),
    code VARCHAR(50),
    rev_code VARCHAR(150),
    procedure_description VARCHAR(200),
    quantity VARCHAR(50),
    payer VARCHAR(50),
    plans VARCHAR(50),
    ip_gross_charge VARCHAR(50),
    ip_negotiated_charge VARCHAR(50),
    op_gross_charge VARCHAR(50),
    op_negotiated_charge VARCHAR(50),
    tabname VARCHAR(50)
);

LOAD DATA INFILE 'D:/Data Projects/HospPedStdChargeALL Payer.csv'
INTO TABLE cmc_ped_std
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(`procedure`, code_type, code, rev_code, procedure_description, quantity, payer, plans, ip_gross_charge, ip_negotiated_charge, op_gross_charge, op_negotiated_charge, tabname);

-- table 6, HospStdChrgCMCAdult 0
CREATE TABLE cmc_adult_zero_std (
    `procedure` VARCHAR(50),
    code_type VARCHAR(50),
    code VARCHAR(50),
    rev_code VARCHAR(150),
    procedure_description VARCHAR(200),
    quantity VARCHAR(50),
    payer VARCHAR(50),
    plans VARCHAR(50),
    ip_gross_charge VARCHAR(50),
    ip_negotiated_charge VARCHAR(50),
    op_gross_charge VARCHAR(50),
    op_negotiated_charge VARCHAR(50),
    tabname VARCHAR(50)
);

LOAD DATA INFILE 'D:/Data Projects/HospStdChrgCMCAdult 0.csv'
INTO TABLE cmc_adult_zero_std
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(`procedure`, code_type, code, rev_code, procedure_description, quantity, payer, plans, ip_gross_charge, ip_negotiated_charge, op_gross_charge, op_negotiated_charge, tabname);

-- table 7, HosStdChrgCMCAdult 1
CREATE TABLE cmc_adult_one_std (
    `procedure` VARCHAR(50),
    code_type VARCHAR(50),
    code VARCHAR(50),
    rev_code VARCHAR(150),
    procedure_description VARCHAR(200),
    quantity VARCHAR(50),
    payer VARCHAR(50),
    plans VARCHAR(50),
    ip_gross_charge VARCHAR(50),
    ip_negotiated_charge VARCHAR(50),
    op_gross_charge VARCHAR(50),
    op_negotiated_charge VARCHAR(50),
    tabname VARCHAR(50)
);

LOAD DATA INFILE 'D:/Data Projects/HosStdChrgCMCAdult 1.csv'
INTO TABLE cmc_adult_one_std
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(`procedure`, code_type, code, rev_code, procedure_description, quantity, payer, plans, ip_gross_charge, ip_negotiated_charge, op_gross_charge, op_negotiated_charge, tabname);

-- Novant Presbyterian
CREATE TABLE novant_presbyterian_std (
    code varchar(255),
    description varchar(255),
    cpt varchar(255),
    charge_type varchar(255),
    gross_charge decimal(10, 2),
    min_negotiated_charge decimal(10, 2),
    max_negotiated_charge decimal(10, 2),
    cash_price decimal(10, 2),
    aetna_coventry decimal(10, 2),
    aetna_coventry_rental_network decimal(10, 2),
    aetna_coventry_mcr decimal(10, 2),
    alliance_behavioral_health decimal(10, 2),
    atlantic_packaging decimal(10, 2),
    bcbsnc_blue_medicare decimal(10, 2),
    bcbsnc_blue_value decimal(10, 2),
    bcbsnc_blue_home decimal(10, 2),
    bcbsnc_ppo_hmo decimal(10, 2),
    cardinal_innovations decimal(10, 2),
    carolina_complete decimal(10, 2),
    cigna decimal(10, 2),
    cigna_healthspring decimal(10, 2),
    healthy_blue decimal(10, 2),
    humana_commercial decimal(10, 2),
    humana_medicare decimal(10, 2),
    humana_ppox decimal(10, 2),
    humana_bh_commercial decimal(10, 2),
    humana_bh_mcr_advantage decimal(10, 2),
    liberty_advantage_mcr_hmo decimal(10, 2),
    medcost_mbs decimal(10, 2),
    medcost_non_mbs decimal(10, 2),
    multiplan decimal(10, 2),
    pace decimal(10, 2),
    partners_bhm_lme_mco decimal(10, 2),
    phcs decimal(10, 2),
    primary_physician_care decimal(10, 2),
    provider_select decimal(10, 2),
    three_rivers_provider_network decimal(10, 2),
    uhc decimal(10, 2),
    uhc_mcr_adv decimal(10, 2),
    wellcare decimal(10, 2),
    amerihealth_caritas decimal(10, 2)
);

LOAD DATA INFILE 'D:/Data Projects/hospital prices sources/NovantHealthPresbyterianMedicalCenter_standardcharges.csv' 
INTO TABLE novant_presbyterian_std
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
IGNORE 1 ROWS;

UPDATE novant_presbyterian_std
SET gross_charge = NULLIF(gross_charge, 0.00),
    min_negotiated_charge = NULLIF(min_negotiated_charge, 0.00),
    max_negotiated_charge = NULLIF(max_negotiated_charge, 0.00),
    cash_price = NULLIF(cash_price, 0.00),
    aetna_coventry = NULLIF(aetna_coventry, 0.00),
    aetna_coventry_rental_network = NULLIF(aetna_coventry_rental_network, 0.00),
    aetna_coventry_mcr = NULLIF(aetna_coventry_mcr, 0.00),
    alliance_behavioral_health = NULLIF(alliance_behavioral_health, 0.00),
    atlantic_packaging = NULLIF(atlantic_packaging, 0.00),
    bcbsnc_blue_medicare = NULLIF(bcbsnc_blue_medicare, 0.00),
    bcbsnc_blue_value = NULLIF(bcbsnc_blue_value, 0.00),
    bcbsnc_blue_home = NULLIF(bcbsnc_blue_home, 0.00),
    bcbsnc_ppo_hmo = NULLIF(bcbsnc_ppo_hmo, 0.00),
    cardinal_innovations = NULLIF(cardinal_innovations, 0.00),
    carolina_complete = NULLIF(carolina_complete, 0.00),
    cigna = NULLIF(cigna, 0.00),
    cigna_healthspring = NULLIF(cigna_healthspring, 0.00),
    healthy_blue = NULLIF(healthy_blue, 0.00),
    humana_commercial = NULLIF(humana_commercial, 0.00),
    humana_medicare = NULLIF(humana_medicare, 0.00),
    humana_ppox = NULLIF(humana_ppox, 0.00),
    humana_bh_commercial = NULLIF(humana_bh_commercial, 0.00),
    humana_bh_mcr_advantage = NULLIF(humana_bh_mcr_advantage, 0.00),
    liberty_advantage_mcr_hmo = NULLIF(liberty_advantage_mcr_hmo, 0.00),
    medcost_mbs = NULLIF(medcost_mbs, 0.00),
    medcost_non_mbs = NULLIF(medcost_non_mbs, 0.00),
    multiplan = NULLIF(multiplan, 0.00),
    pace = NULLIF(pace, 0.00),
    partners_bhm_lme_mco = NULLIF(partners_bhm_lme_mco, 0.00),
    phcs = NULLIF(phcs, 0.00),
    primary_physician_care = NULLIF(primary_physician_care, 0.00),
    provider_select = NULLIF(provider_select, 0.00),
    three_rivers_provider_network = NULLIF(three_rivers_provider_network, 0.00),
    uhc = NULLIF(uhc, 0.00),
    uhc_mcr_adv = NULLIF(uhc_mcr_adv, 0.00),
    wellcare = NULLIF(wellcare, 0.00),
    amerihealth_caritas = NULLIF(amerihealth_caritas, 0.00);

-- idk why in previous versions I deleted all rows w all null payers, because I didn't include cash and gross in that lists I'm choosing to not delete any and restore the whole table.
  
-- Novant Ortho
CREATE TABLE novant_clt_ortho (
  code VARCHAR(255),
  description VARCHAR(255),
  cpt VARCHAR(255),
  charge_type VARCHAR(255),
  gross_charge decimal(10, 2),
  min_negotiated_charge decimal(10, 2),
  max_negotiated_charge decimal(10, 2),
  cash_price decimal(10, 2),
  aetna_coventry decimal(10, 2),
  aetna_coventry_rental_network decimal(10, 2),
  aetna_coventry_mcr decimal(10, 2),
  alliance_behavioral_health decimal(10, 2),
  atlantic_packaging decimal(10, 2),
  bcbsnc_blue_medicare decimal(10, 2),
  bcbsnc_blue_value decimal(10, 2),
  bcbsnc_blue_home decimal(10, 2),
  bcbsnc_ppo_hmo decimal(10, 2),
  cardinal_innovations decimal(10, 2),
  carolina_complete decimal(10, 2),
  cigna decimal(10, 2),
  cigna_healthspring decimal(10, 2),
  healthy_blue decimal(10, 2),
  humana_commercial decimal(10, 2),
  humana_medicare decimal(10, 2),
  humana_ppox decimal(10, 2),
  humana_bh_commercial decimal(10, 2),
  humana_bh_mcr_advantage decimal(10, 2),
  liberty_advantage_mcr_hmo decimal(10, 2),
  medcost_mbs decimal(10, 2),
  medcost_non_mbs decimal(10, 2),
  multiplan decimal(10, 2),
  pace decimal(10, 2),
  partners_bhm_lme_mco decimal(10, 2),
  phcs decimal(10, 2),
  primary_physician_care decimal(10, 2),
  provider_select decimal(10, 2),
  three_rivers_provider_network decimal(10, 2),
  uhc decimal(10, 2),
  uhc_mcr_adv decimal(10, 2),
  wellcare decimal(10, 2),
  amerihealth_caritas decimal(10, 2)
);

LOAD DATA INFILE 'D:/Data Projects/hospital prices sources/NovantCharlotteOrthopedicHospital_standardcharges.csv' 
INTO TABLE novant_clt_ortho
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
IGNORE 1 ROWS;

UPDATE novant_clt_ortho
SET gross_charge = NULLIF(gross_charge, 0.00),
    min_negotiated_charge = NULLIF(min_negotiated_charge, 0.00),
    max_negotiated_charge = NULLIF(max_negotiated_charge, 0.00),
    cash_price = NULLIF(cash_price, 0.00),
    aetna_coventry = NULLIF(aetna_coventry, 0.00),
    aetna_coventry_rental_network = NULLIF(aetna_coventry_rental_network, 0.00),
    aetna_coventry_mcr = NULLIF(aetna_coventry_mcr, 0.00),
    alliance_behavioral_health = NULLIF(alliance_behavioral_health, 0.00),
    atlantic_packaging = NULLIF(atlantic_packaging, 0.00),
    bcbsnc_blue_medicare = NULLIF(bcbsnc_blue_medicare, 0.00),
    bcbsnc_blue_value = NULLIF(bcbsnc_blue_value, 0.00),
    bcbsnc_blue_home = NULLIF(bcbsnc_blue_home, 0.00),
    bcbsnc_ppo_hmo = NULLIF(bcbsnc_ppo_hmo, 0.00),
    cardinal_innovations = NULLIF(cardinal_innovations, 0.00),
    carolina_complete = NULLIF(carolina_complete, 0.00),
    cigna = NULLIF(cigna, 0.00),
    cigna_healthspring = NULLIF(cigna_healthspring, 0.00),
    healthy_blue = NULLIF(healthy_blue, 0.00),
    humana_commercial = NULLIF(humana_commercial, 0.00),
    humana_medicare = NULLIF(humana_medicare, 0.00),
    humana_ppox = NULLIF(humana_ppox, 0.00),
    humana_bh_commercial = NULLIF(humana_bh_commercial, 0.00),
    humana_bh_mcr_advantage = NULLIF(humana_bh_mcr_advantage, 0.00),
    liberty_advantage_mcr_hmo = NULLIF(liberty_advantage_mcr_hmo, 0.00),
    medcost_mbs = NULLIF(medcost_mbs, 0.00),
    medcost_non_mbs = NULLIF(medcost_non_mbs, 0.00),
    multiplan = NULLIF(multiplan, 0.00),
    pace = NULLIF(pace, 0.00),
    partners_bhm_lme_mco = NULLIF(partners_bhm_lme_mco, 0.00),
    phcs = NULLIF(phcs, 0.00),
    primary_physician_care = NULLIF(primary_physician_care, 0.00),
    provider_select = NULLIF(provider_select, 0.00),
    three_rivers_provider_network = NULLIF(three_rivers_provider_network, 0.00),
    uhc = NULLIF(uhc, 0.00),
    uhc_mcr_adv = NULLIF(uhc_mcr_adv, 0.00),
    wellcare = NULLIF(wellcare, 0.00),
    amerihealth_caritas = NULLIF(amerihealth_caritas, 0.00);