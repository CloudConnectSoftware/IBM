%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - D_TAULIA_IBM_AMAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( d_taulia_ibm_amat, `2024-10-17 10:47:28` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% header_level_item( Data_Item_Set, Data_Item_Name, Required, Required_Value, Mapping_Logic, Mandatory, Condition, Rules_Intervention_Missing, Customer_Intervention_Missing, Action_Missing, Email_Address_Missing, Error_Description_Missing, Rules_Intervention_Invalid, Customer_Intervention_Invalid, Action_Invalid, Email_Address_Invalid, Error_Description_Invalid, Mapping_Method, Variable_String, Data_Type, Number_of_Items, Ignore_Missing_Rules_Intervention, Ignore_Missing_Customer_Intervention, Ignore_Invalid_Rules_Intervention, Ignore_Invalid_Customer_Intervention, Include_In_Completion, Completion_Seciton, Completion_Box_Size, Mandatory_Dependency, Scenario_Dependency ).
% line_level_item( Data_Item_Set, Data_Item_Name, Required, Required_Value, Mapping_Logic, Mandatory, Condition, Rules_Intervention_Missing, Customer_Intervention_Missing, Action_Missing, Email_Address_Missing, Error_Description_Missing, Rules_Intervention_Invalid, Customer_Intervention_Invalid, Action_Invalid, Email_Address_Invalid, Error_Description_Invalid, Mapping_Method, Variable_String, Data_Type, Number_of_Items, Ignore_Missing_Rules_Intervention, Ignore_Missing_Customer_Intervention, Ignore_Invalid_Rules_Intervention, Ignore_Invalid_Customer_Intervention, Include_In_Completion, Completion_Seciton, Completion_Box_Size, Mandatory_Dependency, Scenario_Dependency ).
% header_level_scenario( Ref, Scenario, Rules_Intervention, Customer_Intervention, Action, Email_Address, Error_Description_Text, Quick_Action_Rules, Quick_Action_Customer, Portal_Reason, Ignore_From_Rules_Intervention, Ignore_From_Customer_Intervention, Scenario_Dependency ).
% line_level_scenario( Ref, Scenario, Rules_Intervention, Customer_Intervention, Action, Email_Address, Error_Description_Text, Quick_Action_Rules, Quick_Action_Customer, Portal_Reason, Ignore_From_Rules_Intervention, Ignore_From_Customer_Intervention, Scenario_Dependency ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DATA ITEMS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-----------------------------------------------------------------------
% Header Level Items
%-----------------------------------------------------------------------


% Not Inherited
header_level_item( `Taulia JSON`, `Additional Charge Description`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `line_descr_extra`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Tax Type`, `Yes`, `Map Buyer Tax Type when Company code is 0003 and set(amat_company_code_0003)`, `Map Buyer Tax Type when Company code is 0003 and set(amat_company_code_0003)`, `Conditional`, `AMAT company code is 0003`, `Rules (Mapped)`, `buyer_tax_type`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( grammar_set( amat_company_code_0003 ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Tax Value`, `Yes`, `Map Buyer Tax Value when Company code is 0003 and set(amat_company_code_0003)`, `Map Buyer Tax Value when Company code is 0003 and set(amat_company_code_0003)`, `Conditional`, `AMAT company code is 0003`, `Rules (Mapped)`, `buyer_vat_number`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( grammar_set( amat_company_code_0003 ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Comment`, `Yes`, `Map comment if comments are provided by supplier.`, `Map comment if comments are provided by supplier.`, `Never`, ``, `Rules (Mapped)`, `customer_comments`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Contact Person`, `Yes`, `Map contact person`, `Map contact person`, `Never`, ``, `Rules (Mapped)`, `buyer_contact`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Original Invoice Number`, `Yes`, `Map original invoice number`, `Map original invoice number`, `Conditional`, `Document is a credit note.`, `Rules (Mapped)`, `original_invoice_number`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( grammar_set( credit_note ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Credit Reason`, `Yes`, `Map reason for credit`, `Map reason for credit`, `Never`, ``, `Rules (Mapped)`, `reason_for_credit`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Customer External Reference`, `Yes`, `Map receiver's email address.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `buyer_registration_number`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Custom Field 1`, `Yes`, `Provide custom field 1 name and value`, `Provide custom field 1 name and value`, `Never`, ``, `Rules (Mapped)`, `custom_variable_1`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Delivery Date`, `Yes`, `map delivery date`, `map delivery date`, `Never`, ``, `Rules (Mapped)`, `delivery_date`, `Date`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Delivery Note`, `Yes`, `map delivery note`, `map delivery note`, `Never`, ``, `Rules (Mapped)`, `delivery_note_reference`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Amount 1`, `Yes`, `map header tax amount - map for India, USA or Canada based Supplier`, `map header tax amount - map for India, USA or Canada based Supplier`, `Never`, ``, `Rules (Mapped)`, `rate_1_vat`, `Number`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Type 1`, `Yes`, `map header tax type - map for USA or Canada based Supplier`, `map header tax type - map for USA or Canada based Supplier`, `Never`, ``, `Rules (Mapped)`, `vat_code_1`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Currency Exchange Rate`, `Yes`, `Map currency exchange rate for cross-border eInvoicing`, `Map currency exchange rate for cross-border eInvoicing`, `Never`, ``, `Rules (Mapped)`, `currency_exchange_rate`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Purchase Order ID`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `order_id`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Purchase Order Reference Number`, `Yes`, `Map purchase order number.`, `Map purchase order number.`, `Always`, ``, `Rules (Mapped)`, `order_number`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To City`, `Yes`, `Map Ship To address`, `Map Ship To address`, `Never`, ``, `Rules (Mapped)`, `delivery_city`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Vendor External Reference`, `Yes`, `Map sender's email address.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `supplier_registration_number`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Attachment Type`, `Yes`, `Hardcode attachment_type as LEGAL_INVOICE for Suppliers based in Bangladesh, China, Egypt, Indonesia, Israel, Kore, Cayman Islands, Philippines, Taiwan. Otherwise 'ESEND_INVOICE_IMAGE' is inserted automatically by p_ file.`, `Hardcode attachment_type as LEGAL_INVOICE for Suppliers based in Bangladesh, China, Egypt, Indonesia, Israel, Kore, Cayman Islands, Philippines, Taiwan. Otherwise 'ESEND_INVOICE_IMAGE' is inserted automatically by p_ file.`, `Never`, ``, `Both Rules & p_`, `attachment_type`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).


% Data items inherited from: Taulia
header_level_item( `Taulia JSON`, `Additional Charge Type`, `Yes`, `Map 'FREIGHT' for a freight/shipping charge.`, `Hard-code line_item as 'FREIGHT' and ensure that line_type is populated for line - this will ensure it is counted as an additional charge.`, `Never`, ``, `Rules (Mapped)`, `line_item_extra`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Additional Charge Amount`, `Yes`, `Map net amount of additional charge, such as freight or shipping.`, `Map into line_net_amount variable and ensure that line_type is populated for line - this will ensure it is counted as an additional charge.`, `Never`, ``, `Rules (Mapped)`, `line_net_amount_extra`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Addtional Charge Tax Rate`, `Yes`, `Map tax rate of additional charge, such as freight or shipping.`, `Map into line_vat_amount variable and ensure that line_type is populated for line - this will ensure it is counted as an additional charge.`, `Never`, ``, `Rules (Mapped)`, `line_vat_amount_extra`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Original Invoice Date`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `original_invoice_date`, `Date`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Currency`, `Yes`, `Map correct currency code.`, `Map correct currency code.`, `Always`, ``, `Rules (Mapped)`, `currency`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Customer ID`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_id`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Customer Reference Number`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `suppliers_code_for_buyer`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Custom Field 2`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `custom_variable_2`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Custom Field 3`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `custom_variable_3`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Custom Field 4`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `custom_variable_4`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Custom Field 5`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `custom_variable_5`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier City`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_city`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Country Code`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_country_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Email`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_email`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Fax`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_fax`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Name`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_party`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Phone`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_ddi`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Postal Code`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_postcode`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Region/State`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_state`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Street 1`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_street`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Street 2`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_address_line`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Total Gross Amount`, `Yes`, `Map total invoice amount.`, `Map total invoice amount.`, `Always`, ``, `Rules (Mapped)`, `total_invoice`, `Number`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Amount 2`, `Yes`, `Insert total tax at tax rate 2.`, `Automated by p_ file.`, `Never`, ``, `Rules/Gramatica Derived`, `rate_2_vat`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Type 2`, `Yes`, `Map value based on mapping sheet.`, `Map value based on mapping sheet.`, `Never`, ``, `Rules (Mapped)`, `vat_code_2`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Amount 3`, `Yes`, `Insert total tax at tax rate 3.`, `Automated by p_ file.`, `Never`, ``, `Rules/Gramatica Derived`, `rate_3_vat`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Type 3`, `Yes`, `Map value based on mapping sheet.`, `Map value based on mapping sheet.`, `Never`, ``, `Rules (Mapped)`, `vat_code_3`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Amount 4`, `Yes`, `Insert total tax at tax rate 4.`, `Automated by p_ file.`, `Never`, ``, `Rules/Gramatica Derived`, `rate_4_vat`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Type 4`, `Yes`, `Map value based on mapping sheet.`, `Map value based on mapping sheet.`, `Never`, ``, `Rules (Mapped)`, `vat_code_4`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Amount 5`, `Yes`, `Insert total tax at tax rate 5.`, `Automated by p_ file.`, `Never`, ``, `Rules/Gramatica Derived`, `rate_5_vat`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Type 5`, `Yes`, `Map value based on mapping sheet.`, `Map value based on mapping sheet.`, `Never`, ``, `Rules (Mapped)`, `vat_code_5`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Invoice Date`, `Yes`, `Map invoice date.`, `Map invoice date.`, `Always`, ``, `Rules (Mapped)`, `invoice_date`, `Date`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Invoice Number`, `Yes`, `Map invoice number.`, `Map invoice number.`, `Always`, ``, `Rules (Mapped)`, `invoice_number`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To City`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_city`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Country Code`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Email`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_email`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Fax`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_fax`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Name`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_party`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Phone`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_ddi`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Postal Code`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_postcode`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Region/State`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_state`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Street 1`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_street`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Remit To Street 2`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `invoice_to_address_line`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Reference Number`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `narrative`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From City`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_city`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Country Code`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Email`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_email`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Fax`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_fax`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Name`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_party`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Phone`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_ddi`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Postal Code`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_postcode`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Region/State`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_state`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Street 1`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_street`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship From Street 2`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_from_address_line`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Country Code`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_country_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Email`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_email`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Fax`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_fax`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Name`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_party`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Phone`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_ddi`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Postal Code`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_postcode`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Region/State`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_state`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Street 1`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_street`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Ship To Street 2`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `delivery_address_line`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Tax Country`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_tax_country`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Tax Type`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_tax_type`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Supplier Tax Value`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_vat_number`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer City`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_city`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Country Code`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_country_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Email`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_email`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Fax`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_fax`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Name`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_party`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Phone`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_ddi`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Postal Code`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_postcode`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Region/State`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_state`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Street 1`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_street`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Buyer Street 2`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyer_address_line`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Total Discount Amount`, `Yes`, `Map if required by mapping sheet.`, `Map if required by mapping sheet.`, `Never`, ``, `Rules/Gramatica Derived`, `total_discount`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Total Tax Amount`, `Yes`, `Map sum of header taxes.`, `Map sum of header taxes.`, `Always`, ``, `Rules (Mapped)`, `total_vat`, `Number`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Vendor ID`, `No`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `supplier_id`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Vendor Reference Number`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `buyers_code_for_supplier`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `File Name`, `Yes`, `Map as required, otherwise insert file name.`, `Map as required. Everything else automated by p_ file.`, `Never`, ``, `Both Rules & p_`, `file_name`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Mime Type`, `Yes`, `Map as required, otherwise insert 'application/pdf'.`, `Map as required. Everything else automated by p_ file.`, `Never`, ``, `Both Rules & p_`, `mime_type`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Additional Attachment File Name`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `additional_attachment_file_name`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Additional Attachment Mime Type`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `additional_attachment_mime_type`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Additional Attachment Type`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `additional_attachment_attachment_type`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Clearance UUID`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `tax_clearance_uuid`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).

%-----------------------------------------------------------------------
% Header Level Functional Items
%-----------------------------------------------------------------------


% Data items inherited from: Taulia
header_level_item( `Taulia JSON`, `Sender Name`, `Yes`, `Insert name of sending organisation.Determines value of Sending Organisation.`, `Hard - code correct value in rules.`, `Always`, ``, `Rules (Hard Coded)`, `sender_name`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Sending Organisation`, `Yes`, `Insert name of sending organisation. Determines sender name in the portal.`, `Automated by u_portal_values. Same value as Sender Name is automatically inserted.`, `Always`, ``, `p_ (Hard Coded)`, `sending_organisation`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Receiving Organisation`, `Yes`, `Insert name of receiving organisation. Determines receiver name in the portal.`, `Automated by u_portal_values. Correct value is automatically inserted.`, `Always`, ``, `p_ (Hard Coded)`, `receiving_organisation`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Customer`, `Yes`, `Insert name of customer. Determines customer name in the portal.`, `Automated by u_portal_values. Correct value is automatically inserted.`, `Always`, ``, `p_ (Hard Coded)`, `customer`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Channel Partner`, `Yes`, `Insert name of channel partner. Determines channel partner name in the portal.`, `Automated by u_portal_values. Correct value is automatically inserted.`, `Always`, ``, `p_ (Hard Coded)`, `channel_partner`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Document Type`, `Yes`, `Insert correct document type. Determines document type in the portal.`, `Automated by p_. Defaults to "Credit Note" if credit_note flag has been set, Order" if purchase_order flag has been set, Invoice" otherwise.`, `Always`, ``, `p_ (Hard Coded)`, `document_type`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Return Email`, `Yes`, `Insert email address(es) for document to be returned to. Determines email addresses that document will be returned to if it is being returned to the sender.`, `Either map/hard-code in rules, or automated by u_insert_connection_codes. Value from connection list on SDD is automatically inserted. If not present, from address is inserted instead.`, `Never`, ``, `Both Rules & p_`, `return_email`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Forward Email`, `Yes`, `Insert email address(es) for document to be forwarded to. Determines email addresses that documents will be returned to if they are being forwarded to an email address.`, `Automated based on email address column in SDD when action is "Forward to Email Address". Can be overridden by an i_analyse_enquire_last in the p_ file.`, `Never`, ``, `Both Rules & p_`, `forward_email`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Intervention RTS Email`, `Yes`, `Insert email address(es) for document to be returned to, based on RTS button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on RTS button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_rts_email`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Intervention Forward Email`, `Yes`, `Insert email address(es) for document to be forwarded to, based on forward button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on forward button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_forward_email`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Intervention RTS Email Subject`, `Yes`, `Insert email subject based on RTS button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on RTS button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_rts_email_subject`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Intervention Forward Email Subject`, `Yes`, `Insert email subjcet based on forward button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on forward button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_forward_email_subject`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Intervention RTS Email Body`, `Yes`, `Insert email body based on RTS button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on RTS button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_rts_email_body`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Intervention Forward Email Body`, `Yes`, `Insert email body based on forward button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on forward button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_forward_email_body`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Enquiry Role`, `Yes`, `Insert intervention role.`, `Automated by u_intervention_generation.`, `Never`, ``, `p_ (Hard Coded)`, `enquiry_role`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Error Name`, `Yes`, `For missing header level value insert "Missing [Data Item Name]", for missing line level value insert "Missing [Data Item Name] at lines [Missing Lines]", for invalid header level value insert "Invalid [Data Item Name]", for invalid line level value insert "Invalid[Data Item Name] at lines[Invalid Lines]", for header level scenarios insert "[Scenaio Name]", for line level sceanrios insert [Sceanrio Name] at lines [Scenario Lines]".If there are multiple errors, separate by commas.`, `Automated by u_error_detection_test.`, `Never`, ``, `p_ (Hard Coded)`, `error_name`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Error Description Text`, `Yes`, `Insert value from relevant error description text column on SDD. If there are multiple, separate with line breaks.`, `Automated by u_error_detection_test.`, `Never`, ``, `p_ (Hard Coded)`, `error_description_text`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Default VAT Rate`, `Yes`, `Map/insert default VAT rate.`, `Map in rules, otherwise automated by Gramatica.`, `Never`, ``, `Rules/Gramatica Derived`, `default_vat_rate`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Rounding Amount`, `Yes`, `Map rounding amount from document. Otherwise default to '0'.`, `Map rounding amount from document. Everything else automated by p_ file.`, `Never`, ``, `Both Rules & p_`, `rounding_amount`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Header Discount`, `Yes`, `Map header discount from document. Otherwise default to '0'. Then subtract sum of negative values from value to get final header discount.`, `Map header discount from document. Everything else automated by p_ file.`, `Never`, ``, `Both Rules & p_`, `header_discount`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Additional Attachment`, `Yes`, `Insert file name of additional attachment to be included in the output file.`, `Insert file name of additional attachment to be included in the output file.`, `Never`, ``, `Rules (Hard Coded)`, `additional_attachment`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `VAT Subtotal 1`, `Yes`, `Map VAT subtotal 1.`, `Map VAT subtotal 1.`, `Never`, ``, `Rules (Mapped)`, `vat_subtotal_1`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `VAT Subtotal 2`, `Yes`, `Map VAT subtotal 2.`, `Map VAT subtotal 2.`, `Never`, ``, `Rules (Mapped)`, `vat_subtotal_2`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `VAT Subtotal 3`, `Yes`, `Map VAT subtotal 3.`, `Map VAT subtotal 3.`, `Never`, ``, `Rules (Mapped)`, `vat_subtotal_3`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `VAT Subtotal 4`, `Yes`, `Map VAT subtotal 4.`, `Map VAT subtotal 4.`, `Never`, ``, `Rules (Mapped)`, `vat_subtotal_4`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `VAT Subtotal 5`, `Yes`, `Map VAT subtotal 5.`, `Map VAT subtotal 5.`, `Never`, ``, `Rules (Mapped)`, `vat_subtotal_5`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).


% Not Inherited
header_level_item( `Taulia JSON`, `Total Net Amount`, `Yes`, `Map Total Net Amount for India when there are TCS Header Tax Amount`, `Map Total Net Amount for India when there are TCS Header Tax Amount`, `Conditional`, `AMAT TCS India taxes`, `Rules (Mapped)`, `total_net`, `Number`, `1`, `Yes`, `Header Level Details`, `6`, ( grammar_set( amat_tcs_india_tax ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Total Header Taxes`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Conditional`, `AMAT TCS India taxes`, `Rules (Mapped)`, `total_header_taxes`, `Number`, `1`, `No`, `Functional Items`, `6`, ( grammar_set( amat_tcs_india_tax ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Custom Field Document Type`, `Yes`, `Set invoice i_user_field custom_document_type and map custom_document_type from pdf/hardcode as INV, DBN or CRN`, `Set invoice i_user_field custom_document_type and map custom_document_type from pdf/hardcode as INV, DBN or CRN`, `Conditional`, `India supplier.`, `p_ (Hard Coded)`, `custom_document_type`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( grammar_set( amat_india_supplier ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Custom Field Type of Supply`, `Yes`, `Set invoice i_user_field typeOfSupply and map type_Of_Supply from pdf/hardcode as B2B, SEZWP, SEZWOP, DEXP, EXPWP or EXPWOP`, `Set invoice i_user_field typeOfSupply and map type_Of_Supply from pdf/hardcode as B2B, SEZWP, SEZWOP, DEXP, EXPWP or EXPWOP`, `Conditional`, `India supplier.`, `p_ (Hard Coded)`, `type_of_supply`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( grammar_set( amat_india_supplier ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Custom Field Reverse Charge`, `Yes`, `Set invoice i_user_field reversecharge and map reverse_charge from pdf/hardcode as YES or NO`, `Set invoice i_user_field reversecharge and map reverse_charge from pdf/hardcode as YES or NO`, `Conditional`, `India supplier.`, `p_ (Hard Coded)`, `reverse_charge`, `String`, `1`, `Yes`, `Header Level Details`, `6`, ( grammar_set( amat_india_supplier ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Rate 1`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Conditional`, `AMAT TCS India taxes`, `Rules (Mapped)`, `vat_rate_1`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( grammar_set( amat_tcs_india_tax ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Net Amount 1`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Conditional`, `AMAT TCS India taxes`, `Rules (Mapped)`, `rate_1_net`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( grammar_set( amat_tcs_india_tax ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Gross Amount 1`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Conditional`, `AMAT TCS India taxes`, `Rules (Mapped)`, `rate_1_gross`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( grammar_set( amat_tcs_india_tax ) ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Rate 2`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `vat_rate_2`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Net Amount 2`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `rate_2_net`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Gross Amount 2`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `rate_2_gross`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Rate 3`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `vat_rate_3`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Net Amount 3`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `rate_3_net`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Gross Amount 3`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `rate_3_gross`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Rate 4`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `vat_rate_4`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Net Amount 4`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `rate_4_net`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Gross Amount 4`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `rate_4_gross`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Tax Rate 5`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `vat_rate_5`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Net Amount 5`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `rate_5_net`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `Taulia JSON`, `Gross Amount 5`, `Yes`, `Used only for calculations for India TCS Taxes`, `Used only for calculations for India TCS Taxes`, `Never`, ``, `Rules (Mapped)`, `rate_5_gross`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).

%-----------------------------------------------------------------------
% Line Level Items
%-----------------------------------------------------------------------


% Data items inherited from: Taulia
line_level_item( `Taulia JSON`, `Line Delivery Note`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `line_delivery_note_number`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Description`, `Yes`, `Map description of line item.`, `Map description of line item.`, `Always`, ``, `Rules (Mapped)`, `line_descr`, `String`, `1`, `Yes`, `Line Level Details`, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Material Code`, `Yes`, `Map item code for line item.`, `Map item code for line item.`, `Never`, ``, `Rules (Mapped)`, `line_item`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Quantity`, `Yes`, `Map quantity of line item.`, `Map quantity of line item.`, `Always`, ``, `Rules (Mapped)`, `line_quantity`, `Number`, `1`, `Yes`, `Line Level Details`, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Unit Price`, `Yes`, `Map unit price of line item.`, `Map unit price of line item.`, `Always`, ``, `Rules (Mapped)`, `line_unit_amount`, `Number`, `1`, `Yes`, `Line Level Details`, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Price Unit of Measure`, `Yes`, `Map price unit of measure. Must be a number.`, `Map price unit of measure. Must be a number.`, `Never`, ``, `Rules (Mapped)`, `line_price_uom_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Custom Line Field 4`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `custom_line_variable_4`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Custom Line Field 5`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `custom_line_variable_5`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Line Net Amount`, `Yes`, `Map net price of line item.`, `Map net price of line item.`, `Never`, ``, `Rules (Mapped)`, `line_net_amount`, `Number`, `1`, `Yes`, `Line Level Details`, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Line Buyer Item`, `Yes`, `Map as required.`, `Map as required.`, `Never`, ``, `Rules (Mapped)`, `line_buyer_item`, `String`, `1`, `No`, `Line Level Items`, `6`, ( true ), ( true ) ).


% Not Inherited
line_level_item( `Taulia JSON`, `Line Discount`, `Yes`, `Map line item discount`, `Map line item discount`, `Never`, ``, `Rules (Mapped)`, `line_amount_discount`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `PO Item Number`, `Yes`, `Map as specified in the mapping instructions. If specified as 1, 2, 3 ... in mapping instructions, call general_count_rule_1 for each line. If specified as 10, 20, 30... in mapping instructions, call general_count_rule_10 for each line. If not specified, map PO line item number if present on the document.`, `Map as specified in the mapping instructions. If specified as 1, 2, 3 ... in mapping instructions, call general_count_rule_1 for each line. If specified as 10, 20, 30... in mapping instructions, call general_count_rule_10 for each line. If not specified, map PO line item number if present on the document.`, `Always`, ``, `Rules (Mapped)`, `line_buyers_order_number`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Quantity Unit of Measure`, `Yes`, `Map UOM`, `Map UOM`, `Always`, ``, `Rules (Mapped)`, `line_quantity_uom_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Custom Line Field 1`, `Yes`, `provide custom field 1 name and value`, `provide custom field 1 name and value`, `Never`, ``, `Rules (Mapped)`, `custom_line_variable_1`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Custom Line Field 2`, `Yes`, `provide custom field 2 name and value`, `provide custom field 2 name and value`, `Never`, ``, `Rules (Mapped)`, `custom_line_variable_2`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Custom Line Field 3`, `Yes`, `provide custom field 3 name and value`, `provide custom field 3 name and value`, `Never`, ``, `Rules (Mapped)`, `custom_line_variable_3`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Line Tax Amount`, `Yes`, `Map line tax amount`, `Map line tax amount`, `Never`, ``, `Rules (Mapped)`, `line_vat_amount`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Line Tax Rate`, `Yes`, `Map line tax rate`, `Map line tax rate`, `Never`, ``, `Rules (Mapped)`, `line_vat_rate`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Line Tax Exempt Reason`, `Yes`, `Map line tax exempt reason`, `Map line tax exempt reason`, `Never`, ``, `Rules (Mapped)`, `line_tax_exempt_reason`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Line VAT Type`, `Yes`, `Map Line VAT Type for India and Taiwan Suppliers`, `Map Line VAT Type for India and Taiwan Suppliers`, `Conditional`, `India or Taiwan supplier.`, `Rules (Mapped)`, `line_vat_type`, `String`, `1`, `No`, `Line Level Items`, `6`, ( grammar_set(`testing_line_variable`, `line_vat_type`, LID), grammar_set( amat_india_supplier ); grammar_set( amat_taiwan_supplier ) ), ( true ) ).

%-----------------------------------------------------------------------
% Line Level Functional Items
%-----------------------------------------------------------------------


% Data items inherited from: Taulia
line_level_item( `Taulia JSON`, `Line Credit Indicator`, `Yes`, `Insert 'true' for negative additional charges lines and 'false' otherwise.`, `Insert 'true' for negative additional charges lines and 'false' otherwise.`, `Never`, ``, `Both Rules & p_`, `line_credit_indicator`, `String`, `1`, `Yes`, `Line Level Details`, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Line Type`, `Yes`, `Insert 'extra' for additional charges line.`, `Insert 'extra' for additional charges line.`, `Never`, ``, `Both Rules & p_`, `line_type`, `String`, `1`, `Yes`, `Line Level Details`, `6`, ( true ), ( true ) ).
line_level_item( `Taulia JSON`, `Line Gross Amount`, `Yes`, `Insert gross price of line item.`, `Insert gross price of line item.`, `Never`, ``, `Both Rules & p_`, `line_total_amount`, `String`, `1`, `Yes`, `Line Level Details`, `6`, ( true ), ( true ) ).


% Not Inherited
line_level_item( `Taulia JSON`, `Custom Line Field HSN Code`, `Yes`, `Set line i_user_field hsncode and map hsn_code`, `Set line i_user_field hsncode and map hsn_code`, `Conditional`, `India supplier.`, `Rules (Mapped)`, `line_hsn_code`, `String`, `1`, `Yes`, `Line Level Details`, `6`, ( grammar_set( amat_india_supplier ) ), ( true ) ).
line_level_item( `Taulia JSON`, `Custom Line Field Is Service`, `Yes`, `Set line i_user_field isService and map is_service from pdf/hardcode as YES or NO`, `Set line i_user_field isService and map is_service from pdf/hardcode as YES or NO`, `Conditional`, `India supplier.`, `Rules (Mapped)`, `line_is_service`, `String`, `1`, `Yes`, `Line Level Details`, `6`, ( grammar_set( amat_india_supplier ) ), ( true ) ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DOCUMENT SCENARIOS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-----------------------------------------------------------------------
% Header Level Scenarios
%-----------------------------------------------------------------------


% Document scenario inherited from Taulia
header_level_scenario( `1`, `Body of Email`, `No`, `No`, `Return to Sender`, ``, `The document is the body of an email that was sent without any attachments.`, `No`, `No`, `Body of Email`, `No`, `No`, ( i_mail( attachment, `body.html` ) ) ).
header_level_scenario( `2`, `Credit Note`, `No`, `No`, `Process With Positive Values`, ``, `The document has been recognised as a credit note.`, `No`, `No`, `Credit Note`, `No`, `No`, ( grammar_set( credit_note ) ) ).
header_level_scenario( `3`, `Duplicate`, `No`, `No`, `Process As Normal`, ``, `The document has been recognised as a duplicate of one that has previously processed successfully.`, `No`, `No`, `Duplicate`, `No`, `No`, ( grammar_set( i_analyse_duplicate ) ) ).
header_level_scenario( `4`, `Future Date`, `No`, `No`, `Process As Normal`, ``, `The document date is in the future.`, `No`, `No`, `Future Date`, `No`, `No`, ( grammar_set( future_dated, invoice_date ) ) ).
header_level_scenario( `6`, `Invalid Invoice Date`, `Yes`, `No`, `Return to Sender`, ``, `The value for the Invoice Date was '<data>Invoice Date</data>', which is invalid.`, `No`, `No`, `Invalid Invoice Date`, `No`, `No`, ( grammar_set( invoice, `i_analyse_invalid_invoice_date` ) ) ).
header_level_scenario( `7`, `Invalid Invoice Number`, `Yes`, `No`, `Return to Sender`, ``, `The value for the Invoice Number was '<data>Invoice Number</data>', which is invalid.`, `No`, `No`, `Invalid Invoice Number`, `No`, `No`, ( grammar_set( invoice, `i_analyse_invalid_invoice_number` ) ) ).
header_level_scenario( `11`, `Missing Currency`, `Yes`, `No`, `Return to Sender`, ``, `The document is missing the following piece of data: Currency`, `No`, `No`, `Missing Currency`, `Yes`, `Yes`, ( not( result( _, invoice, currency, _ ) ) ) ).
header_level_scenario( `19`, `Missing Invoice Date`, `Yes`, `No`, `Return to Sender`, ``, `Please note that the invoice date is missing. Please resubmit with a provided invoice date.`, `Yes`, `No`, `Missing Invoice Date`, `Yes`, `Yes`, ( not( result( _, invoice, invoice_date, _ ) ) ) ).
header_level_scenario( `20`, `Missing Invoice Number`, `Yes`, `No`, `Return to Sender`, ``, `Please note that the invoice number is missing. Please resubmit with a provided invoice number.`, `Yes`, `No`, `Missing Invoice Number`, `Yes`, `Yes`, ( not( result( _, invoice, invoice_number, _ ) ) ) ).
header_level_scenario( `29`, `Missing Total Gross Amount`, `Yes`, `No`, `Return to Sender`, ``, `The document is missing the following piece of data: Total Gross Amount`, `No`, `No`, `Missing Total Gross Amount`, `Yes`, `Yes`, ( not( result( _, invoice, total_invoice, _ ) ) ) ).
header_level_scenario( `32`, `Missing Total Tax Amount`, `Yes`, `No`, `Return to Sender`, ``, `The document is missing the following piece of data: Total Tax Amount`, `No`, `No`, `Missing Total Tax Amount`, `No`, `No`, ( not( result( _, invoice, total_vat, _ ) ) ) ).
header_level_scenario( `36`, `New Layout`, `No`, `No`, `Return to Sender`, ``, `The document has a new layout to any which have previously been sent by the organisation that the document relates to. A new mapping will need to be completed if the document is to be processed.`, `Yes`, `No`, `New Layout`, `No`, `No`, ( grammar_set( i_analyse_new_layout ) ) ).
header_level_scenario( `38`, `Not On Project`, `No`, `No`, `Return to Sender`, ``, `The organisation that the document relates to has not been added to the system by the customer. This means that the document cannot be processed.`, `Yes`, `No`, `Not On Project`, `No`, `No`, ( grammar_set( i_analyse_not_on_project ) ) ).
header_level_scenario( `39`, `Old Date`, `No`, `No`, `Process As Normal`, ``, `The document date is older than the allowance.`, `No`, `No`, `Old Date`, `No`, `No`, ( grammar_set( over_x_days_old, invoice_date ) ) ).
header_level_scenario( `44`, `Statement/Correspondence`, `No`, `No`, `Return to Sender`, ``, `The document is a statement or some other document which requires manual processing.`, `Yes`, `No`, `Statement/Correspondence`, `No`, `No`, ( grammar_set( i_analyse_statement_correspondence ) ) ).
header_level_scenario( `48`, `Unrecognised/Failed to Map Any Data`, `Yes`, `No`, `Return to Sender`, ``, `The document is either unrecognised or has failed to map any data. This is usually because it is a document that does not require processing, such as a statement or a body of an email, but can also be because the layout of the document is different to previous documents from the sender.`, `Yes`, `No`, `Unrecognised`, `No`, `No`, ( missed_data_items_condition ) ).
header_level_scenario( `49`, `Unsupported File Extension`, `No`, `No`, `Return to Sender`, ``, `The document has a file extension which is unsupported by the system. The ideal format is a data PDF (which is not the same as an image PDF), but any text-based document format will do. If text can be copied and pasted from the document, then it is in a format which is supported by the system.`, `Yes`, `No`, `Unsupported File Type`, `No`, `No`, ( i_error_unsupported_file_type ) ).
header_level_scenario( `52`, `Zero Value Document`, `No`, `No`, `Return to Sender`, ``, `The document has a total value of zero.`, `No`, `No`, `Zero Value Document`, `No`, `No`, ( i_error_zero_value_invoice ) ).


% Not Inherited
header_level_scenario( `5`, `Image Document`, `No`, `No`, `Return to Sender`, ``, `The document does not contain any text which can be read by the system, which suggests that it is an image or has been scanned. The ideal format is a data PDF (which is not the same as an image PDF), but any text-based document format will do. If text can be copied and pasted from the document, then it is in a format which is supported by the system.`, `No`, `No`, `Image Document`, `Yes`, `Yes`, ( i_error_empty ) ).
header_level_scenario( `8`, `Invalid PO line Number format`, `Yes`, `Yes`, `Action From Intervention`, ``, `The document contains invalid PO line number format`, `No`, `No`, `Invalid PO line Number format`, `Yes`, `Yes`, ( grammar_set( invalid_line_buyers_order_number) ) ).
header_level_scenario( `9`, `Missing Buyer Tax Type`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Buyer Tax Type`, `No`, `No`, `Missing Buyer Tax Type`, `No`, `No`, ( not( result( _, invoice, buyer_tax_type, _ ) ), grammar_set( amat_company_code_0003 ) ) ).
header_level_scenario( `10`, `Missing Buyer Tax Value`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Buyer Tax Value`, `No`, `No`, `Missing Buyer Tax Value`, `No`, `No`, ( not( result( _, invoice, buyer_vat_number, _ ) ), grammar_set( amat_company_code_0003 ) ) ).
header_level_scenario( `12`, `Missing Custom Field Document Type`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Custom Field Document Type`, `No`, `No`, `Missing Custom Field Document Type`, `No`, `No`, ( not( result( _, invoice, custom_document_type, _ ) ), grammar_set( amat_india_supplier ) ) ).
header_level_scenario( `13`, `Missing Custom Field Reverse Charge`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Custom Field Reverse Charge`, `No`, `No`, `Missing Custom Field Reverse Charge`, `No`, `No`, ( not( result( _, invoice, reverse_charge, _ ) ), grammar_set( amat_india_supplier ) ) ).
header_level_scenario( `14`, `Missing Custom Field Type of Supply`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Custom Field Type of Supply`, `No`, `No`, `Missing Custom Field Type of Supply`, `No`, `No`, ( not( result( _, invoice, type_of_supply, _ ) ), grammar_set( amat_india_supplier ) ) ).
header_level_scenario( `18`, `Missing Gross Amount 1`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Gross Amount 1`, `No`, `No`, `Missing Gross Amount 1`, `No`, `No`, ( not( result( _, invoice, rate_1_gross, _ ) ), grammar_set( amat_tcs_india_tax ) ) ).
header_level_scenario( `22`, `Missing Net Amount 1`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Net Amount 1`, `No`, `No`, `Missing Net Amount 1`, `No`, `No`, ( not( result( _, invoice, rate_1_net, _ ) ), grammar_set( amat_tcs_india_tax ) ) ).
header_level_scenario( `23`, `Missing Original Invoice Number`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Original Invoice Number`, `No`, `No`, `Missing Original Invoice Number`, `No`, `No`, ( not( result( _, invoice, original_invoice_number, _ ) ), grammar_set( credit_note ) ) ).
header_level_scenario( `25`, `Missing Purchase Order Reference Number`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Purchase Order Reference Number`, `No`, `No`, `Missing Purchase Order Reference Number`, `No`, `No`, ( not( result( _, invoice, order_number, _ ) ) ) ).
header_level_scenario( `28`, `Missing Tax Rate 1`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Tax Rate 1`, `No`, `No`, `Missing Tax Rate 1`, `No`, `No`, ( not( result( _, invoice, vat_rate_1, _ ) ), grammar_set( amat_tcs_india_tax ) ) ).
header_level_scenario( `30`, `Missing Total Header Taxes`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Total Header Taxes`, `No`, `No`, `Missing Total Header Taxes`, `No`, `No`, ( not( result( _, invoice, total_header_taxes, _ ) ), grammar_set( amat_tcs_india_tax ) ) ).
header_level_scenario( `31`, `Missing Total Net Amount`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Total Net Amount`, `No`, `No`, `Missing Total Net Amount`, `No`, `No`, ( not( result( _, invoice, total_net, _ ) ), grammar_set( amat_tcs_india_tax ) ) ).
header_level_scenario( `37`, `No Lines`, `No`, `Yes`, `Action From Intervention`, ``, `The document does not contain any lines.`, `No`, `No`, `No Lines`, `No`, `No`, ( i_error_missing_lines ) ).
header_level_scenario( `40`, `PDF Error`, `No`, `No`, `Return to Sender`, ``, `The document is a PDF which is either secured or contains an embedded font, which means that the system cannot read the text contained within the document. In order for the document to be processed, it must be generated by either using a different method or by changing the settings on the application which generates the document. The ideal format is a data PDF (which is not the same as an image PDF), but any text-based document format will do. If text can be copied and pasted from the document, then it is in a format which is supported by the system.`, `No`, `No`, `PDF Error`, `Yes`, `Yes`, ( i_error_pdf_error ) ).
header_level_scenario( `41`, `Positive & Negative Lines`, `No`, `No`, `Return to Sender`, ``, `The document contains both positive and negative lines.`, `No`, `No`, `Positive and Negative Lines`, `No`, `No`, ( i_error_positive_and_negative_lines ) ).
header_level_scenario( `45`, `Sum of Line Gross Amounts Not Equal to Total Gross Amount`, `No`, `Yes`, `Action From Intervention`, ``, `The sum of the line gross amounts are not equal to the total gross amount. Sum of Line Gross Amounts = <data>Sum of Line Gross Amounts</data>, Total Gross Amount = <data>Total Gross Amount</data>, Difference = <data>Gross Difference</data>.`, `Yes`, `No`, `Sum of Line Gross Amounts Not Equal to Total Gross Amount`, `Yes`, `Yes`, ( i_error_sum_total_discrepancy( `0.05` ), not(chained_to( `generic_taulia` )), not(chained_to( `nexans hydro` )), not( grammar_set( no_total_validation ) ) ) ).
header_level_scenario( `46`, `Sum of Line Net Amounts Not Equal to Total Net Amount`, `No`, `Yes`, `Action From Intervention`, ``, `The sum of the line net amounts are not equal to the total net amount. Sum of Line Net Amounts = <data>Sum of Line Net Amounts</data>, Total Net Amount = <data>Total Net Amount</data>, Difference = <data>Net Difference</data>.`, `Yes`, `No`, `Sum of Line Net Amounts Not Equal to Total Net Amount`, `Yes`, `Yes`, ( i_error_sum_net_discrepancy( `0.05` ), not(chained_to( `generic_taulia` )), not(chained_to( `nexans hydro` )), not( grammar_set( no_total_validation ) ) ) ).
header_level_scenario( `47`, `Totals Do Not Add Up`, `No`, `No`, `Process As Normal`, ``, `The document contains inconsistent totals, i.e. Total Net + Total VAT \= Total Gross.`, `Yes`, `No`, `Totals Do Not Add Up`, `Yes`, `Yes`, ( i_error_invoice_totals_inconsistent( `0.01` ) ) ).

%-----------------------------------------------------------------------
% Line Level Scenarios
%-----------------------------------------------------------------------


% Not Inherited
line_level_scenario( `15`, `Missing Custom Line Field HSN Code`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Custom Line Field HSN Code`, `No`, `No`, `Missing Custom Line Field HSN Code`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `15_Missing Custom Line Field HSN Code`, LID), not( result( _, LID, line_hsn_code, _ ) ), grammar_set( amat_india_supplier ) ) ).
line_level_scenario( `16`, `Missing Custom Line Field Is Service`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Custom Line Field Is Service`, `No`, `No`, `Missing Custom Line Field Is Service`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `16_Missing Custom Line Field Is Service`, LID), not( result( _, LID, line_is_service, _ ) ), grammar_set( amat_india_supplier ) ) ).
line_level_scenario( `21`, `Missing Line VAT Type`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Line VAT Type`, `No`, `No`, `Missing Line VAT Type`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `21_Missing Line VAT Type`, LID), not( result( _, LID, line_vat_type, _ ) ), grammar_set( amat_india_supplier ); grammar_set( amat_taiwan_supplier ) ) ).
line_level_scenario( `24`, `Missing PO Item Number`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: PO Item Number`, `No`, `No`, `Missing PO Item Number`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `24_Missing PO Item Number`, LID), not( result( _, LID, line_buyers_order_number, _ ) ), not( result( _, LID, line_type, _ ) ) ) ).
line_level_scenario( `27`, `Missing Quantity Unit of Measure`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Quantity Unit of Measure`, `No`, `No`, `Missing Quantity Unit of Measure`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `27_Missing Quantity Unit of Measure`, LID), not( result( _, LID, line_quantity_uom_code, _ ) ) ) ).
line_level_scenario( `42`, `Quantity Times Unit Amount Not Equal to Net Amount`, `No`, `No`, `Process As Normal`, ``, `The quantity times the unit price is not equal to the net price for lines <data>Quantity Times Unit Amount Not Equal to Net Amount Occurred At Lines</data>.`, `No`, `No`, `Quantity Times Unit Amount Not Equal to Net Amount`, `Yes`, `Yes`, ( grammar_set(`testing_document_scenario`, `42_Quantity Times Unit Amount Not Equal to Net Amount`, LID), not( grammar_set(qty_no_error) ), i_error_quantity_and_unit_and_net_amounts_inconsistent( LID, `0.05` ) ) ).
line_level_scenario( `43`, `Quantity Times Unit Amount Not Equal to Net Amount (Qty No Error)`, `No`, `No`, `Process As Normal`, ``, `The quantity times the unit price is not equal to the net price for lines <data>Quantity Times Unit Amount Not Equal to Net Amount (Qty No Error) Not Equal to Net Amount Occurred At Lines</data>.`, `No`, `No`, `Quantity Times Unit Amount Not Equal to Net Amount`, `Yes`, `Yes`, ( grammar_set(`testing_document_scenario`, `43_Quantity Times Unit Amount Not Equal to Net Amount (Qty No Error)`, LID), grammar_set(qty_no_error), i_error_quantity_and_unit_and_net_amounts_inconsistent( LID, `1` ) ) ).
line_level_scenario( `53`, `Zero Value Line`, `No`, `No`, `Suppress Output of Zero Value Lines`, ``, `The following lines are zero value: <data>Zero Value Line At Lines</data>.`, `No`, `No`, `Zero Value Line`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `53_Zero Value Line`, LID), i_error_zero_value_line( LID ) ) ).


% Document scenario inherited from Taulia
line_level_scenario( `17`, `Missing Description`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Description`, `No`, `No`, `Missing Description`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `17_Missing Description`, LID), not( result( _, LID, line_descr, _ ) ) ) ).
line_level_scenario( `26`, `Missing Quantity`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Quantity`, `No`, `No`, `Missing Quantity`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `26_Missing Quantity`, LID), not( result( _, LID, line_quantity, _ ) ) ) ).
line_level_scenario( `33`, `Missing Unit Price`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Unit Price`, `No`, `No`, `Missing Unit Price`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `33_Missing Unit Price`, LID), not( result( _, LID, line_unit_amount, _ ) ) ) ).
line_level_scenario( `34`, `Negative Quantity`, `Yes`, `No`, `Return to Sender`, ``, `Please note that the invoice contains negative quantity.`, `No`, `No`, `Negative Quantity`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `34_Negative Quantity`, LID), grammar_set( negative_qty, LID ) ) ).
line_level_scenario( `35`, `Negative Unit Price`, `Yes`, `No`, `Return to Sender`, ``, `Please note that the invoice contains negative unit price.`, `No`, `No`, `Negative Unit Price`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `35_Negative Unit Price`, LID), grammar_set( negative_unit_price, LID ) ) ).
line_level_scenario( `50`, `Zero Quantity`, `Yes`, `No`, `Return to Sender`, ``, `Please note that the invoice contains zero quantity.`, `No`, `No`, `Zero Quantity`, `Yes`, `Yes`, ( grammar_set(`testing_document_scenario`, `50_Zero Quantity`, LID), grammar_set( zero_qty, LID ) ) ).
line_level_scenario( `51`, `Zero Unit Price`, `Yes`, `No`, `Return to Sender`, ``, `Please note that the invoice contains zero unit price.`, `No`, `No`, `Zero Unit Price`, `Yes`, `Yes`, ( grammar_set(`testing_document_scenario`, `51_Zero Unit Price`, LID), grammar_set( zero_unit_price , LID ) ) ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LOOKUPS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-----------------------------------------------------------------------
% Connection Lookup
%-----------------------------------------------------------------------

%-----------------------------------------------------------------------
% Sender Name Lookup (Inherited)
%-----------------------------------------------------------------------
:- multifile sender_name_lookup/2.
sender_name_lookup( `macmall`, `MacMall` ).
sender_name_lookup( `quickbooks`, `Quickbooks` ).
sender_name_lookup( `akoni kama`, `AKoni Kama` ).
sender_name_lookup( `high performance coaching`, `High Performance Coaching` ).
sender_name_lookup( `us foods`, `US Foods Inc.` ).
sender_name_lookup( `authentic connections`, `Authentic Connections Inc.` ).
sender_name_lookup( `anthem systems`, `Anthem Systems Integration LLC` ).
sender_name_lookup( `best models`, `Best Agency` ).
sender_name_lookup( `zone solutions`, `Zone Solutions` ).
sender_name_lookup( `dayzad law`, `Dayzad Law Offices P.C.` ).
sender_name_lookup( `fred bakht`, `Fred Bakht M.D.` ).
sender_name_lookup( `certex`, `Certex` ).
sender_name_lookup( `avis`, `Avis Rent A Car Systems Inc.` ).
sender_name_lookup( `crane`, `Crane Worldwide Logistics LLC` ).
sender_name_lookup( `taulia invoice`, `Taulia Invoice` ).
sender_name_lookup( `charter supply co`, `Carter Supply Company` ).
sender_name_lookup( `murphy shipping`, `Murphy Shipping and Commercial Services Inc.` ).
sender_name_lookup( `excelsior transport`, `Excelsior Transportation Inc.` ).
sender_name_lookup( `harris caprock`, `Harris CapRock Communications Inc.` ).
sender_name_lookup( `art catering`, `Art Catering Inc.` ).
sender_name_lookup( `med apparel services`, `Med-Apparel Services Inc.` ).
sender_name_lookup( `international medicine pd`, `International Medicine Center` ).
sender_name_lookup( `gap wireless`, `Gap Wireless` ).
sender_name_lookup( `intergraph`, `Intergraph Canada Ltd.` ).
sender_name_lookup( `hufco`, `HUFCO` ).
sender_name_lookup( `lowen`, `Lowen Corporation` ).
sender_name_lookup( `taulia inc`, `Taulia Inc.` ).
sender_name_lookup( `falck safety services`, `Falck Safety Services` ).
sender_name_lookup( `tanks a lot`, `Tanks-A-Lot Inc.` ).
sender_name_lookup( `abcam`, `Abcam Inc.` ).
sender_name_lookup( `garfunkel`, `Garfunkel Wild P.C.` ).
sender_name_lookup( `sonesta es suites`, `Sonesta Es Suites` ).
sender_name_lookup( `sam weiss woodworking`, `Sam Weiss` ).
sender_name_lookup( `worldwide oilfield machine`, `Worldwide Oilfield` ).
sender_name_lookup( `international sos`, `International SOS` ).

%-----------------------------------------------------------------------
% Taulia QA Lookup (Inherited)
%-----------------------------------------------------------------------
:- multifile taulia_qa_lookup/1.
taulia_qa_lookup( `costco_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `adient_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `agilent_qa7_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `ahnqa7.invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-pdfinbox@inboxbytaulia.com` ).
taulia_qa_lookup( `airbus_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `airbus_defence_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `airgas_qa7_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `qe2_americanwater@inboxbytaulia.com` ).
taulia_qa_lookup( `test_americanwater@inboxbytaulia.com` ).
taulia_qa_lookup( `ardaghgroup_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `bacardi_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `bioradinvoices-dev@taulia.com` ).
taulia_qa_lookup( `bioradinvoices-e1q@inboxbytaulia.com` ).
taulia_qa_lookup( `bioradinvoices-e2d@inboxbytaulia.com` ).
taulia_qa_lookup( `biorad_e2q_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `bioradinvoices-dev@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_bginvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_nlinvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_frinvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_noinvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_gbinvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_seinvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_beinvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_luxinvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cokecce_qas_usinvoices@inboxbytaulia.com` ).
taulia_qa_lookup( `ccep_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `test-cchmc.invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `coca_cola_tccc_q08_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `colgate_apac_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `colgate_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `cooper_machinery_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1003@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1009@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1028@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1035@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1040@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1046@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1102@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1500@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1530@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1600@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1660@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1004@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1010@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1030@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1037@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1042@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1047@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1103@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1510@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1540@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1610@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices2001@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1007@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1012@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1031@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1038@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1043@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1050@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1104@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1515@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1550@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1630@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1002@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1008@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1019@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1034@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1039@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1044@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1101@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1105@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1520@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1560@inboxbytaulia.com` ).
taulia_qa_lookup( `qa-dfainvoices1650@inboxbytaulia.com` ).
taulia_qa_lookup( `psinvoices_qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `dominion_qa7_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `eastsussex_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `eisai_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `ericssonpoinvoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `evoquainvoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `general_mills_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `general_mills_iet_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `general_mills_int_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `gpiinvoice-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `halliburtoninvoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `halliburtoninvoices-dev@inboxbytaulia.com` ).
taulia_qa_lookup( `halliburtoninvoices-qa_fhl@inboxbytaulia.com` ).
taulia_qa_lookup( `hallmarkinvoicesqa@inboxbytaulia.com` ).
taulia_qa_lookup( `henkelinvoicesr92@inboxbytaulia.com` ).
taulia_qa_lookup( `henkelinvoicesc68@inboxbytaulia.com` ).
taulia_qa_lookup( `henkelinvoicesq72@inboxbytaulia.com` ).
taulia_qa_lookup( `hds_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `hondainvoices-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_pfx1_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_gb01@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_gb02@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_at01@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_cz01@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_sk11@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_be16@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_nl11@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_ch01@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_fr01@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_dk01@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_no01@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_se02@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_es05@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_pt01@inboxbytaulia.com` ).
taulia_qa_lookup( `honda_eu_qa_invoices_pl01@inboxbytaulia.com` ).
taulia_qa_lookup( `test_hubbell@inboxbytaulia.com` ).
taulia_qa_lookup( `hydrooneinvoices-sec@inboxbytaulia.com` ).
taulia_qa_lookup( `hydrooneremotesinvoices-sec@inboxbytaulia.com` ).
taulia_qa_lookup( `hydroonetelecominvoices-sec@inboxbytaulia.com` ).
taulia_qa_lookup( `keystonefoods_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `kimberly-clark_da4@inboxbytaulia.com` ).
taulia_qa_lookup( `kimberly-clark_qa4@inboxbytaulia.com` ).
taulia_qa_lookup( `kimberly_clark_emea_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `kimberly_clark_apac_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `laminvoicesqas@inboxbytaulia.com` ).
taulia_qa_lookup( `leprinofoods_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `mahle_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `mskinvoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `millikeninvoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `nissan-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `ncesi-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `nissancanada-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `ncfs-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `nmac-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `nesna-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `ntcna-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `esend-pd@taulia.com` ).
taulia_qa_lookup( `pacific_gas_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `premierfoodsinvoicesecr@inboxbytaulia.com` ).
taulia_qa_lookup( `qa7-ps18003000@taulia.com` ).
taulia_qa_lookup( `publix-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `publix-dev@inboxbytaulia.com` ).
taulia_qa_lookup( `px1900@inboxbytaulia.com` ).
taulia_qa_lookup( `qa7-pdfinbox@taulia.com` ).
taulia_qa_lookup( `qe500-pdfinbox@taulia.com` ).
taulia_qa_lookup( `qehotfix@inboxbytaulia.com` ).
taulia_qa_lookup( `qetest-blue-pdfinbox@taulia.com` ).
taulia_qa_lookup( `qetest-green-pdfinbox@taulia.com` ).
taulia_qa_lookup( `rbs.test.invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `rbmh.invoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `rbacademy.invoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `rbna.invoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `rbarena.invoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `rbny.invoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `rbdc.invoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `rbrecords.invoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `sempra_energy_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `sentarainvoices-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `sephoracaninvoices-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `sephorausinvoices-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `silgan_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `southerncoinvoices.qa@inboxbytaulia.com` ).
taulia_qa_lookup( `zoolander-esend@inboxbytaulia.com` ).
taulia_qa_lookup( `stadtwerke_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `pdf.inbox@inboxbytaulia.com` ).
taulia_qa_lookup( `tds_dev_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `tds_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `tds_qa7_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `telusinvoices-sq1@inboxbytaulia.com` ).
taulia_qa_lookup( `tbx_invoices_qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `tema-qa7@inboxbytaulia.com` ).
taulia_qa_lookup( `transalta_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `tysoninvoices-qa@inboxbytaulia.com` ).
taulia_qa_lookup( `tyson_s4_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `ula_qa_invoices@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_gr_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_nl_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_cz_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_hu_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_nz_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_de_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_ir_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_ro_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_es_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_lu_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_uk_qa@inboxbytaulia.com` ).
taulia_qa_lookup( `vodafone_invoices_de_qe1@inboxbytaulia.com` ).
taulia_qa_lookup( `weenergies-qa@inboxbytaulia.com` ).

%-----------------------------------------------------------------------
% Taulia UOM Code (Inherited)
%-----------------------------------------------------------------------
:- multifile taulia_uom_code/2.
taulia_uom_code( `AU`, `AU` ).
taulia_uom_code( `AT`, `AT` ).
taulia_uom_code( `BOX`, `BX` ).
taulia_uom_code( `BX`, `BX` ).
taulia_uom_code( `BT`, `BT` ).
taulia_uom_code( `BG`, `BG` ).
taulia_uom_code( `CS`, `CS` ).
taulia_uom_code( `CAE`, `CAE` ).
taulia_uom_code( `CSE`, `CSE` ).
taulia_uom_code( `CT`, `CT` ).
taulia_uom_code( `CYL`, `CYL` ).
taulia_uom_code( `C62 (ONE)`, `C62` ).
taulia_uom_code( `C62`, `C62` ).
taulia_uom_code( `DAY`, `DAY` ).
taulia_uom_code( `DR`, `DR` ).
taulia_uom_code( `EACH`, `EA` ).
taulia_uom_code( `EH`, `EH` ).
taulia_uom_code( `FT`, `FOT` ).
taulia_uom_code( `FT_US`, `FT` ).
taulia_uom_code( `SQFT`, `FTK` ).
taulia_uom_code( `GM`, `GM` ).
taulia_uom_code( `GA`, `GLL` ).
taulia_uom_code( `GAL`, `GLL` ).
taulia_uom_code( `GAL_EV`, `GAL` ).
taulia_uom_code( `H`, `H` ).
taulia_uom_code( `HR`, `HUR` ).
taulia_uom_code( `HUR`, `HUR` ).
taulia_uom_code( `HOURS`, `HUR` ).
taulia_uom_code( `HR_US`, `HR` ).
taulia_uom_code( `JOB`, `JOB` ).
taulia_uom_code( `KG`, `KG` ).
taulia_uom_code( `KGM`, `KGM` ).
taulia_uom_code( `KM`, `KMT` ).
taulia_uom_code( `LE`, `LE` ).
taulia_uom_code( `LB`, `LB` ).
taulia_uom_code( `LBR`, `LBR` ).
taulia_uom_code( `LTR`, `LTR` ).
taulia_uom_code( `LOT`, `LOT` ).
taulia_uom_code( `M`, `MTR` ).
taulia_uom_code( `MT`, `MTR` ).
taulia_uom_code( `MTR`, `MTR` ).
taulia_uom_code( `MT_PF`, `MT` ).
taulia_uom_code( `MTK`, `MTK` ).
taulia_uom_code( `MIL`, `MIL` ).
taulia_uom_code( `MR`, `M` ).
taulia_uom_code( `MSF`, `MSF` ).
taulia_uom_code( `MTQ`, `MTQ` ).
taulia_uom_code( `Month`, `MON` ).
taulia_uom_code( `MON`, `MON` ).
taulia_uom_code( `STN`, `NS` ).
taulia_uom_code( `PK`, `PK` ).
taulia_uom_code( `PR`, `PR` ).
taulia_uom_code( `PRE`, `PRE` ).
taulia_uom_code( `P1`, `P1` ).
taulia_uom_code( `PC`, `PC` ).
taulia_uom_code( `PIECE`, `PC` ).
taulia_uom_code( `PCE`, `PCE` ).
taulia_uom_code( `PZ`, `PCE` ).
taulia_uom_code( `PCS`, `PCS` ).
taulia_uom_code( `PAK`, `PAC` ).
taulia_uom_code( `PAA`, `PAA` ).
taulia_uom_code( `PAL`, `PAL` ).
taulia_uom_code( `PA`, `PA` ).
taulia_uom_code( `RL`, `RL` ).
taulia_uom_code( `ROLL`, `RL` ).
taulia_uom_code( `ROL`, `RL` ).
taulia_uom_code( `ST`, `ST` ).
taulia_uom_code( `STK`, `STK` ).
taulia_uom_code( `SU`, `SU` ).
taulia_uom_code( `STN_US`, `STN` ).
taulia_uom_code( `TN`, `TN` ).
taulia_uom_code( `STO`, `STO` ).
taulia_uom_code( `SRV`, `SRV` ).
taulia_uom_code( `TE`, `TE` ).
taulia_uom_code( `TO`, `TO` ).
taulia_uom_code( `TON`, `TON` ).
taulia_uom_code( `TNE`, `TNE` ).
taulia_uom_code( `USG`, `USG` ).
taulia_uom_code( `UNI`, `UNI` ).
taulia_uom_code( `WU`, `WU` ).
taulia_uom_code( `10`, `10` ).

%-----------------------------------------------------------------------
% Valid Taulia Country Code (Inherited)
%-----------------------------------------------------------------------
:- multifile valid_taulia_country_code/2.
valid_taulia_country_code( `afghanistan`, `AF` ).
valid_taulia_country_code( `albania`, `AL` ).
valid_taulia_country_code( `algeria`, `DZ` ).
valid_taulia_country_code( `andorra`, `AD` ).
valid_taulia_country_code( `angola`, `AO` ).
valid_taulia_country_code( `antigua and barbuda`, `AG` ).
valid_taulia_country_code( `argentina`, `AR` ).
valid_taulia_country_code( `armenia`, `AM` ).
valid_taulia_country_code( `australia`, `AU` ).
valid_taulia_country_code( `austria`, `AT` ).
valid_taulia_country_code( `azerbaijan`, `AZ` ).
valid_taulia_country_code( `bahamas, the`, `BS` ).
valid_taulia_country_code( `bahrain`, `BH` ).
valid_taulia_country_code( `bangladesh`, `BD` ).
valid_taulia_country_code( `barbados`, `BB` ).
valid_taulia_country_code( `belarus`, `BY` ).
valid_taulia_country_code( `belgium`, `BE` ).
valid_taulia_country_code( `belize`, `BZ` ).
valid_taulia_country_code( `benin`, `BJ` ).
valid_taulia_country_code( `bhutan`, `BT` ).
valid_taulia_country_code( `bolivia`, `BO` ).
valid_taulia_country_code( `bosnia and herzegovina`, `BA` ).
valid_taulia_country_code( `botswana`, `BW` ).
valid_taulia_country_code( `brazil`, `BR` ).
valid_taulia_country_code( `brunei`, `BN` ).
valid_taulia_country_code( `bulgaria`, `BG` ).
valid_taulia_country_code( `burkina faso`, `BF` ).
valid_taulia_country_code( `burundi`, `BI` ).
valid_taulia_country_code( `cambodia`, `KH` ).
valid_taulia_country_code( `cameroon`, `CM` ).
valid_taulia_country_code( `canada`, `CA` ).
valid_taulia_country_code( `cape verde`, `CV` ).
valid_taulia_country_code( `central african republic`, `CF` ).
valid_taulia_country_code( `chad`, `TD` ).
valid_taulia_country_code( `chile`, `CL` ).
valid_taulia_country_code( `china, people's republic of`, `CN` ).
valid_taulia_country_code( `colombia`, `CO` ).
valid_taulia_country_code( `comoros`, `KM` ).
valid_taulia_country_code( `congo, (congo kinshasa)`, `CD` ).
valid_taulia_country_code( `congo, (congo brazzaville)`, `CG` ).
valid_taulia_country_code( `costa rica`, `CR` ).
valid_taulia_country_code( `cote d'ivoire (ivory coast)`, `CI` ).
valid_taulia_country_code( `croatia`, `HR` ).
valid_taulia_country_code( `cuba`, `CU` ).
valid_taulia_country_code( `cyprus`, `CY` ).
valid_taulia_country_code( `czech republic`, `CZ` ).
valid_taulia_country_code( `denmark`, `DK` ).
valid_taulia_country_code( `djibouti`, `DJ` ).
valid_taulia_country_code( `dominica`, `DM` ).
valid_taulia_country_code( `dominican republic`, `DO` ).
valid_taulia_country_code( `ecuador`, `EC` ).
valid_taulia_country_code( `egypt`, `EG` ).
valid_taulia_country_code( `el salvador`, `SV` ).
valid_taulia_country_code( `equatorial guinea`, `GQ` ).
valid_taulia_country_code( `eritrea`, `ER` ).
valid_taulia_country_code( `estonia`, `EE` ).
valid_taulia_country_code( `ethiopia`, `ET` ).
valid_taulia_country_code( `fiji`, `FJ` ).
valid_taulia_country_code( `finland`, `FI` ).
valid_taulia_country_code( `france`, `FR` ).
valid_taulia_country_code( `gabon`, `GA` ).
valid_taulia_country_code( `gambia, the`, `GM` ).
valid_taulia_country_code( `georgia`, `GE` ).
valid_taulia_country_code( `germany`, `DE` ).
valid_taulia_country_code( `ghana`, `GH` ).
valid_taulia_country_code( `greece`, `GR` ).
valid_taulia_country_code( `grenada`, `GD` ).
valid_taulia_country_code( `guatemala`, `GT` ).
valid_taulia_country_code( `guinea`, `GN` ).
valid_taulia_country_code( `guinea-bissau`, `GW` ).
valid_taulia_country_code( `guyana`, `GY` ).
valid_taulia_country_code( `haiti`, `HT` ).
valid_taulia_country_code( `honduras`, `HN` ).
valid_taulia_country_code( `hungary`, `HU` ).
valid_taulia_country_code( `iceland`, `IS` ).
valid_taulia_country_code( `india`, `IN` ).
valid_taulia_country_code( `indonesia`, `ID` ).
valid_taulia_country_code( `iran`, `IR` ).
valid_taulia_country_code( `iraq`, `IQ` ).
valid_taulia_country_code( `ireland`, `IE` ).
valid_taulia_country_code( `israel`, `IL` ).
valid_taulia_country_code( `italy`, `IT` ).
valid_taulia_country_code( `jamaica`, `JM` ).
valid_taulia_country_code( `japan`, `JP` ).
valid_taulia_country_code( `jordan`, `JO` ).
valid_taulia_country_code( `kazakhstan`, `KZ` ).
valid_taulia_country_code( `kenya`, `KE` ).
valid_taulia_country_code( `kiribati`, `KI` ).
valid_taulia_country_code( `korea, north`, `KP` ).
valid_taulia_country_code( `korea, south`, `KR` ).
valid_taulia_country_code( `kuwait`, `KW` ).
valid_taulia_country_code( `kyrgyzstan`, `KG` ).
valid_taulia_country_code( `laos`, `LA` ).
valid_taulia_country_code( `latvia`, `LV` ).
valid_taulia_country_code( `lebanon`, `LB` ).
valid_taulia_country_code( `lesotho`, `LS` ).
valid_taulia_country_code( `liberia`, `LR` ).
valid_taulia_country_code( `libya`, `LY` ).
valid_taulia_country_code( `liechtenstein`, `LI` ).
valid_taulia_country_code( `lithuania`, `LT` ).
valid_taulia_country_code( `luxembourg`, `LU` ).
valid_taulia_country_code( `macedonia`, `MK` ).
valid_taulia_country_code( `madagascar`, `MG` ).
valid_taulia_country_code( `malawi`, `MW` ).
valid_taulia_country_code( `malaysia`, `MY` ).
valid_taulia_country_code( `maldives`, `MV` ).
valid_taulia_country_code( `mali`, `ML` ).
valid_taulia_country_code( `malta`, `MT` ).
valid_taulia_country_code( `marshall islands`, `MH` ).
valid_taulia_country_code( `mauritania`, `MR` ).
valid_taulia_country_code( `mauritius`, `MU` ).
valid_taulia_country_code( `mexico`, `MX` ).
valid_taulia_country_code( `micronesia`, `FM` ).
valid_taulia_country_code( `moldova`, `MD` ).
valid_taulia_country_code( `monaco`, `MC` ).
valid_taulia_country_code( `mongolia`, `MN` ).
valid_taulia_country_code( `montenegro`, `ME` ).
valid_taulia_country_code( `morocco`, `MA` ).
valid_taulia_country_code( `mozambique`, `MZ` ).
valid_taulia_country_code( `myanmar (burma)`, `MM` ).
valid_taulia_country_code( `namibia`, `NA` ).
valid_taulia_country_code( `nauru`, `NR` ).
valid_taulia_country_code( `nepal`, `NP` ).
valid_taulia_country_code( `netherlands`, `NL` ).
valid_taulia_country_code( `new zealand`, `NZ` ).
valid_taulia_country_code( `nicaragua`, `NI` ).
valid_taulia_country_code( `niger`, `NE` ).
valid_taulia_country_code( `nigeria`, `NG` ).
valid_taulia_country_code( `norway`, `NO` ).
valid_taulia_country_code( `oman`, `OM` ).
valid_taulia_country_code( `pakistan`, `PK` ).
valid_taulia_country_code( `palau`, `PW` ).
valid_taulia_country_code( `panama`, `PA` ).
valid_taulia_country_code( `papua new guinea`, `PG` ).
valid_taulia_country_code( `paraguay`, `PY` ).
valid_taulia_country_code( `peru`, `PE` ).
valid_taulia_country_code( `philippines`, `PH` ).
valid_taulia_country_code( `poland`, `PL` ).
valid_taulia_country_code( `portugal`, `PT` ).
valid_taulia_country_code( `qatar`, `QA` ).
valid_taulia_country_code( `romania`, `RO` ).
valid_taulia_country_code( `russia`, `RU` ).
valid_taulia_country_code( `rwanda`, `RW` ).
valid_taulia_country_code( `saint kitts and nevis`, `KN` ).
valid_taulia_country_code( `saint lucia`, `LC` ).
valid_taulia_country_code( `saint vincent and the grenadines`, `VC` ).
valid_taulia_country_code( `samoa`, `WS` ).
valid_taulia_country_code( `san marino`, `SM` ).
valid_taulia_country_code( `sao tome and principe`, `ST` ).
valid_taulia_country_code( `saudi arabia`, `SA` ).
valid_taulia_country_code( `senegal`, `SN` ).
valid_taulia_country_code( `serbia`, `RS` ).
valid_taulia_country_code( `seychelles`, `SC` ).
valid_taulia_country_code( `sierra leone`, `SL` ).
valid_taulia_country_code( `singapore`, `SG` ).
valid_taulia_country_code( `slovakia`, `SK` ).
valid_taulia_country_code( `slovenia`, `SI` ).
valid_taulia_country_code( `solomon islands`, `SB` ).
valid_taulia_country_code( `somalia`, `SO` ).
valid_taulia_country_code( `south africa`, `ZA` ).
valid_taulia_country_code( `spain`, `ES` ).
valid_taulia_country_code( `sri lanka`, `LK` ).
valid_taulia_country_code( `sudan`, `SD` ).
valid_taulia_country_code( `suriname`, `SR` ).
valid_taulia_country_code( `swaziland`, `SZ` ).
valid_taulia_country_code( `sweden`, `SE` ).
valid_taulia_country_code( `switzerland`, `CH` ).
valid_taulia_country_code( `syria`, `SY` ).
valid_taulia_country_code( `tajikistan`, `TJ` ).
valid_taulia_country_code( `tanzania`, `TZ` ).
valid_taulia_country_code( `thailand`, `TH` ).
valid_taulia_country_code( `timor-leste (east timor)`, `TL` ).
valid_taulia_country_code( `togo`, `TG` ).
valid_taulia_country_code( `tonga`, `TO` ).
valid_taulia_country_code( `trinidad and tobago`, `TT` ).
valid_taulia_country_code( `tunisia`, `TN` ).
valid_taulia_country_code( `turkey`, `TR` ).
valid_taulia_country_code( `turkmenistan`, `TM` ).
valid_taulia_country_code( `tuvalu`, `TV` ).
valid_taulia_country_code( `uganda`, `UG` ).
valid_taulia_country_code( `ukraine`, `UA` ).
valid_taulia_country_code( `united arab emirates`, `AE` ).
valid_taulia_country_code( `united kingdom`, `GB` ).
valid_taulia_country_code( `united states`, `US` ).
valid_taulia_country_code( `uruguay`, `UY` ).
valid_taulia_country_code( `uzbekistan`, `UZ` ).
valid_taulia_country_code( `vanuatu`, `VU` ).
valid_taulia_country_code( `vatican city`, `VA` ).
valid_taulia_country_code( `venezuela`, `VE` ).
valid_taulia_country_code( `vietnam`, `VN` ).
valid_taulia_country_code( `yemen`, `YE` ).
valid_taulia_country_code( `zambia`, `ZM` ).
valid_taulia_country_code( `zimbabwe`, `ZW` ).
valid_taulia_country_code( `abkhazia`, `GE` ).
valid_taulia_country_code( `china, republic of (taiwan)`, `TW` ).
valid_taulia_country_code( `nagorno-karabakh`, `AZ` ).
valid_taulia_country_code( `northern cyprus`, `CY` ).
valid_taulia_country_code( `pridnestrovie (transnistria)`, `MD` ).
valid_taulia_country_code( `somaliland`, `SO` ).
valid_taulia_country_code( `south ossetia`, `GE` ).
valid_taulia_country_code( `ashmore and cartier islands`, `AU` ).
valid_taulia_country_code( `christmas island`, `CX` ).
valid_taulia_country_code( `cocos (keeling) islands`, `CC` ).
valid_taulia_country_code( `coral sea islands`, `AU` ).
valid_taulia_country_code( `heard island and mcdonald islands`, `HM` ).
valid_taulia_country_code( `norfolk island`, `NF` ).
valid_taulia_country_code( `new caledonia`, `NC` ).
valid_taulia_country_code( `french polynesia`, `PF` ).
valid_taulia_country_code( `mayotte`, `YT` ).
valid_taulia_country_code( `saint barthelemy`, `GP` ).
valid_taulia_country_code( `saint martin`, `GP` ).
valid_taulia_country_code( `saint pierre and miquelon`, `PM` ).
valid_taulia_country_code( `wallis and futuna`, `WF` ).
valid_taulia_country_code( `french southern and antarctic lands`, `TF` ).
valid_taulia_country_code( `clipperton island`, `PF` ).
valid_taulia_country_code( `bouvet island`, `BV` ).
valid_taulia_country_code( `cook islands`, `CK` ).
valid_taulia_country_code( `niue`, `NU` ).
valid_taulia_country_code( `tokelau`, `TK` ).
valid_taulia_country_code( `guernsey`, `GG` ).
valid_taulia_country_code( `isle of man`, `IM` ).
valid_taulia_country_code( `jersey`, `JE` ).
valid_taulia_country_code( `anguilla`, `AI` ).
valid_taulia_country_code( `bermuda`, `BM` ).
valid_taulia_country_code( `british indian ocean territory`, `IO` ).
valid_taulia_country_code( `british sovereign base areas`, `` ).
valid_taulia_country_code( `british virgin islands`, `VG` ).
valid_taulia_country_code( `cayman islands`, `KY` ).
valid_taulia_country_code( `falkland islands (islas malvinas)`, `FK` ).
valid_taulia_country_code( `gibraltar`, `GI` ).
valid_taulia_country_code( `montserrat`, `MS` ).
valid_taulia_country_code( `pitcairn islands`, `PN` ).
valid_taulia_country_code( `saint helena`, `SH` ).
valid_taulia_country_code( `south georgia & south sandwich islands`, `GS` ).
valid_taulia_country_code( `turks and caicos islands`, `TC` ).
valid_taulia_country_code( `northern mariana islands`, `MP` ).
valid_taulia_country_code( `puerto rico`, `PR` ).
valid_taulia_country_code( `american samoa`, `AS` ).
valid_taulia_country_code( `baker island`, `UM` ).
valid_taulia_country_code( `guam`, `GU` ).
valid_taulia_country_code( `howland island`, `UM` ).
valid_taulia_country_code( `jarvis island`, `UM` ).
valid_taulia_country_code( `johnston atoll`, `UM` ).
valid_taulia_country_code( `kingman reef`, `UM` ).
valid_taulia_country_code( `midway islands`, `UM` ).
valid_taulia_country_code( `navassa island`, `UM` ).
valid_taulia_country_code( `palmyra atoll`, `UM` ).
valid_taulia_country_code( `u.s. virgin islands`, `VI` ).
valid_taulia_country_code( `wake island`, `UM` ).
valid_taulia_country_code( `hong kong`, `HK` ).
valid_taulia_country_code( `macau`, `MO` ).
valid_taulia_country_code( `faroe islands`, `FO` ).
valid_taulia_country_code( `greenland`, `GL` ).
valid_taulia_country_code( `french guiana`, `GF` ).
valid_taulia_country_code( `guadeloupe`, `GP` ).
valid_taulia_country_code( `martinique`, `MQ` ).
valid_taulia_country_code( `reunion`, `RE` ).
valid_taulia_country_code( `aland`, `AX` ).
valid_taulia_country_code( `aruba`, `AW` ).
valid_taulia_country_code( `netherlands antilles`, `AN` ).
valid_taulia_country_code( `svalbard`, `SJ` ).
valid_taulia_country_code( `ascension`, `AC` ).
valid_taulia_country_code( `tristan da cunha`, `TA` ).
valid_taulia_country_code( `australian antarctic territory`, `AQ` ).
valid_taulia_country_code( `ross dependency`, `AQ` ).
valid_taulia_country_code( `peter i island`, `AQ` ).
valid_taulia_country_code( `queen maud land`, `AQ` ).
valid_taulia_country_code( `british antarctic territory`, `AQ` ).
