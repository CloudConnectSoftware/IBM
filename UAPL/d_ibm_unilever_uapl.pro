%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - D_IBM_UNILEVER_UAPL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( d_ibm_unilever_uapl, `02/10/2023 15:03:02` ).

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
header_level_item( `IBM DC XML`, `Invoice Type`, `Yes`, `Insert 'INV' for invoices that haven't mapped a valid PO and Vendor appears in the NPNP list, 'CN' for credit notes (credit_note flag must be set), 'CO' for debit notes (debit_note flag must be set) and 'INVPO' otherwise.`, `Set credit_note flag for credit notes, debit_note flag for debit notes, in rules. Everything else automated by p_ file.`, `Always`, ``, `p_ (Hard Coded)`, `invoice_type`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Document Date`, `Yes`, `Map invoice date from document.`, `Map invoice date from document.`, `Always`, ``, `Rules (Mapped)`, `invoice_date`, `Date`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Company Code`, `Yes`, `Map from invoice, otherwise match the purchase order number against the PO header file, to insert the correct company code. If not default to '3009'.`, `Map from invoice, everything else automated by p_ file.`, `Always`, ``, `Both Rules & p_`, `buyer_registration_number`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Plant Code`, `Yes`, `Insert '0000'.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `plant_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Invoice Number`, `Yes`, `Map invoice number from document.`, `Map invoice number from document.`, `Always`, ``, `Rules (Mapped)`, `invoice_number`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Total Amount`, `Yes`, `Map total gross amount from document.`, `Map total gross amount from document.`, `Conditional`, `Vendor is not a freight vendor.`, `Rules (Mapped)`, `total_invoice`, `Number`, `1`, `No`, `Header Level Items`, `6`, ( not( grammar_set( freight_vendor ) ) ), ( true ) ).
header_level_item( `IBM DC XML`, `Tax Amount`, `Yes`, `Map total tax amount from document.`, `Map total tax amount from document.`, `Always`, ``, `Rules (Mapped)`, `total_vat`, `Number`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Currency Code`, `Yes`, `Map currency from invoice, if in words etc must be in converted into ISO standard format. If not present on invoice then default to 'USD', Leocatas hard coded to 'AUD'.`, `Map currency from invoice, if in words etc must be in converted into ISO standard format. If not present on invoice then default to 'USD', Leocatas hard coded to 'AUD'.`, `Always`, ``, `Rules (Mapped)`, `currency`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Due Date`, `Yes`, `Map due date from invoice. Set to default date if not present.`, `Map due date from invoice. Setting to default date if not present automated by p_ file.`, `Never`, ``, `Both Rules & p_`, `due_date`, `Date`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Vendor ID`, `Yes`, `Insert vendor's ID, can be found on tab 1 of SDD. Must be padded out to 10 characters with leading zeros.`, `Automated by p_ file, once rules file name updated on connections tab and in d_ file.`, `Always`, ``, `p_ (Hard Coded)`, `buyers_code_for_supplier`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Vendor VAT Code`, `Yes`, `Map vendor's VAT registration number from document.`, `Map vendor's VAT registration number from document.`, `Conditional`, `Mandatory if VAT amount is non-zero.`, `Rules (Mapped)`, `supplier_vat_number`, `String`, `1`, `No`, `Header Level Items`, `6`, ( i_error_vat_without_vat_number ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer VAT Code`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `buyer_vat_number`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Scan ID`, `Yes`, `Insert YYYYMMDD_CTID, where YYYYMMDD is today's date and ID is a sequential unique ID.`, `Automated by p_ file.`, `Always`, ``, `p_ (Hard Coded)`, `scan_id`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Discount Percent`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `total_percent_discount`, `Number`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bank Account`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `supplier_bank_account_number`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bank Name`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `supplier_bank_name`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bank Code`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `supplier_bank_code`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bank SWIFT`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `supplier_bank_swift`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bank OGM`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `supplier_bank_ogm`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bank IBAN`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `supplier_bank_iban`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Payment Term`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `payment_terms`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Description`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `narrative`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Other Information`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `customer_comments`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Exchange Rate`, `Yes`, `Map exchange rate from document.`, `Map exchange rate from document.`, `Conditional`, `Tax Amount > 0 and the invoice is not in local currency Singapore Dollar (SGD).`, `Rules (Mapped)`, `exchange_rate`, `String`, `1`, `No`, `Header Level Items`, `6`, ( result( _, invoice, total_vat, VAT ), q_sys_comp_str_gt( VAT, `0` ), result( _, invoice, currency, CUR ), CUR \= SGD ), ( true ) ).
header_level_item( `IBM DC XML`, `ERP Ref Number`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `erp_ref_number`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `VAT Local Amount`, `Yes`, `Should be mapped if available.`, `Should be mapped if available.`, `Never`, ``, `Rules (Mapped)`, `total_local_vat`, `Number`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Discount Amount`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `total_discount`, `Number`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Tax Reporting Country`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `tax_reporting_country`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `VAT Region`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `vat_region`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Attention Of`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `attention_of`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `OB10 Link`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `ob10_link`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Payment Reference`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `payment_reference`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Date of Supply`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_date_of_supply`, `Date`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Name`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_name`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 1`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_1`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 2`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_2`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 3`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_3`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 4`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_4`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 5`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_5`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 6`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_6`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 7`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_7`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 8`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_8`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 9`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_9`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Address 10`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_address_10`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Name`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_name`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 1`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_1`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 2`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_2`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 3`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_3`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 4`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_4`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 5`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_5`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 6`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_6`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 7`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_7`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 8`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_8`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 9`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_9`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Fiscal Address 10`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_fiscal_address_10`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Name`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_name`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 1`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_1`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 2`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_2`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 3`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_3`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 4`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_4`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 5`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_5`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 6`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_6`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 7`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_7`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 8`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_8`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 9`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_9`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Buyer Address 10`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_buyer_address_10`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Net Amount`, `Yes`, `Map total net amount from document.`, `Map total net amount from document.`, `Always`, ``, `Rules (Mapped)`, `total_net`, `Number`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Description of Supply`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_line_var`, `String`, `1`, `No`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bill From`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `bill_from`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bill To`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `bill_to`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Bill Of Lading Number`, `Yes`, `Map from invoice.`, `Map from invoice.`, `Never`, ``, `Rules (Mapped)`, `bol_number`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Purchase Order Number`, `Yes`, `Map purchase order number from invoice. Must match order number from PO header file.`, `Map purchase order number from invoice`, `Never`, ``, `Rules (Mapped)`, `order_number`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `POR Reference`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `por_reference`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Ship From`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `ship_from`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Ship To`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `ship_to`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Supplier Country`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `swiss_supplier_country`, `String`, `1`, `Yes`, `Header Level Items`, `6`, ( true ), ( true ) ).

%-----------------------------------------------------------------------
% Header Level Functional Items
%-----------------------------------------------------------------------


% Not Inherited
header_level_item( `IBM DC XML`, `Sender Name`, `Yes`, `Insert name of sending organisation.Determines value of Sending Organisation.`, `Hard - code correct value in rules.`, `Always`, ``, `Rules (Hard Coded)`, `sender_name`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Sending Organisation`, `Yes`, `Insert name of sending organisation. Determines sender name in the portal.`, `Automated by u_portal_values. Same value as Sender Name is automatically inserted.`, `Always`, ``, `p_ (Hard Coded)`, `sending_organisation`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Receiving Organisation`, `Yes`, `Insert name of receiving organisation. Determines receiver name in the portal.`, `Automated by u_portal_values. Correct value is automatically inserted.`, `Always`, ``, `p_ (Hard Coded)`, `receiving_organisation`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Customer`, `Yes`, `Insert name of customer. Determines customer name in the portal.`, `Automated by u_portal_values. Correct value is automatically inserted.`, `Always`, ``, `p_ (Hard Coded)`, `customer`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Channel Partner`, `Yes`, `Insert name of channel partner. Determines channel partner name in the portal.`, `Automated by u_portal_values. Correct value is automatically inserted.`, `Always`, ``, `p_ (Hard Coded)`, `channel_partner`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Document Type`, `Yes`, `Insert correct document type. Determines document type in the portal.`, `Automated by p_. Defaults to "Credit Note" if credit_note flag has been set, Order" if purchase_order flag has been set, Invoice" otherwise.`, `Always`, ``, `p_ (Hard Coded)`, `document_type`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Return Email`, `Yes`, `Insert email address(es) for document to be returned to. Determines email addresses that document will be returned to if it is being returned to the sender.`, `Either map/hard-code in rules, or automated by u_insert_connection_codes. Value from connection list on SDD is automatically inserted. If not present, from address is inserted instead.`, `Never`, ``, `Both Rules & p_`, `return_email`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Forward Email`, `Yes`, `Insert email address(es) for document to be forwarded to. Determines email addresses that documents will be returned to if they are being forwarded to an email address.`, `Automated based on email address column in SDD when action is "Forward to Email Address". Can be overridden by an i_analyse_enquire_last in the p_ file.`, `Never`, ``, `Both Rules & p_`, `forward_email`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Intervention RTS Email`, `Yes`, `Insert email address(es) for document to be returned to, based on RTS button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on RTS button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_rts_email`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Intervention Forward Email`, `Yes`, `Insert email address(es) for document to be forwarded to, based on forward button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on forward button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_forward_email`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Intervention RTS Email Subject`, `Yes`, `Insert email subject based on RTS button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on RTS button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_rts_email_subject`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Intervention Forward Email Subject`, `Yes`, `Insert email subjcet based on forward button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on forward button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_forward_email_subject`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Intervention RTS Email Body`, `Yes`, `Insert email body based on RTS button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on RTS button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_rts_email_body`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Intervention Forward Email Body`, `Yes`, `Insert email body based on forward button selection from intervention.`, `Automated by u_intervention_analysis. Correct value is inserted based on forward button being pressed by user from intervention.`, `Never`, ``, `Both Rules & p_`, `intervention_forward_email_body`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Enquiry Role`, `Yes`, `Insert intervention role.`, `Automated by u_intervention_generation.`, `Never`, ``, `p_ (Hard Coded)`, `enquiry_role`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Error Name`, `Yes`, `For missing header level value insert "Missing [Data Item Name]", for missing line level value insert "Missing [Data Item Name] at lines [Missing Lines]", for invalid header level value insert "Invalid [Data Item Name]", for invalid line level value insert "Invalid[Data Item Name] at lines[Invalid Lines]", for header level scenarios insert "[Scenaio Name]", for line level sceanrios insert [Sceanrio Name] at lines [Scenario Lines]".If there are multiple errors, separate by commas.`, `Automated by u_error_detection_test.`, `Never`, ``, `p_ (Hard Coded)`, `error_name`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Error Description Text`, `Yes`, `Insert value from relevant error description text column on SDD. If there are multiple, separate with line breaks.`, `Automated by u_error_detection_test.`, `Never`, ``, `p_ (Hard Coded)`, `error_description_text`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Default VAT Rate`, `Yes`, `Map/insert default VAT rate.`, `Map in rules, otherwise automated by Gramatica.`, `Never`, ``, `Rules/Gramatica Derived`, `default_vat_rate`, `Number`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Pages Count`, `Yes`, `Insert number of pages of the document, otherwise insert 'PDF Error - No Page Count Available'.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `pages_count`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Force Result`, `Yes`, `To force portal status, insert 'success', 'failed' or 'defect'.`, `Mapped in rules or automated by junk.pro.`, `Never`, ``, `Both Rules & p_`, `force_result`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Force Sub Result`, `Yes`, `To force portal reason, insert relevant reason.`, `Mapped in rules or automated by junk.pro.`, `Never`, ``, `Both Rules & p_`, `force_sub_result`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Report Name`, `Yes`, `Insert 'Recon_Attachment0000.txt`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `report_name`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Rounding Amount`, `Yes`, `Map rounding amount from document, otherwise default to 0.`, `Map rounding amount from document. Everything else automated by p_ file.`, `Never`, ``, `Both Rules & p_`, `rounding_amount`, `String`, `1`, `Yes`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Transaction ID`, `Yes`, `Insert same value as Scan ID.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `customer_id`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Sender Name Text`, `Yes`, `If Sender Name is present, insert 'Vendor Name: [Sender Name]<br>', where [Sender Name] is the Sender Name, otherwise insert blank string.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `sender_name_text`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Invoice Number Text`, `Yes`, `If Invoice Number is present, insert 'Invoice Number: [Invoice Number]<br>', where [Invoice Number] is the Invoice Number, otherwise insert blank string.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `invoice_number_text`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Invoice Date Text`, `Yes`, `If Invoice Date is present, insert 'Invoice Date: [Invoice Date]<br>', where [Invoice Date] is the Invoice Date, otherwise insert blank string.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `invoice_date_text`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Invoice Amount Text`, `Yes`, `If Invoice Amount is present, insert 'Invoice Amount: [Invoice Amount]<br>', where [Invoice Amount] is the Invoice Amount, otherwise insert blank string.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `invoice_amount_text`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Currency Text`, `Yes`, `If Currency is present, insert 'Invoice Currency: [Currency]<br>', where [Currency] is the Currency, otherwise insert blank string.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `currency_text`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).
header_level_item( `IBM DC XML`, `Scan ID Text`, `Yes`, `If Scan ID is present, insert 'Scan ID: [Scan ID]<br>', where [Scan ID] is the Scan ID, otherwise insert blank string.`, `Automated by p_ file.`, `Never`, ``, `p_ (Hard Coded)`, `scan_id_text`, `String`, `1`, `No`, `Functional Items`, `6`, ( true ), ( true ) ).

%-----------------------------------------------------------------------
% Line Level Items
%-----------------------------------------------------------------------


% Not Inherited
line_level_item( `IBM DC XML`, `Line Invoice Line`, `Yes`, `Insert line number in multiples of 10 (10, 20, 30, …).`, `Automated by p_ file.`, `Always`, ``, `p_ (Hard Coded)`, `line_order_line_number`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Amount`, `Yes`, `Map line gross amount from document.`, `Map line gross amount from document.`, `Always`, ``, `Rules/Gramatica Derived`, `line_total_amount`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Tax Percent`, `Yes`, `Map line tax rate from document.`, `Map line tax rate from document.`, `Always`, ``, `Rules/Gramatica Derived`, `line_vat_rate`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Tax Amount`, `Yes`, `Map line tax amount from document.`, `Map line tax amount from document.`, `Always`, ``, `Rules/Gramatica Derived`, `line_vat_amount`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Tax Code`, `Yes`, `Insert '??'.`, `Automated by p_ file.`, `Always`, ``, `Rules/Gramatica Derived`, `line_vat_code`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line PO Number`, `Yes`, `Map line purchase order number from invoice. Insert header level purchase order number if not present. Must match purchase order number from PO header file. Truncate to 10 characters, from front (right to left).`, `Map line purchase order number from document. Everything else automated by p_ file.`, `Conditional`, `Vendor is not in the NPNP list.`, `Both Rules & p_`, `line_buyers_order_number`, `String`, `1`, `No`, ``, `6`, ( grammar_set(`testing_line_variable`, `line_buyers_order_number`, LID), not( npnp_vendor ) ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Delivery Note`, `Yes`, `Map line delivery note number from document.`, `Map line delivery note number from document.`, `Conditional`, `List to be provided / created as we go through the process. If on invoice map for all vendors and only validate present on those in the list.`, `Rules (Mapped)`, `line_delivery_note_number`, `String`, `1`, `No`, ``, `6`, ( grammar_set(`testing_line_variable`, `line_delivery_note_number`, LID), delivery_note_vendor ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Unit Price`, `Yes`, `Map line unit price from document.`, `Map line unit price from document.`, `Always`, ``, `Rules/Gramatica Derived`, `line_unit_amount`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Quantity`, `Yes`, `Map line quantity from document.`, `Map line quantity from document.`, `Always`, ``, `Rules/Gramatica Derived`, `line_quantity`, `Number`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Material Number`, `Yes`, `Map line item code from document.`, `Map line item code from document.`, `Never`, ``, `Rules (Mapped)`, `line_item`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Cost Center`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `line_cost_centre`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Internal Order Number`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `line_internal_order_number`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line GL Account`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `line_gl`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Description`, `Yes`, `Map line description from document.`, `Map line description from document.`, `Never`, ``, `Rules (Mapped)`, `line_descr`, `String`, `1`, `No`, ``, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Lot Number`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `line_lot_number`, `String`, `1`, `Yes`, `Line Level Items`, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Packing List`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `line_packing_list`, `String`, `1`, `Yes`, `Line Level Items`, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line PO Item`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `line_po_item`, `String`, `1`, `Yes`, `Line Level Items`, `6`, ( true ), ( true ) ).
line_level_item( `IBM DC XML`, `Line Proforma`, `No`, ``, ``, `Never`, ``, `p_ (Hard Coded)`, `line_proforma`, `String`, `1`, `Yes`, `Line Level Items`, `6`, ( true ), ( true ) ).

%-----------------------------------------------------------------------
% Line Level Functional Items
%-----------------------------------------------------------------------

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


% Not Inherited
header_level_scenario( `1`, `Unrecognised/Failed to Map Any Data`, `No`, `Yes`, `Action From Intervention`, ``, `The document is either unrecognised or has failed to map any data. This is usually because it is a document that does not require processing, such as a statement or a body of an email, but can also be because the layout of the document is different to previous documents from the sender.`, `No`, `No`, `Unrecognised`, `No`, `No`, ( missed_data_items_condition ) ).
header_level_scenario( `2`, `Supporting Document`, `No`, `No`, `Merge With Image of Processed Document`, ``, `The document has been detected to be a supporting document for another that has successfully processed.`, `No`, `No`, `Supporting Document`, `No`, `No`, ( grammar_set( i_analyse_supporting_document) ) ).
header_level_scenario( `3`, `Body of Email`, `No`, `Yes`, `Action From Intervention`, ``, `The document is the body of an email that was sent without any attachments.`, `No`, `No`, `Body of Email`, `No`, `No`, ( i_mail( attachment, `body.html` ) ) ).
header_level_scenario( `4`, `Statement/Correspondence`, `No`, `Yes`, `Action From Intervention`, ``, `The document is a statement or some other document which requires manual processing.`, `No`, `No`, `Statement/Correspondence`, `No`, `No`, ( grammar_set( i_analyse_statement_correspondence ) ) ).
header_level_scenario( `5`, `Not On Project`, `No`, `Yes`, `Action From Intervention`, ``, `The organisation that the document relates to has not been added to the system by the customer. This means that the document cannot be processed.`, `No`, `No`, `Not On Project`, `No`, `No`, ( grammar_set( i_analyse_not_on_project ) ) ).
header_level_scenario( `6`, `New Layout`, `No`, `Yes`, `Action From Intervention`, ``, `The document has a new layout to any which have previously been sent by the organisation that the document relates to. A new mapping will need to be completed if the document is to be processed.`, `No`, `No`, `New Layout`, `No`, `No`, ( grammar_set( i_analyse_new_layout ) ) ).
header_level_scenario( `7`, `Image Document`, `No`, `Yes`, `Action From Intervention`, ``, `The document does not contain any text which can be read by the system, which suggests that it is an image or has been scanned. The ideal format is a data PDF (which is not the same as an image PDF), but any text-based document format will do. If text can be copied and pasted from the document, then it is in a format which is supported by the system.`, `No`, `No`, `Image Document`, `No`, `No`, ( i_error_empty ) ).
header_level_scenario( `8`, `PDF Error`, `No`, `Yes`, `Action From Intervention`, ``, `The document is a PDF which is either secured or contains an embedded font, which means that the system cannot read the text contained within the document. In order for the document to be processed, it must be generated by either using a different method or by changing the settings on the application which generates the document. The ideal format is a data PDF (which is not the same as an image PDF), but any text-based document format will do. If text can be copied and pasted from the document, then it is in a format which is supported by the system.`, `No`, `No`, `PDF Error`, `No`, `No`, ( i_error_pdf_error ) ).
header_level_scenario( `9`, `Unsupported File Extension`, `No`, `Yes`, `Action From Intervention`, ``, `The document has a file extension which is unsupported by the system. The ideal format is a data PDF (which is not the same as an image PDF), but any text-based document format will do. If text can be copied and pasted from the document, then it is in a format which is supported by the system.`, `No`, `No`, `Unsupported File Type`, `No`, `No`, ( i_error_unsupported_file_type ) ).
header_level_scenario( `10`, `Credit Note`, `No`, `No`, `Process With Positive Values`, ``, `The document has been recognised as a credit note.`, `No`, `No`, `Credit Note`, `No`, `No`, ( grammar_set( credit_note ) ) ).
header_level_scenario( `11`, `Duplicate`, `No`, `Yes`, `Action From Intervention`, ``, `The document has been recognised as a duplicate of one that has previously processed successfully.`, `No`, `No`, `Duplicate`, `No`, `No`, ( grammar_set( i_analyse_duplicate ) ) ).
header_level_scenario( `12`, `Old Date`, `No`, `No`, `Process As Normal`, ``, `The document date is older than the allowance.`, `No`, `No`, `Old Date`, `No`, `No`, ( grammar_set( over_x_days_old, invoice_date  ) ) ).
header_level_scenario( `13`, `Future Date`, `No`, `No`, `Process As Normal`, ``, `The document date is in the future.`, `No`, `No`, `Future Date`, `No`, `No`, ( grammar_set( future_dated, invoice_date  ) ) ).
header_level_scenario( `14`, `Zero Value Document`, `No`, `No`, `Return to Sender`, ``, `The document has a total value of zero.`, `No`, `No`, `Zero Value Document`, `No`, `No`, ( i_error_zero_value_invoice ) ).
header_level_scenario( `15`, `Positive & Negative Lines`, `No`, `No`, `Process As Normal`, ``, `The document contains both credit and debit lines.`, `No`, `No`, `Positive and Negative Lines`, `No`, `No`, ( i_error_positive_and_negative_lines ) ).
header_level_scenario( `16`, `No Lines`, `Yes`, `No`, `Return to Sender`, ``, `The document does not contain any lines.`, `No`, `No`, `No Lines`, `No`, `No`, ( i_error_missing_lines ) ).
header_level_scenario( `17`, `Invoice With Negative Totals`, `Yes`, `No`, `Return to Sender`, ``, `The document contains negative totals but does not appear to be a credit note.`, `No`, `No`, `Invoice With Negative Totals`, `No`, `No`, ( i_error_negative_totals ) ).
header_level_scenario( `18`, `Sum of Line Net Amounts Not Equal to Total Net Amount`, `Yes`, `No`, `Return to Sender`, ``, `The sum of the line net amounts are not equal to the total net amount. Sum of Line Net Amounts = <data>Sum of Line Net Amounts</data>, Total Net Amount = <data>Total Net Amount</data>, Difference = <data>Net Difference</data>.`, `No`, `No`, `Sum of Line Net Amounts Not Equal to Total Net Amount`, `No`, `No`, ( i_error_sum_net_integer_discrepancy ) ).
header_level_scenario( `19`, `Sum of Line Gross Amounts Not Equal to Total Gross Amount`, `Yes`, `No`, `Return to Sender`, ``, `The sum of the line gross amounts are not equal to the total gross amount. Sum of Line Gross Amounts = <data>Sum of Line Gross Amounts</data>, Total Gross Amount = <data>Total Gross Amount</data>, Difference = <data>Gross Difference</data>.`, `No`, `No`, `Sum of Line Gross Amounts Not Equal to Total Gross Amount`, `No`, `No`, ( i_error_sum_total_integer_discrepancy ) ).
header_level_scenario( `20`, `Totals Do Not Add Up`, `Yes`, `No`, `Return to Sender`, ``, `The document contains inconsistent totals, i.e. Total Net + Total VAT \= Total Gross.`, `No`, `No`, `Totals Do Not Add Up`, `No`, `No`, ( i_error_invoice_integer_totals_inconsistent ) ).
header_level_scenario( `23`, `Missing Invoice Type`, `Yes`, `Yes`, `Action From Intervention`, ``, `The document is missing the following piece of data: Invoice Type`, `No`, `No`, `Missing Invoice Type`, `No`, `No`, ( not( result( _, invoice, invoice_type, _ ) ) ) ).
header_level_scenario( `24`, `Missing Document Date`, `Yes`, `Yes`, `Return to Sender`, ``, `The document is missing the following piece of data: Document Date`, `No`, `No`, `Missing Document Date`, `No`, `No`, ( not( result( _, invoice, invoice_date, _ ) ) ) ).
header_level_scenario( `25`, `Missing Total Amount`, `Yes`, `Yes`, `Return to Sender`, ``, `The document is missing the following piece of data: Total Amount`, `No`, `No`, `Missing Total Amount`, `No`, `No`, ( not( result( _, invoice, total_invoice, _ ) ), not( grammar_set( freight_vendor ) ) ) ).
header_level_scenario( `26`, `Missing Tax Amount`, `Yes`, `Yes`, `Return to Sender`, ``, `The document is missing the following piece of data: Tax Amount`, `No`, `No`, `Missing Tax Amount`, `No`, `No`, ( not( result( _, invoice, total_vat, _ ) ) ) ).
header_level_scenario( `27`, `Missing Currency Code`, `Yes`, `Yes`, `Action From Intervention`, ``, `The document is missing the following piece of data: Currency Code`, `No`, `No`, `Missing Currency Code`, `No`, `No`, ( not( result( _, invoice, currency, _ ) ) ) ).
header_level_scenario( `28`, `Missing Invoice Number`, `Yes`, `Yes`, `Return to Sender`, ``, `The document is missing the following piece of data: Invoice Number`, `No`, `No`, `Missing Invoice Number`, `No`, `No`, ( not( result( _, invoice, invoice_number, _ ) ) ) ).
header_level_scenario( `29`, `Missing Vendor ID`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Vendor ID`, `No`, `No`, `Missing Vendor ID`, `No`, `No`, ( not( result( _, invoice, buyers_code_for_supplier, _ ) ) ) ).
header_level_scenario( `30`, `Missing Scan ID`, `Yes`, `No`, `Action From Intervention`, ``, `The document is missing the following piece of data: Scan ID`, `No`, `No`, `Missing Scan ID`, `No`, `No`, ( not( result( _, invoice, scan_id, _ ) ) ) ).
header_level_scenario( `31`, `Missing Net Amount`, `Yes`, `Yes`, `Return to Sender`, ``, `The document is missing the following piece of data: Net Amount`, `No`, `No`, `Missing Net Amount`, `No`, `No`, ( not( result( _, invoice, total_net, _ ) ) ) ).
header_level_scenario( `32`, `Invoice quotes tax but is not a tax invoice`, `Yes`, `No`, `Return to Sender`, ``, `Invoice does not state that it is a "Tax Invoice", despite charging tax.`, `No`, `No`, `Tax Quoted On Invoice`, `No`, `No`, ( result( _, invoice, total_vat, VAT ), not( q_sys_comp_str_eq( VAT, `0` ) ), not( grammar_set( tax_invoice ) ) ) ).
header_level_scenario( `33`, `Document Size is Too Large`, `Yes`, `No`, `Return to Sender`, ``, `This document file size is too large for CloudTrade to process.`, `No`, `No`, `Document Too Large`, `No`, `No`, ( i_error_too_big ) ).
header_level_scenario( `34`, `Invalid Invoice Date`, `Yes`, `Yes`, `Return to Sender`, ``, `The value of the Invoice Date was <data>Invoice Date</data>, which is invalid.`, `No`, `No`, `Invalid Invoice Date`, `No`, `No`, ( grammar_set( invoice, `i_analyse_invalid_invoice_date` ) ) ).
header_level_scenario( `35`, `Invalid Invoice Number`, `Yes`, `Yes`, `Return to Sender`, ``, `The value of the Invoice Date was <data>Invoice Number</data>, which is invalid.`, `No`, `No`, `Invalid Invoice Number`, `No`, `No`, ( grammar_set( invoice, `i_analyse_invalid_invoice_number` ) ) ).

%-----------------------------------------------------------------------
% Line Level Scenarios
%-----------------------------------------------------------------------


% Not Inherited
line_level_scenario( `21`, `Quantity Times Unit Amount Not Equal to Net Amount`, `Yes`, `No`, `Return to Sender`, ``, `The quantity times the unit price is not equal to the net price for lines <data>Quantity Times Unit Amount Not Equal to Net Amount Occurred At Lines</data>.`, `No`, `No`, `Quantity Times Unit Amount Not Equal to Net Amount`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `21_Quantity Times Unit Amount Not Equal to Net Amount`, LID), i_error_quantity_and_unit_and_net_amounts_inconsistent( LID, `0.03` ) ) ).
line_level_scenario( `22`, `Zero Value Line`, `No`, `No`, `Suppress Output of Zero Value Lines`, ``, `The following lines are zero value: <data>Zero Value Line At Lines</data>.`, `No`, `No`, `Zero Value Line`, `No`, `No`, ( grammar_set(`testing_document_scenario`, `22_Zero Value Line`, LID), i_error_zero_value_line( LID ) ) ).

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
connection_lookup_table( `ul_uapl_303_mullen_lowe_australia`, [ ( return_email, `Financelowebkk@Mullenlowe.com`), ( buyers_code_for_supplier, `793143` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_acnielsen_amer`, [ ( return_email, `gcc.accountsreceivable@nielsen.com`), ( buyers_code_for_supplier, `512491` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_as_watson`, [ ( return_email, `EricF@asw.com.hk`), ( buyers_code_for_supplier, `50155744` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_aww_global`, [ ( return_email, `ops@coastalbridge.com.au`), ( buyers_code_for_supplier, `50566754` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ab_world_foods`, [ ( return_email, `Jeff.Dalton@abworldfoods.com.au`), ( buyers_code_for_supplier, `560045` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_acumen_houseware`, [ ( return_email, `grace.shih@acumen.com.tw`), ( buyers_code_for_supplier, `50515270` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_agility_international`, [ ( return_email, `nmohamad@agilitylogistics.com`), ( buyers_code_for_supplier, `50425930` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_agrana_fruit`, [ ( return_email, `ian.mcnaught@agrana.com.au`), ( buyers_code_for_supplier, `792488` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ait_worldwide`, [ ( return_email, `unilever@aitworldwide.com`), ( buyers_code_for_supplier, `51435997` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_alia_premedia`, [ ( return_email, `diadeisbilling@diadeis.in`), ( buyers_code_for_supplier, `50429143` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_aliminter_sa`, [ ( return_email, `e.baeza@aliminter.com`), ( buyers_code_for_supplier, `51089348` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_alteryx_uk`, [ ( return_email, `chiggins@alteryx.com`), ( buyers_code_for_supplier, `50487923` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_alto_manufacturing`, [ ( return_email, `credit.services@alto.net.au`), ( buyers_code_for_supplier, `798103` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_altratec`, [ ( return_email, `lau@altratec.com`), ( buyers_code_for_supplier, `551068` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_americoldaus`, [ ( return_email, `AribaBuyer.UANZ@unilever.com`), ( buyers_code_for_supplier, `793998` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_americoldnz`, [ ( return_email, `AribaBuyer.UANZ@unilever.com`), ( buyers_code_for_supplier, `790323` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_amg_india`, [ ( return_email, `rfq@monitorsurvey.ai`), ( buyers_code_for_supplier, `51465895` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_anaplan`, [ ( return_email, `srini.r@anaplan.com`), ( buyers_code_for_supplier, `50507119` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_anl_container`, [ ( return_email, `marketing@anl.com.au`), ( buyers_code_for_supplier, `518146` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pt_anugerah`, [ ( return_email, `fifilinawaty@yahoo.com`), ( buyers_code_for_supplier, `532312` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_au_arnest`, [ ( return_email, `sozonov-ak@arnest.ru`), ( buyers_code_for_supplier, `891212` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_apex_packaging`, [ ( return_email, `sales@apexpackaging.com.my`), ( buyers_code_for_supplier, `770046` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_apl_co_pte`, [ ( return_email, `Shirley_Yap@nol.com.sg`), ( buyers_code_for_supplier, `519176` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_artberry_company`, [ ( return_email, `artberry_finance@artberry.co.th`), ( buyers_code_for_supplier, `93087` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_artsource_asia`, [ ( return_email, `sales@artsource-asia.com`), ( buyers_code_for_supplier, `515760` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_asatsu_dk`, [ ( return_email, `UL_BD_prj@adk.jp`), ( buyers_code_for_supplier, `880465` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_asl_logistics`, [ ( return_email, `lloyd.cmb@asllogistics-int.com`), ( buyers_code_for_supplier, `51532085` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ati_freight`, [ ( return_email, `sherzad@atifreight.net`), ( buyers_code_for_supplier, `50490844` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_austicks`, [ ( return_email, `allan.booth@austicks.com.au`), ( buyers_code_for_supplier, `50506458` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_automobil_leasing`, [ ( return_email, `siewyen@motorway.com.sg`), ( buyers_code_for_supplier, `750089` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ayezan_llc`, [ ( return_email, `nselva@ckaglobal.com`), ( buyers_code_for_supplier, `500769` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_baker_mckenzie`, [ ( return_email, `sharon.chong@bakermckenzie.com`), ( buyers_code_for_supplier, `750104` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_baldock_stacy_niven`, [ ( return_email, `parramatta@bsnlaw.com.au`), ( buyers_code_for_supplier, `794420` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bartle_bogle`, [ ( return_email, `bbhfin.billings@bartleboglehegarty.com`), ( buyers_code_for_supplier, `750111` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_barwil_dubai`, [ ( return_email, `Jai.Sarvjeet-Singh@wilhelmsen.com`), ( buyers_code_for_supplier, `502280` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_basell_asia`, [ ( return_email, `allan.oppus@lyondellbasell.com`), ( buyers_code_for_supplier, `50512431` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_benori_kpo`, [ ( return_email, `anurag.mishra@benoriknowledge.com`), ( buyers_code_for_supplier, `51435914` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_berle_transport`, [ ( return_email, `AribaBuyer.UANZ@unilever.com`), ( buyers_code_for_supplier, `794654` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_beroe_inc`, [ ( return_email, `pavithra@beroe-inc.com`), ( buyers_code_for_supplier, `535692` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bidorkwong`, [ ( return_email, `leekt@bidorkwongheng.com`), ( buyers_code_for_supplier, `770081` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_binzager_unilever`, [ ( return_email, `Mohammad.A.Ali@unilever.com`), ( buyers_code_for_supplier, `500351` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_blink_events`, [ ( return_email, `ben@blinkevents.com`), ( buyers_code_for_supplier, `543778` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bollore_australia`, [ ( return_email, `brendon.smith@bollore.com`), ( buyers_code_for_supplier, `51459917` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bollorelogistics_singapore`, [ ( return_email, `isaac.lau@bollore.com`), ( buyers_code_for_supplier, `50547911` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bollore_logistics`, [ ( return_email, `justin.easton@bollore.com`), ( buyers_code_for_supplier, `50358244` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bollore_vietnam`, [ ( return_email, `loan.nguyen@bollore.com`), ( buyers_code_for_supplier, `621128` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bosch_packaging`, [ ( return_email, `bernd.bruckert@bosch.com`), ( buyers_code_for_supplier, `517329` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_botany_group`, [ ( return_email, `jenny@botanygroup.com.au`), ( buyers_code_for_supplier, `50571956` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_brown_woods_indu`, [ ( return_email, `brwonwoodsme@gmail.com`), ( buyers_code_for_supplier, `50534754` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bt_singapore_ltd`, [ ( return_email, `miki.torii@bt.com`), ( buyers_code_for_supplier, `750145` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bulk_oil`, [ ( return_email, `anand.sheth@bolt-tanks.com`), ( buyers_code_for_supplier, `50516678` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bulkhaul_limited`, [ ( return_email, `aquek@bulkhaul.com.sg`), ( buyers_code_for_supplier, `511295` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cameron_interstate`, [ ( return_email, `accountsreceivable@camerons.com.au`), ( buyers_code_for_supplier, `538529` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_capgemini_outsourcing`, [ ( return_email, `uldo.in@capgemini.com`), ( buyers_code_for_supplier, `50281179` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_capgmeni_singapore`, [ ( return_email, `ramkumar.subramanyam@capgemini.co`), ( buyers_code_for_supplier, `516756` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cardinal_logisitic`, [ ( return_email, `ramharis@cardinallogistics.co.nz`), ( buyers_code_for_supplier, `50513791` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cargill_kenya`, [ ( return_email, `info@anjeli.co.ke`), ( buyers_code_for_supplier, `545494` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cargo_partner`, [ ( return_email, `Nishant.Chaubey@cargo-partner.com`), ( buyers_code_for_supplier, `51577223` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_carver_korea`, [ ( return_email, `yjlee@carverkorea.com`), ( buyers_code_for_supplier, `50565022` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_casa_rex`, [ ( return_email, `contact@casarex.com.br`), ( buyers_code_for_supplier, `531264` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cdc_canada_inc`, [ ( return_email, `alida@cdc-canada.ca`), ( buyers_code_for_supplier, `50006711` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cepsa_quimica`, [ ( return_email, `sofie.vandenbergh@cepsa.com`), ( buyers_code_for_supplier, `601010` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_chabba_bangkok`, [ ( return_email, `kanitta@chabaabangkok.com`), ( buyers_code_for_supplier, `751688` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `KANITTA@CHABAABANGKOK.COM`), ( buyers_code_for_supplier, `86908` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_chalco_qingdao_intnl`, [ ( return_email, `lgsalco@126.com`), ( buyers_code_for_supplier, `539152` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_chep_australia`, [ ( return_email, `customer.eft@chep.com`), ( buyers_code_for_supplier, `792986` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `liuxiaoxia@chinashipping.com.sg`), ( buyers_code_for_supplier, `516651` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `choichew@gmail.com`), ( buyers_code_for_supplier, `86308` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cip_srl`, [ ( return_email, `silvia.reati@cip4.com`), ( buyers_code_for_supplier, `50058248` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_clean_tech`, [ ( return_email, `howard@cleantech.org.cn`), ( buyers_code_for_supplier, `50524342` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cma_cgm`, [ ( return_email, `SSC.JBADIKESAVAN@cma-cgm.com`), ( buyers_code_for_supplier, `519660` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_codedigital_dubai`, [ ( return_email, `carlos@code8.studio`), ( buyers_code_for_supplier, `50559368` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_colep_portugal`, [ ( return_email, `claudia.laranjeira@colep.com`), ( buyers_code_for_supplier, `50580440` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_concord_consumer`, [ ( return_email, `mlumillo@ccrlatam.com`), ( buyers_code_for_supplier, `50163852` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_casalasco`, [ ( return_email, `MILANI.MONICA@ARPTOMATO.COM`), ( buyers_code_for_supplier, `50067087` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cosmax_china`, [ ( return_email, `smzhou@cosmax.com.cn`), ( buyers_code_for_supplier, `50541845` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cosmac_inc`, [ ( return_email, `seohyun@cosmax.com`), ( buyers_code_for_supplier, `50530751` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cosmint_spa`, [ ( return_email, `g.colombo@cosmint.it`), ( buyers_code_for_supplier, `556670` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_costar_shipping`, [ ( return_email, `adeline.chan@costar.com.sg`), ( buyers_code_for_supplier, `532604` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_crane_worldwide`, [ ( return_email, `SIN.Billing@Craneww.com`), ( buyers_code_for_supplier, `51470546` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_csr_martini`, [ ( return_email, `MartiniSalesVIL@csr.com.au`), ( buyers_code_for_supplier, `50488838` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_customised_solution`, [ ( return_email, `tcs.receivables@tollgroup.com`), ( buyers_code_for_supplier, `793887` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_cvmulia_utama`, [ ( return_email, `hello@the-small-agency.com`), ( buyers_code_for_supplier, `50269172` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dahnay_logistics`, [ ( return_email, `mby.latish@dahnaylogix.com`), ( buyers_code_for_supplier, `51585969` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_damco_australia`, [ ( return_email, `Glenn.tate@damco.com`), ( buyers_code_for_supplier, `794239` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_damco_singapore`, [ ( return_email, `peter.knapp@maersk.com`), ( buyers_code_for_supplier, `516582` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_damco_nzd`, [ ( return_email, `Sam.Coady@damco.com`), ( buyers_code_for_supplier, `790208` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dassinc_pte`, [ ( return_email, `carla@dass-inc.com`), ( buyers_code_for_supplier, `50559711` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_datawatch_sg`, [ ( return_email, `annabelle_codrington@datawatch.com`), ( buyers_code_for_supplier, `50540753` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_deloitte_consulting`, [ ( return_email, `atjahjana@deloitte.com`), ( buyers_code_for_supplier, `50361423` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dhl_express`, [ ( return_email, `mullai.ramachandran@dhl.com`), ( buyers_code_for_supplier, `750269` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dhl_global`, [ ( return_email, `priscilla.victor@dhl.com`), ( buyers_code_for_supplier, `532987` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dhl_glob_au_pty`, [ ( return_email, `naresh_bist.m@dhl.com`), ( buyers_code_for_supplier, `563334` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_diadeis_singapore`, [ ( return_email, `diadeissingaporecsr@diadeis.in`), ( buyers_code_for_supplier, `50477360` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_digital_jedi`, [ ( return_email, `sirilaksana@digitaljedi.info`), ( buyers_code_for_supplier, `771236` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `kittiwan.c@dksh.com`), ( buyers_code_for_supplier, `87811` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dsv_air_sea`, [ ( return_email, `janice.ong@sg.dsv.com`), ( buyers_code_for_supplier, `50528143` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dsv_solutions`, [ ( return_email, `Sin@sg.dsv.com`), ( buyers_code_for_supplier, `516767` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dubai_tea`, [ ( return_email, `Sunitha.Murthy@dmcc.ae`), ( buyers_code_for_supplier, `512770` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dugout_limited`, [ ( return_email, `accounts@dugout.com`), ( buyers_code_for_supplier, `51461302` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_eagletainer_logistics`, [ ( return_email, `bart@eagletainer.com`), ( buyers_code_for_supplier, `50503474` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_easy_cleaning`, [ ( return_email, `customer.services@easycleaningco.com`), ( buyers_code_for_supplier, `51433550` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ecomundo`, [ ( return_email, `cosmetics@ecomundo.eu`), ( buyers_code_for_supplier, `50556430` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_elionetwork_pte`, [ ( return_email, `accounts@elionetwork.com`), ( buyers_code_for_supplier, `51242248` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_emg_marketing`, [ ( return_email, `emg@gmgmm.com`), ( buyers_code_for_supplier, `50432804` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_emmegi_detergents`, [ ( return_email, `customerservice@emmegispa.com`), ( buyers_code_for_supplier, `51390283` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `joanne@emoxis.com`), ( buyers_code_for_supplier, `538513` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_encept_premedia`, [ ( return_email, `amod.kulkarni@enceptpremedia.com`), ( buyers_code_for_supplier, `50266308` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_eplus_packaging`, [ ( return_email, `ken.nkk@gmail.com`), ( buyers_code_for_supplier, `50474459` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `finance@epochdesign.co.uk`), ( buyers_code_for_supplier, `50062591` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ernst_young`, [ ( return_email, `noel.tan@sg.ey.com`), ( buyers_code_for_supplier, `751868` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ernstyoung_ltd`, [ ( return_email, `sian.tofts@nz.ey.com`), ( buyers_code_for_supplier, `546483` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ernst_young_pteltd`, [ ( return_email, `atul.chandna@sg.ey.com`), ( buyers_code_for_supplier, `751868` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_eurofins_mechem`, [ ( return_email, `YUWEITAY@eurofins.com`), ( buyers_code_for_supplier, `51464461` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `cathy@norgenvaaz.com.au`), ( buyers_code_for_supplier, `544552` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_everest_ice`, [ ( return_email, `cathy@norgernvaaz.com.au`), ( buyers_code_for_supplier, `544552` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_evergreen`, [ ( return_email, `BIZMTA@EVERGREEN-MARINE.COM.SG`), ( buyers_code_for_supplier, `50527903` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_expeditors_singapore`, [ ( return_email, `samantha.nio@expeditors.com`), ( buyers_code_for_supplier, `50487748` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ey_corporate`, [ ( return_email, `xiu-mei.chua@sg.ey.com`), ( buyers_code_for_supplier, `51399354` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `Waranya@fnnfoods.com`), ( buyers_code_for_supplier, `86827` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_fsmackenzie`, [ ( return_email, `container@fsmac.ru`), ( buyers_code_for_supplier, `51477663` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_farabi_petrochemicals`, [ ( return_email, `damodarank@farabipc.com`), ( buyers_code_for_supplier, `523474` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_farmol_spa`, [ ( return_email, `daniela.barattiero@farmol.com`), ( buyers_code_for_supplier, `514975` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_fima_ola`, [ ( return_email, `jose.andrade@unilever.com`), ( buyers_code_for_supplier, `552880` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pukka_herbs`, [ ( return_email, `Aus-Accounts@ebiquity.com`), ( buyers_code_for_supplier, `850106` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_flames`, [ ( return_email, `florence@flamecomms.com`), ( buyers_code_for_supplier, `50530571` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_foods_wise`, [ ( return_email, `enquiry.foodswise@gmail.com`), ( buyers_code_for_supplier, `50567817` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_fratelli`, [ ( return_email, `info@arkas-singapore.com`), ( buyers_code_for_supplier, `549663` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_gold_cold`, [ ( return_email, `laypeng.Teh@goldcold.com`), ( buyers_code_for_supplier, `50476016` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_genero_media`, [ ( return_email, `accounts@genero.com`), ( buyers_code_for_supplier, `50512977` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_glen_cameron`, [ ( return_email, `accountsreceivable@camerons.co`), ( buyers_code_for_supplier, `793348` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_global_strategy`, [ ( return_email, `admin@globalstrategyandtrading.com`), ( buyers_code_for_supplier, `50494474` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_globoforce_inc`, [ ( return_email, `accounts@workhuman.com`), ( buyers_code_for_supplier, `50573359` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_globoforce_ltd`, [ ( return_email, `accounts@workhuman.com`), ( buyers_code_for_supplier, `50573360` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_glottis`, [ ( return_email, `satheesh@glottislogistics.in`), ( buyers_code_for_supplier, `51536473` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_gobbler_pte`, [ ( return_email, `geraldine@gobblerco.com`), ( buyers_code_for_supplier, `50540978` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_gocomet_solutions`, [ ( return_email, `accounts@gocomet.com`), ( buyers_code_for_supplier, `51532085` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_gold_tiger_logistics`, [ ( return_email, `warehouse@gtls.com.au`), ( buyers_code_for_supplier, `50550473` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_green_park`, [ ( return_email, `tyas.hidayati@greenparkcontent.com`), ( buyers_code_for_supplier, `0050571016` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_haco_ag`, [ ( return_email, `hugo.kaeser@haco.ch`), ( buyers_code_for_supplier, `565421` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hakuhodo_inc`, [ ( return_email, `Ulteam@hakuhodo.co.jp`), ( buyers_code_for_supplier, `517897` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hamburg_sud`, [ ( return_email, `Tony.Wong@hamburgsud.com`), ( buyers_code_for_supplier, `531669` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hanexpress`, [ ( return_email, `HANF@HANEX.CO.KR`), ( buyers_code_for_supplier, `50555754` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hanjin_shipping`, [ ( return_email, `sinbbar@sg.hanjin.com`), ( buyers_code_for_supplier, `519935` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hansol_paper`, [ ( return_email, `cytem@hansol.com`), ( buyers_code_for_supplier, `559936` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hapag_lloyd`, [ ( return_email, `wilberg.tan@hlag.com`), ( buyers_code_for_supplier, `539499` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_harrisons_malayalam`, [ ( return_email, `shajimon@harrisonsmalayalam.com`), ( buyers_code_for_supplier, `333645` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_heinz_watties`, [ ( return_email, `AribaBuyer.UANZ@unilever.com`), ( buyers_code_for_supplier, `792557` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hello_group`, [ ( return_email, `pris@hellogroup.sg`), ( buyers_code_for_supplier, `50572441` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hiang_seng`, [ ( return_email, `SUNEE@HSFC.CO.TH`), ( buyers_code_for_supplier, `87695` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hindustan_unilever`, [ ( return_email, `uday.phenany@unilever.com`), ( buyers_code_for_supplier, `515021` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_holmes_marchant`, [ ( return_email, `kelyn.tor@holmesandmarchant.com.sg`), ( buyers_code_for_supplier, `531188` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hormel_foods`, [ ( return_email, `rdjech@hormel.com`), ( buyers_code_for_supplier, `50281268` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hp_financial`, [ ( return_email, `choo.siew-yoon@hp.com`), ( buyers_code_for_supplier, `50491403` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `ZHANGGOODMAN@VIP.SINA.COM`), ( buyers_code_for_supplier, `751875` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_hyundai_merchant`, [ ( return_email, `SKEVE@HMM21.COM`), ( buyers_code_for_supplier, `550599` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_im_impossible_co_ltd`, [ ( return_email, `ac2.iampossible@gmail.com`), ( buyers_code_for_supplier, `50501572` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_i_messina`, [ ( return_email, `george.mwangiri@messinaline-ke.com`), ( buyers_code_for_supplier, `545558` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_iapps_pte`, [ ( return_email, `finance@iappsasia.com`), ( buyers_code_for_supplier, `51464992` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ids_manufacturing`, [ ( return_email, `PeeSauWai@LFAsia.com`), ( buyers_code_for_supplier, `770375` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ignazio_messina`, [ ( return_email, `europe@messinaline.it`), ( buyers_code_for_supplier, `50572902` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_in_house,ul_uapl_inhouse_printing`, [ ( return_email, `inhouseprint@gmail.com`), ( buyers_code_for_supplier, `750484` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `pornchanokifs@yahoo.com`), ( buyers_code_for_supplier, `86404` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_inquiba_sa`, [ ( return_email, `lpajuelo@inquiba.com`), ( buyers_code_for_supplier, `50565470` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_infinity_global`, [ ( return_email, `joolee.inficjl@gmail.com`), ( buyers_code_for_supplier, `50535156` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_infosys_limited`, [ ( return_email, `Corporate_IBPOARTeam@infosys.com`), ( buyers_code_for_supplier, `50506355` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_insightzclub_pte`, [ ( return_email, `mritunjay.k@insightzclub.com`), ( buyers_code_for_supplier, `50550117` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ims_group`, [ ( return_email, `accounts@imsgroup.com.au`), ( buyers_code_for_supplier, `792393` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_intercontinental_oils`, [ ( return_email, `elizabeth.lau@icofgroup.com`), ( buyers_code_for_supplier, `512749` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_intertek_deutschland`, [ ( return_email, `wilhelm.pfleger@intertek.com`), ( buyers_code_for_supplier, `50493921` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_intertek_testing`, [ ( return_email, `cbasgpcollection@intertek.com`), ( buyers_code_for_supplier, `50512976` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ipg_advertising`, [ ( return_email, `FinanceLoweBkk@mullenlowe.com`), ( buyers_code_for_supplier, `87752` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_issariyawatana`, [ ( return_email, `amorn@mykiethai.com`), ( buyers_code_for_supplier, `94289` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_italinasped_spa`, [ ( return_email, `andrea.lai@italiansped.it`), ( buyers_code_for_supplier, `51437604` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_its_testing`, [ ( return_email, `david.raymond@intertek.com`), ( buyers_code_for_supplier, `50507892` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jc_industry`, [ ( return_email, `jiaqijun@jcindustry.com`), ( buyers_code_for_supplier, `561135` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jmtg_co,ul_uapl_jmykiethai_group`, [ ( return_email, `kittichai@jmykiethai.com`), ( buyers_code_for_supplier, `50501292` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `siwadol.lertpiriyalamol@jwt.co`), ( buyers_code_for_supplier, `751341` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `siwadol.lertpiriyakamol@jwt.co`), ( buyers_code_for_supplier, `750504` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_j_walter_thompson`, [ ( return_email, `kaoru.sato@jwt.com`), ( buyers_code_for_supplier, `517893` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jalco_australia`, [ ( return_email, `Credit.Services@jalco.com.au`), ( buyers_code_for_supplier, `792369` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jalco_cosmetics`, [ ( return_email, `Credit.Services@jalco.com.au`), ( buyers_code_for_supplier, `792301` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jalco_household`, [ ( return_email, `Credit.Services@jalco.com.au`), ( buyers_code_for_supplier, `532693` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jalco_promotional`, [ ( return_email, `credit.services@jalco.com.au`), ( buyers_code_for_supplier, `544826` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jatana_sdn`, [ ( return_email, `jatanasb@gmail.com`), ( buyers_code_for_supplier, `771254` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jd_express`, [ ( return_email, `zhengchun17@jd.com`), ( buyers_code_for_supplier, `51433631` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jdo_2`, [ ( return_email, `Hannah@jdouk.com`), ( buyers_code_for_supplier, `730582` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jiangsu`, [ ( return_email, `sun@ihtl.cc`), ( buyers_code_for_supplier, `51477721` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_jilin_cofco`, [ ( return_email, `xingyanxue@cofco.com`), ( buyers_code_for_supplier, `515733` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kantar_japan`, [ ( return_email, `KJTKY-ULCSTeamOperation@jp.kantargroup.com`), ( buyers_code_for_supplier, `560952` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kantar_vietnam`, [ ( return_email, `JobManagement-VN@kantar.com`), ( buyers_code_for_supplier, `85949` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_keppel_electric`, [ ( return_email, `CUSTOMERSERVICE@KEPINFRA.COM`), ( buyers_code_for_supplier, `50431185` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_keppel_logistics`, [ ( return_email, `fin.ar@keppellog.com`), ( buyers_code_for_supplier, `770436` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kinnerton`, [ ( return_email, `j.manninen@kinnerton.com`), ( buyers_code_for_supplier, `50509331` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kl_kepong`, [ ( return_email, `ck.hoong@klkoleo.com.my`), ( buyers_code_for_supplier, `203532` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kleen_pak`, [ ( return_email, `po_unilever@kleen-pak.com`), ( buyers_code_for_supplier, `50581996` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_royal_sanders`, [ ( return_email, `rgroen@royalsanders.nl`), ( buyers_code_for_supplier, `50581955` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kousah_co`, [ ( return_email, `Enquiry@kousahandco.com`), ( buyers_code_for_supplier, `50567060` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kuehne_nagel_logisitic`, [ ( return_email, `marnix.debruijn@kuehne-nagel.com`), ( buyers_code_for_supplier, `50053813` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kuehne_nagel`, [ ( return_email, `WENGKIT.CHOW@KUEHNE-NAGEL.COM`), ( buyers_code_for_supplier, `519634` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kumpulan`, [ ( return_email, `sy_tan_sahasin@southernhauliers.com`), ( buyers_code_for_supplier, `779182` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kunshan_health`, [ ( return_email, `sales13@healthandbeyond.cn`), ( buyers_code_for_supplier, `50570702` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kurtay_ihtiyac`, [ ( return_email, `export@kurex.co`), ( buyers_code_for_supplier, `50568180` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_lr_trading_transport`, [ ( return_email, `peng.tan@lrlogistics.com.my`), ( buyers_code_for_supplier, `779187` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_la_cesenate`, [ ( return_email, `INFO@LACESENATE.IT`), ( buyers_code_for_supplier, `770467` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_labix_company`, [ ( return_email, `LABIXGROUPCM@thaioilgroup.com`), ( buyers_code_for_supplier, `51463830` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `WILAILUCK.N@LAMSOON.CO.TH`), ( buyers_code_for_supplier, `87682` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_le_mac_australia`, [ ( return_email, `accounts@lemacaustralia.com.au`), ( buyers_code_for_supplier, `792344` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_lenovo_singapore`, [ ( return_email, `msee@lenovo.com`), ( buyers_code_for_supplier, `50434456` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_leo_global`, [ ( return_email, `siripond_sal@leogloballogistics.com`), ( buyers_code_for_supplier, `51481540` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_leocatas_transport`, [ ( return_email, `info@leocatastransport.com.au`), ( buyers_code_for_supplier, `793634` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_leongold_trading`, [ ( return_email, `admin@leongold.com`), ( buyers_code_for_supplier, `770495` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_lf_beauty`, [ ( return_email, `isaurapetrina@lfbeauty.com`), ( buyers_code_for_supplier, `50539320` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_lf_logistics_services`, [ ( return_email, `nidhyadeviwadevelo@lflogistics.com`), ( buyers_code_for_supplier, `770374` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_lightspeed`, [ ( return_email, `sphang@gmi-mr.com`), ( buyers_code_for_supplier, `50414383` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_linfox_aus`, [ ( return_email, `accounts_receivable@linfox.com`), ( buyers_code_for_supplier, `50536568` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_linfox`, [ ( return_email, `ar@linfox.co.nz`), ( buyers_code_for_supplier, `790687` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_lingaro_singapore`, [ ( return_email, `contact-sg@lingarogroup.com`), ( buyers_code_for_supplier, `51462599` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_lithospark`, [ ( return_email, `dee@lithospark.com`), ( buyers_code_for_supplier, `50503583` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ljm_marketing`, [ ( return_email, `kate@ljmms.com.au`), ( buyers_code_for_supplier, `792359` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ljm_nsw`, [ ( return_email, `kate@ljmms.com.au`), ( buyers_code_for_supplier, `558839` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_loscam_malaysia`, [ ( return_email, `kamales.ratnasingam@loscam.com`), ( buyers_code_for_supplier, `779263` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `jitlada.kanchanamayoon@loweandpartners.com`), ( buyers_code_for_supplier, `506063` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_lx_pantos`, [ ( return_email, `rahida.abd@lxpantos.com`), ( buyers_code_for_supplier, `51486030` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_madhu_silica`, [ ( return_email, `pravin@madhusilica.com`), ( buyers_code_for_supplier, `50285324` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_maersk_eastern`, [ ( return_email, `marzena.galarowska@sealandmaersk.com`), ( buyers_code_for_supplier, `51464106` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_maersk_line`, [ ( return_email, `sinfin+H2:H80wkcdis@maersk.com`), ( buyers_code_for_supplier, `516644` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mainfreight_bv`, [ ( return_email, `Maarten.Mol@nl.mainfreight.com`), ( buyers_code_for_supplier, `51150021` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mainfreight_forwarding`, [ ( return_email, `serdar.baktir@nl.mainfreight.com`), ( buyers_code_for_supplier, `51148403` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mainfreight_logistic`, [ ( return_email, `floris.proost@nl.mainfreight.com`), ( buyers_code_for_supplier, `50581559` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mainfreight_uk`, [ ( return_email, `accounts@uk.mainfreight.com`), ( buyers_code_for_supplier, `51461500` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_makandi_tea_coffee`, [ ( return_email, `balyenge@makanditea.com`), ( buyers_code_for_supplier, `50520913` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_manpower_staffing_services`, [ ( return_email, `FINANCE@MANPOWER.COM.SG`), ( buyers_code_for_supplier, `771344` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mapletree_business`, [ ( return_email, `soo.wenyi@mapletree.com.sg`), ( buyers_code_for_supplier, `539178` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mariana_shipping`, [ ( return_email, `sin.agent@sgp.mellship.com`), ( buyers_code_for_supplier, `51246494` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_marinabay_sands`, [ ( return_email, `sokekuin.chan@marinabaysands.com`), ( buyers_code_for_supplier, `519536` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mcbride_sa`, [ ( return_email, `houda.srasra@mcbride.eu`), ( buyers_code_for_supplier, `51095514` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mcc_labels`, [ ( return_email, `sylver.lee@pemara.com.my`), ( buyers_code_for_supplier, `201590` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mcc_transport`, [ ( return_email, `SINIASFINCRD@mcc.com.sg`), ( buyers_code_for_supplier, `516646` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mckinsey_company`, [ ( return_email, `winnie_yap@mckinsey.com`), ( buyers_code_for_supplier, `50566192` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mediterranean_aus`, [ ( return_email, `acctsrcvbfre@msc.com.au`), ( buyers_code_for_supplier, `795732` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mediterranean`, [ ( return_email, `williewong@msca.com.sg`), ( buyers_code_for_supplier, `516661` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mediterranean_nz`, [ ( return_email, `mscaacctsrcvb@msc.com.au`), ( buyers_code_for_supplier, `792664` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_megaton_shipping`, [ ( return_email, `customerservice@megaton.com.sg`), ( buyers_code_for_supplier, `51481497` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_metsa_board_corp`, [ ( return_email, `florence.leung@metsagroup.com`), ( buyers_code_for_supplier, `532868` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mexex`, [ ( return_email, `mexex.orders@mexex.com.au`), ( buyers_code_for_supplier, `50570868` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mgh_logistics`, [ ( return_email, `himanshu.pant@in.mghgroup.com`), ( buyers_code_for_supplier, `51460430` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_michael_page`, [ ( return_email, `accountssg@michaelpage.com.sg`), ( buyers_code_for_supplier, `751537` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `sunee@mighty.co.th`), ( buyers_code_for_supplier, `94220` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_milliman_private`, [ ( return_email, `juraidah.hussain@milliman.com`), ( buyers_code_for_supplier, `50546338` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_milott_laboratories`, [ ( return_email, `pattaraporn_cts@milott.co.th`), ( buyers_code_for_supplier, `520399` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_milott_laboratories`, [ ( return_email, `VIPARAT@MILOTT.CO.TH`), ( buyers_code_for_supplier, `94219` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mind_gym`, [ ( return_email, `invoices@themindgym.com`), ( buyers_code_for_supplier, `50497306` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mindtree_limited`, [ ( return_email, `Mohammed_Ahmed2@mindtree.com`), ( buyers_code_for_supplier, `750696` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mingfai_industrial`, [ ( return_email, `olivia.pang@mingfaigroup.com`), ( buyers_code_for_supplier, `50582261` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mintel_consulting`, [ ( return_email, `dtan@mintel.com`), ( buyers_code_for_supplier, `50432191` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mol_ltd`, [ ( return_email, `jenny.koh@mol-liner.com`), ( buyers_code_for_supplier, `516579` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_monter_global`, [ ( return_email, `divya@monterglobal.com`), ( buyers_code_for_supplier, `50542871` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `singapore@mothertongue.com`), ( buyers_code_for_supplier, `552502` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mountainview_learning`, [ ( return_email, `finance@mountainview.co.uk`), ( buyers_code_for_supplier, `50534163` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_multipackpty`, [ ( return_email, `adam@multipack.com.au`), ( buyers_code_for_supplier, `50285888` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_murad_llc`, [ ( return_email, `pkeywood@murad.com`), ( buyers_code_for_supplier, `50500802` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mykie_co`, [ ( return_email, `wimol@mykiethai.com`), ( buyers_code_for_supplier, `50416112` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_nakid_co`, [ ( return_email, `acct.naked@gmail.com`), ( buyers_code_for_supplier, `50550807` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_nam_anh_import`, [ ( return_email, `exports@namanhjsc.com`), ( buyers_code_for_supplier, `553433` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `neelamalai@avtplantations.co.in`), ( buyers_code_for_supplier, `556964` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_newcold`, [ ( return_email, `mischa.vanspaandonk@newcold.com`), ( buyers_code_for_supplier, `50533387` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_newport_tank_cont`, [ ( return_email, `JOANNE.CHONG@NEWPORTTANK.COM`), ( buyers_code_for_supplier, `50547912` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_nice_pak`, [ ( return_email, `Marc.Ellis@nice-pak.co.uk`), ( buyers_code_for_supplier, `50156781` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `nicole_h_b@outlook.com`), ( buyers_code_for_supplier, `50286082` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_nielsen_india`, [ ( return_email, `kajal.lamba@nielsen.com`), ( buyers_code_for_supplier, `511527` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `Chomphunuch_so@minornet.com`), ( buyers_code_for_supplier, `87889` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_northgatearinso`, [ ( return_email, `Sumesh.Kalappurakkal@ngahr.com`), ( buyers_code_for_supplier, `50461459` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_northline`, [ ( return_email, `Garry.anderson@northline.com.au`), ( buyers_code_for_supplier, `793441` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_nuffnang_sdn`, [ ( return_email, `myfinance@nuffnang.com`), ( buyers_code_for_supplier, `771271` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_nyk_group`, [ ( return_email, `sg_spear_collection@sg.nykline.com`), ( buyers_code_for_supplier, `516580` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ocean_network_express`, [ ( return_email, `JOSHUA.WONG@ONE-LINE.COM`), ( buyers_code_for_supplier, `50544560` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_oceanfreight_limited`, [ ( return_email, `Ocenfrtmba@Oceanfreight.co.ke`), ( buyers_code_for_supplier, `545560` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_oddinary`, [ ( return_email, `vinay@oddinary.co.in`), ( buyers_code_for_supplier, `50044728` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ogilvy_mather`, [ ( return_email, `sgp.unileverfinance@ogilvy.com`), ( buyers_code_for_supplier, `750757` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_oliver_marketing_pte`, [ ( return_email, `FinanceApac@oliver.agency`), ( buyers_code_for_supplier, `50520515` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_olly_pbc`, [ ( return_email, `Jeff@olly.com`), ( buyers_code_for_supplier, `50570754` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_oocl_singapore`, [ ( return_email, `SGPACC@OOCL.COM`), ( buyers_code_for_supplier, `516645` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_optimized_holding`, [ ( return_email, `reda.salem@optimizedholding.com.qa`), ( buyers_code_for_supplier, `50563617` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_orchard_stationery`, [ ( return_email, `OSS.ORCHARD@PACIFIC.NET.SG`), ( buyers_code_for_supplier, `751567` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_organic_trader`, [ ( return_email, `orders@organictrader.com.au`), ( buyers_code_for_supplier, `50558240` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ozpackptyltd`, [ ( return_email, `MatthewC@ozpackfoods.com`), ( buyers_code_for_supplier, `792341` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pacific_express`, [ ( return_email, `t.misiurak@mel.pilship.com`), ( buyers_code_for_supplier, `795724` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pacific_food`, [ ( return_email, `pfi22@pacific-food.com`), ( buyers_code_for_supplier, `50525767` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pacific_international`, [ ( return_email, `leepchen.loo@sgp.pilship.com`), ( buyers_code_for_supplier, `516581` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_packagingcentre`, [ ( return_email, `laumy@plascentre.com`), ( buyers_code_for_supplier, `770730` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_packaging_imolese`, [ ( return_email, `info@packagingimolese.com`), ( buyers_code_for_supplier, `50053115` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pagilaran`, [ ( return_email, `g_larcommerce@yahoo.co.id`), ( buyers_code_for_supplier, `31008` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_panalpina_world`, [ ( return_email, `Grace.goh@panalpina.com`), ( buyers_code_for_supplier, `552087` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pan_connexionsasia`, [ ( return_email, `rachael@cxagroup.com`), ( buyers_code_for_supplier, `50478840` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_papoutsanis_sa`, [ ( return_email, `c.chatzistamou@papoutsanis.gr`), ( buyers_code_for_supplier, `51401689` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_parkway_shenton`, [ ( return_email, `ENQUIRIES@PARKWAYSHENTON.COM`), ( buyers_code_for_supplier, `516857` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pax_australia`, [ ( return_email, `shainazc@paxaus.com.au`), ( buyers_code_for_supplier, `792302` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_peerless`, [ ( return_email, `accrec@peerlessfoods.com.au`), ( buyers_code_for_supplier, `792352` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `ptpn8tea@gmail.com`), ( buyers_code_for_supplier, `31014` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_perkins_will`, [ ( return_email, `london.accounts@perkinswill.com`), ( buyers_code_for_supplier, `0050573883` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_persan_sa`, [ ( return_email, `aannandale@persan.es`), ( buyers_code_for_supplier, `51150350` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `pgeo-mktjb@my.wilmar-intl.com`), ( buyers_code_for_supplier, `76051` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `vijay.jagannath@mcleodrussel.com`), ( buyers_code_for_supplier, `333654` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pixie_icecream`, [ ( return_email, `bethfrench@pixieicecream.com`), ( buyers_code_for_supplier, `50529064` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_posimat`, [ ( return_email, `service@posimat.com`), ( buyers_code_for_supplier, `362901` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_powerhouse_logistics`, [ ( return_email, `David.maughan@powerhousensw.com.au`), ( buyers_code_for_supplier, `792624` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pq_chemicals`, [ ( return_email, `Chairat.Suwanprasert@pqcorp.com`), ( buyers_code_for_supplier, `94316` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_premium_logistics`, [ ( return_email, `fraces@premiumlogistics.biz`), ( buyers_code_for_supplier, `50424882` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pwc_singapore_pte`, [ ( return_email, `nena.e.cruz@sg.pwc.com`), ( buyers_code_for_supplier, `750846` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_print_lab`, [ ( return_email, `info@printlab.com.sg`), ( buyers_code_for_supplier, `531156` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_prospace_pte`, [ ( return_email, `steve.ong@prospace.io`), ( buyers_code_for_supplier, `50516339` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ptben_hamza`, [ ( return_email, `rusman@benhamslogistics.com`), ( buyers_code_for_supplier, `50512252` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pt_cahaya`, [ ( return_email, `eva@pundimas.co.id`), ( buyers_code_for_supplier, `50482609` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `Tang.tjuing@bogasariflour.com`), ( buyers_code_for_supplier, `85767` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kantar_indonesia`, [ ( return_email, `NS.Finance@tns-global.com`), ( buyers_code_for_supplier, `92291` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_konica_minolta`, [ ( return_email, `arief.utomo@indicia.konicaminolta.com`), ( buyers_code_for_supplier, `541755` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `wlandiani@mscid.com`), ( buyers_code_for_supplier, `553794` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pmg_integrasi`, [ ( return_email, `po.indo@pmgasia.com`), ( buyers_code_for_supplier, `50555954` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ptsocial_bella`, [ ( return_email, `finance@sociolla.com`), ( buyers_code_for_supplier, `50573507` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pt_unilever_indonesia`, [ ( return_email, `Edriaty.Natalia@unilever.com`), ( buyers_code_for_supplier, `50524901` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pt_cosmax`, [ ( return_email, `rachel@cosmax.co.id`), ( buyers_code_for_supplier, `50497292` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pt_orson`, [ ( return_email, `hari@orsonindonesia.com`), ( buyers_code_for_supplier, `50551357` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pukka_herbs`, [ ( return_email, `accounts@pukkaherbs.com`), ( buyers_code_for_supplier, `50543825` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_qatar_chemical`, [ ( return_email, `singaram@muntajat.qa`), ( buyers_code_for_supplier, `50283750` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `qdhwjt@public.qd.sd.cn`), ( buyers_code_for_supplier, `518214` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_qingwa_pte`, [ ( return_email, `finances@qingwadesign.com`), ( buyers_code_for_supplier, `559908` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_qtrade_int_co`, [ ( return_email, `SHEEN@QTRADETEAS.COM`), ( buyers_code_for_supplier, `50505115` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_rhs_logistics`, [ ( return_email, `jinto.john@rhslogistics.COM`), ( buyers_code_for_supplier, `519955` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_rand_transport`, [ ( return_email, `accounts@rand.com.au`), ( buyers_code_for_supplier, `792509` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_randstad`, [ ( return_email, `allunilevernationally@randstad.com.au`), ( buyers_code_for_supplier, `794703` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_rcl_feeder`, [ ( return_email, `sinimp@rclgroup.com`), ( buyers_code_for_supplier, `516585` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_refinitiv`, [ ( return_email, `asean.creditcontrol@refinitiv.com`), ( buyers_code_for_supplier, `750914` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ricoh_singapore`, [ ( return_email, `Eunicechng@ricoh.sg`), ( buyers_code_for_supplier, `533696` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_rohlig_australia`, [ ( return_email, `AribaBuyer.UANZ@unilever.com`), ( buyers_code_for_supplier, `794755` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_rohlig_singapore`, [ ( return_email, `sg.rc.sin.cs@rohlig.com`), ( buyers_code_for_supplier, `51490432` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_rubella_beauty`, [ ( return_email, `a.julianova@rubella.eu`), ( buyers_code_for_supplier, `50416828` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_sj_international`, [ ( return_email, `PEERAYA_P@SNJINTER.COM`), ( buyers_code_for_supplier, `87841` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_sapient_consulting`, [ ( return_email, `SapientAsiaAccountsReceivables@sapient.com`), ( buyers_code_for_supplier, `540592` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_saturday_communications`, [ ( return_email, `anoop.george@woop.world`), ( buyers_code_for_supplier, `51434746` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_savino_del`, [ ( return_email, `kyle.teo@savinodelbene.com`), ( buyers_code_for_supplier, `51572882` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_sbs_logistics`, [ ( return_email, `desmond.beh@sbs-group.biz`), ( buyers_code_for_supplier, `51479609` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_schawk_japan`, [ ( return_email, `Unilever_jpn_csr@sgkinc.com`), ( buyers_code_for_supplier, `531110` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_schenker_singapore`, [ ( return_email, `corp.sm.receivables.sg@dbschenker.com`), ( buyers_code_for_supplier, `50359679` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_sc_hongya`, [ ( return_email, `QYJCHEMICAL@126.COM`), ( buyers_code_for_supplier, `517094` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_searchasia_consulting`, [ ( return_email, `geraldinetan@recruitexpress.com.sg`), ( buyers_code_for_supplier, `553617` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_sgsmalaysia_sdnbh`, [ ( return_email, `jugjit.kaur@sgs.com`), ( buyers_code_for_supplier, `770846` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_sgs_gulf`, [ ( return_email, `Suzette.Coutinho@sgs.com`), ( buyers_code_for_supplier, `500675` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_shandong_intco`, [ ( return_email, `emiliegao@intco.com`), ( buyers_code_for_supplier, `51470181` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_shell_eastern`, [ ( return_email, `Lee-Ming.Su@shell.com`), ( buyers_code_for_supplier, `85847` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_shobiz_experiential`, [ ( return_email, `tejpal.patpatia@shobizexperience.com`), ( buyers_code_for_supplier, `50031565` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_shutterstock`, [ ( return_email, `szhuang@shutterstock.com`), ( buyers_code_for_supplier, `50019680` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_shuttlerock_limited`, [ ( return_email, `hitesh@shuttlerock.com`), ( buyers_code_for_supplier, `51435044` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_singtel`, [ ( return_email, `g-collect@singtel.com`), ( buyers_code_for_supplier, `751017` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_sino_logistics`, [ ( return_email, `acc@sinologistics.co.th`), ( buyers_code_for_supplier, `51491588` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `chengyi.wee@sodexo.com`), ( buyers_code_for_supplier, `50435136` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_solveco`, [ ( return_email, `matt@solveco.com.au`), ( buyers_code_for_supplier, `50429234` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_southern_hauliers`, [ ( return_email, `pch_sahasin@southernhauliers.com`), ( buyers_code_for_supplier, `518893` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `spservices@singaporepower.com.sg`), ( buyers_code_for_supplier, `751038` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_sparkit_insights`, [ ( return_email, `Kristine@sparkit-insights.com`), ( buyers_code_for_supplier, `558197` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_star_shipping`, [ ( return_email, `xtrade@zisa-sin.zim.com`), ( buyers_code_for_supplier, `519939` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_real_staffing`, [ ( return_email, `remittances@centralservices.co.uk`), ( buyers_code_for_supplier, `545342` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `sunsern2002@yahoo.com`), ( buyers_code_for_supplier, `86857` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_suprima_bakeries`, [ ( return_email, `receivables@tocg.com.au`), ( buyers_code_for_supplier, `565724` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_swift_consolidators`, [ ( return_email, `michelle.kong@swiftlogistics.com.my`), ( buyers_code_for_supplier, `553715` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_szaidel_cosmetic`, [ ( return_email, `rechnung@szaidel-cosmetics.de`), ( buyers_code_for_supplier, `50066118` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_tag_europe`, [ ( return_email, `UnileverPurchaseorder@tagworldwide.com`), ( buyers_code_for_supplier, `531394` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `accounts@imsgroup.com.au`), ( buyers_code_for_supplier, `558945` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_tangram_intelligent`, [ ( return_email, `pritchie@tangramint.com`), ( buyers_code_for_supplier, `50486438` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_tanjong_express`, [ ( return_email, `ikariana@tanjongexpress.com`), ( buyers_code_for_supplier, `51575456` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_tasco_berhad`, [ ( return_email, `TASCO.ML.AR.NOTIFICATION@TASCO.COM.MY`), ( buyers_code_for_supplier, `50550654` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_tatra_spring`, [ ( return_email, `katarzyna.sitek@tatraspring.com`), ( buyers_code_for_supplier, `50546367` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_taylor_nelson`, [ ( return_email, `Jann.Yap@tns-global.com`), ( buyers_code_for_supplier, `85907` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_tea_too`, [ ( return_email, `sales@t2tea.com`), ( buyers_code_for_supplier, `50418243` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_team_reactivate`, [ ( return_email, `info@teamreactivate.com`), ( buyers_code_for_supplier, `50503686` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_telecom_equipment`, [ ( return_email, `louisloy@singtel.com`), ( buyers_code_for_supplier, `751111` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_tepak_marketing`, [ ( return_email, `norazlina.shahlan@tepak.com`), ( buyers_code_for_supplier, `770984` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_thai_daizo`, [ ( return_email, `r-boonliang@thaidaizo.com`), ( buyers_code_for_supplier, `76016` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `r-boonliang@thaidaizo.com`), ( buyers_code_for_supplier, `86914` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `parima@tvothai.com`), ( buyers_code_for_supplier, `87976` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_belgian_chocloate`, [ ( return_email, `TDS@thebelgian.com`), ( buyers_code_for_supplier, `50565168` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_china_navigation`, [ ( return_email, `agency.accounts@chinanav.com`), ( buyers_code_for_supplier, `50361755` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_nielsen_europe`, [ ( return_email, `singapore.accountreceivable@nielsen.com`), ( buyers_code_for_supplier, `50461321` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_nielsen_singapore`, [ ( return_email, `Kajal.Lamba@nielsen.com`), ( buyers_code_for_supplier, `751142` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_puzzle_marketing`, [ ( return_email, `winnie.fung@the-puzzle.com`), ( buyers_code_for_supplier, `50268854` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_thompson_lloyd`, [ ( return_email, `DH@thompsons.co.uk`), ( buyers_code_for_supplier, `540852` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_thorogood_associates`, [ ( return_email, `finance@thorogood.com`), ( buyers_code_for_supplier, `0512236` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_toll_global_fwd_sg`, [ ( return_email, `oeicheang.lim@tollgroup.com`), ( buyers_code_for_supplier, `50546064` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `AribaBuyer.UANZ@unilever.com`), ( buyers_code_for_supplier, `793171` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_toll_logistics`, [ ( return_email, `Jeffery.tiong@tollgroup.com`), ( buyers_code_for_supplier, `779865` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `t_okuda@toyo-logistics.co.jp`), ( buyers_code_for_supplier, `730271` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_trade_expeditors`, [ ( return_email, `hs@teuinc.com`), ( buyers_code_for_supplier, `51537937` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `MARK.BROOKS@TRUBLUBEV.COM.AU`), ( buyers_code_for_supplier, `50426378` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_tuas_power`, [ ( return_email, `christineang@tuaspower.com.sg`), ( buyers_code_for_supplier, `771236` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_us_cotton`, [ ( return_email, `steve.staley@parkdalemills.com`), ( buyers_code_for_supplier, `50566755` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ueno_container`, [ ( return_email, `contact@uenologistics.com`), ( buyers_code_for_supplier, `50362806` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_ascc_ag`, [ ( return_email, `uremitta@in.ibm.com`), ( buyers_code_for_supplier, `546556` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_australia_ltd`, [ ( return_email, `Girish.hm@capgemini.com`), ( buyers_code_for_supplier, `514342` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_aus_trading`, [ ( return_email, `Acc-Rec-Retail.Uanz-Epp@unilever.com`), ( buyers_code_for_supplier, `519085` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_canada_food`, [ ( return_email, `ucanadaq@in.ibm.com`), ( buyers_code_for_supplier, `85989` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_china`, [ ( return_email, `Xue-qian.Gu@unilever.com`), ( buyers_code_for_supplier, `517585` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_argentina`, [ ( return_email, `geraldina.fernandez@unilever.com`), ( buyers_code_for_supplier, `515027` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_europe`, [ ( return_email, `Tanveer.Pasha2@unilever.com`), ( buyers_code_for_supplier, `50522997` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_gulf`, [ ( return_email, `john.george2@unilever.com`), ( buyers_code_for_supplier, `501407` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_homepersonal`, [ ( return_email, `SKEVE@HMM21.COM`), ( buyers_code_for_supplier, `50488006` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_ind_export`, [ ( return_email, `Sajan.Chhabra@unilever.com`), ( buyers_code_for_supplier, `551545` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_industries_ltd`, [ ( return_email, `Nagkumar.Dhanshri@unilever.com`), ( buyers_code_for_supplier, `510710` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_industries_5046202`, [ ( return_email, `Raman.Narayanan@unilever.com`), ( buyers_code_for_supplier, `50462021` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_jeronimo`, [ ( return_email, `francisco.sousa@unilever.com`), ( buyers_code_for_supplier, `515306` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_lipton`, [ ( return_email, `Ghazzali.Ehsaan@unilever.com`), ( buyers_code_for_supplier, `532747` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_maghreb`, [ ( return_email, `Said.Bassiouni@unilever.com`), ( buyers_code_for_supplier, `500408` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_mashreq`, [ ( return_email, `amr.ragab@unilever.com`), ( buyers_code_for_supplier, `508181` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mashreq_foods`, [ ( return_email, `Youssra.Alakad@unilever.com`), ( buyers_code_for_supplier, `200274` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_mashreq_personal_care`, [ ( return_email, `amr.ragab@unilever.com`), ( buyers_code_for_supplier, `518083` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_philippines`, [ ( return_email, `MELODY.LACUATA-PEREZ@UNILEVER.COM`), ( buyers_code_for_supplier, `520632` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_uscc`, [ ( return_email, `analysis-interco.uscc.in@capgemini.com`), ( buyers_code_for_supplier, `524061` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_teakenya`, [ ( return_email, `John.Mutua@unilever.com`), ( buyers_code_for_supplier, `516385` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_teatanzania`, [ ( return_email, `John.Mutua@unilever.com`), ( buyers_code_for_supplier, `514287` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_thai`, [ ( return_email, `THIRADA.MONKEAW@UNILEVER.COM`), ( buyers_code_for_supplier, `515303` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_ukcr_ltd`, [ ( return_email, `ULCCAP@pl.ibm.com`), ( buyers_code_for_supplier, `79352` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_vietnam_intnl`, [ ( return_email, `Hoang-Thi.Thu@Unilever.com`), ( buyers_code_for_supplier, `503214` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_unilever_n_v`, [ ( return_email, `ccr_interco.in@capgemini.com`), ( buyers_code_for_supplier, `86017` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_united_detergent_ind`, [ ( return_email, `lck@udi.com.my`), ( buyers_code_for_supplier, `50535199` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_visy_board`, [ ( return_email, `udo@visy.com.au`), ( buyers_code_for_supplier, `792330` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_visy_glama`, [ ( return_email, `udo@visy.com.au`), ( buyers_code_for_supplier, `792482` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_voxsup_singapore`, [ ( return_email, `tarun@4cinsights.com`), ( buyers_code_for_supplier, `50490693` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_w_o_pte`, [ ( return_email, `rigin@w3-o.com`), ( buyers_code_for_supplier, `50527108` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_wan_hai`, [ ( return_email, `lawrence_hong@wanhai.com`), ( buyers_code_for_supplier, `516653` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_wec_lines`, [ ( return_email, `hulya.sohrab@ke.weclines.com`), ( buyers_code_for_supplier, `545563` ) ], ( true ) ).
connection_lookup_table( ``, [ ( return_email, `duangporn@wha.co.th`), ( buyers_code_for_supplier, `565925` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_white_space`, [ ( return_email, `PEARL.LEONG@HOTMAIL.COM`), ( buyers_code_for_supplier, `50438192` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_wilmar_trading`, [ ( return_email, `wendy.lee@wilmar.com.sg`), ( buyers_code_for_supplier, `516960` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_wunderman_singapore`, [ ( return_email, `jeremy.chow@wunderman.com`), ( buyers_code_for_supplier, `545146` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_yang_kee_singapore`, [ ( return_email, `accountsreceivable@yangkee.com`), ( buyers_code_for_supplier, `50539222` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_yang_ming_singapore`, [ ( return_email, `acc-ar@sg.yangming.com`), ( buyers_code_for_supplier, `50527906` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_ych_group`, [ ( return_email, `gp_ychsg_ar@ych.com`), ( buyers_code_for_supplier, `50573931` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_dp_world`, [ ( return_email, `elvin.wong@dpworld.com`), ( buyers_code_for_supplier, `51630551` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pt_alliance`, [ ( return_email, `ppl.ind@alliance-world.com`), ( buyers_code_for_supplier, `51470485` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_evergreen_asia`, [ ( return_email, `bizmta@evergreen-marine.com.sg`), ( buyers_code_for_supplier, `50527903` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_geodis_wilson`, [ ( return_email, `seaimport.ff.sg@geodis.com`), ( buyers_code_for_supplier, `778957` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_bnt_communication`, [ ( return_email, `invoice@breadntea.vn`), ( buyers_code_for_supplier, `50569890` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_scrub_daddy`, [ ( return_email, `orders@scrubadaddy.com`), ( buyers_code_for_supplier, `51573809` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_kantar_singapore`, [ ( return_email, `Yvonne.Lim@tns-global.com`), ( buyers_code_for_supplier, `516483` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_expeditors_india`, [ ( return_email, `Ashutosh.Nath@tradewin.net`), ( buyers_code_for_supplier, `51435484` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_transmodal`, [ ( return_email, `maricel@transmodalphil.com`), ( buyers_code_for_supplier, `205517` ) ], ( true ) ).
connection_lookup_table( `ul_uapl_pt_perusahaan`, [ ( return_email, `wlandiani@mscid.com`), ( buyers_code_for_supplier, `553794` ) ], ( true ) ).