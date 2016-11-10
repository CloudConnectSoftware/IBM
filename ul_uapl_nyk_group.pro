%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - NYK GROUP SOUTH ASIA PTE LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_nyk_group, `27/10/2016` `4:30:05` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details
	
	, get_invoice_number

 	, get_invoice_date

    , get_due_date

	, get_total_invoice

    , get_currency

    , get_invoice_lines

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================
  
      sender_name(`NYK GROUP SOUTH ASIA PTE LTD`)

      ,supplier_vat_number(`M2-0061035X`)

	   , set(freight_vendor)

       ,currency( `USD` )

           ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================
    
    q0n(line)

    , or([
        generic_horizontal_details( [ [ `Invoice`, `No`, `.`, tab], invoice_number, s1, newline ] )

   , generic_vertical_details( [ [ `INVOICE`, `NUMBER`], `INVOICE`, q(0,2), (start,10,10), invoice_number, s1, tab ] )

    ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================

 q0n(line)

  , or([
        generic_horizontal_details( [ [`Issue`, `Date`, tab ], invoice_date_raw, s1, tab ] )

    , generic_vertical_details( [ [ `Issue`, `Date`, q10(tab) ], `DATE`, q(0,2), (start,10,10), invoice_date_raw , s1, newline ] )

    ])

    , check( invoice_date_raw = DateRaw )    , trace( [ `Date raw` , DateRaw ] )

    , check(q_sys_sub_string( DateRaw, 1,2 , Substring1 ))    , trace( [ `Date raw1` , Substring1 ] )

    , check(q_sys_sub_string( DateRaw, 3,3 , Substring2 ))    , trace( [ `Date raw2` , Substring2 ] )

    , check(q_sys_sub_string( DateRaw, 6, 4 , Substring3 ))   , trace( [ `Date raw3` , Substring3 ] )

    , check(strcat_list( [ Substring1,` ` , Substring2,` `, Substring3 ], DateNew ))   , trace( [ `New Date Format` , DateNew ] ) 
    
	, invoice_date(DateNew)  , trace( [ `Invoice Date Now` , invoice_date ] )

   
    ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================    
i_rule( get_due_date, [
%=======================================================================

    q0n(line)

      , generic_vertical_details( [ [ `DUE`, `DATE` ], `DATE`, q(0,2), (start,10,10), due_date_raw, s1, newline ] )

      , check( due_date_raw = DueRaw )    , trace( [ `Due Date raw` , DueRaw ] )   
      
    , check(q_sys_sub_string( DueRaw, 1,2 , Duestring1 ))      , trace( [ `Due Date raw1` , Duestring1 ] )
 
    , check(q_sys_sub_string( DueRaw, 3,3 , Duestring2 ))       , trace( [ `Due Date raw2` , Duestring2 ] )  
    
    , check(q_sys_sub_string( DueRaw, 6, 4 , Duestring3 ))       , trace( [ `Due Date raw3` , Duestring3 ] )

    ,check(strcat_list( [ Duestring1,` ` , Duestring2,` `, Duestring3 ], DueDateNew ))   , trace( [ `New Due Date Format` , DueDateNew ] )

	, due_date(DueDateNew)    , trace( [ `Due Date Now` , due_date ] )

      
      ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

     q0n(line)

    , or([
        generic_horizontal_details( [ [ `GRAND`, `TOTAL`, `AMOUNT`, `IN`,  `USD` ], 800, total_invoice, d, newline ] )

        , generic_horizontal_details( [ [ `B`, `/`, `L`, `SUB`, `-`, `TOTAL`, `:`, tab ], total_invoice, d, newline ] )

    ])

    , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv ] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )

        ,total_vat(`0`)

] ).


