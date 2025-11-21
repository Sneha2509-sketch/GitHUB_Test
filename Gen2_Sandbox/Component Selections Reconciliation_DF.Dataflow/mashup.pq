[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared ReportTransfers = let
  Source = PostgreSQL.Database("localhost", DBName, [Query = "#(lf)select DISTINCT d.name_text,#(lf)                acs.selection_year,#(lf)                cr.name_text,#(lf)                tdl.source_customer_display_name,#(lf)                tdl.source_customer_code,#(lf)                tdl.destination_customer_display_name,#(lf)                tdl.destination_customer_code,#(lf)                tdl.date_created as Date_Transferred#(lf)from trutesta_client_deliverable.deliverable d#(lf)         inner join trutesta_client_deliverable.transfer_deliverable_log_entry tdle on tdle.deliverable_id = d.id#(lf)         inner join trutesta_client_deliverable.transfer_deliverable_log tdl#(lf)                    on tdl.id = tdle.transfer_deliverable_log_id#(lf)         inner join trutesta_certificate.certificate c on c.certificate_number = d.name_text#(lf)         inner join trutesta_certificate.component_selection cs on cs.certificate_id = c.id#(lf)         inner join trutesta_certificate.component_selection_entry cse on cse.component_selection_id = cs.id#(lf)         inner join trutesta_certificate.applicant_component_selection acs#(lf)                    on acs.id = cse.applicant_component_selection_id#(lf)         inner join trutesta_accreditation.certificate_region cr on cr.id = acs.region_id#(lf)WHERE #(lf)  d.deliverable_state = 'deliverable.state.official';#(lf)", CreateNavigationProperties = false])
in
  Source;
shared DBName = "gbs-trutesta-sandbox" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type text, List = {"gbs-trutesta-sandbox", "gbs-trutesta-production"}, DefaultValue = "gbs-trutesta-sandbox"];
shared #"Reports Withdrawn" = let
  Source = PostgreSQL.Database("localhost", DBName, [Query = "#(lf)-- SELECT selections that have reports withdrawn#(lf)select DISTINCT d.name_text,#(lf)                d.receive_customer_display_name,#(lf)                d.receive_customer_display_name,#(lf)                d.date_made_official as date_withdrawn,#(lf)                acs.selection_year,#(lf)                cr.name_text as region#(lf)from trutesta_client_deliverable.deliverable d#(lf)         inner join trutesta_certificate.certificate c on c.certificate_number = d.name_text#(lf)         inner join trutesta_certificate.component_selection cs on cs.certificate_id = c.id#(lf)         inner join trutesta_certificate.component_selection_entry cse on cse.component_selection_id = cs.id#(lf)         inner join trutesta_certificate.applicant_component_selection acs#(lf)                    on acs.id = cse.applicant_component_selection_id#(lf)         inner join trutesta_accreditation.certificate_region cr on cr.id = acs.region_id#(lf)WHERE #(lf)   d.deliverable_state = 'deliverable.state.withdrawn'", CreateNavigationProperties = false])
in
  Source;
shared #"DF Version" = "1.0.0" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type text];
shared CSR_DF_Version = let
  Source = #"DF Version",
  #"Converted to Table" = #table(1, {{Source}}),
  #"Renamed Columns" = Table.RenameColumns(#"Converted to Table", {{"Column1", "DF Version"}}),
  #"Transform columns" = Table.TransformColumnTypes(#"Renamed Columns", {{"DF Version", type text}}),
  #"Replace errors" = Table.ReplaceErrorValues(#"Transform columns", {{"DF Version", null}})
in
  #"Replace errors";
shared CSR_DBName = let
  Source = DBName,
  #"Converted to Table" = #table(1, {{Source}}),
  #"Renamed Columns" = Table.RenameColumns(#"Converted to Table", {{"Column1", "DBName"}}),
  #"Transform columns" = Table.TransformColumnTypes(#"Renamed Columns", {{"DBName", type text}}),
  #"Replace errors" = Table.ReplaceErrorValues(#"Transform columns", {{"DBName", null}})
in
  #"Replace errors";
shared CSR_DF_LastUpdated = let
    Source = DateTimeZone.UtcNow(),
    #"Convert to table" = Table.FromValue(Source),
    #"Renamed columns" = Table.RenameColumns(#"Convert to table", {{"Value", "Updated Time in UTC"}})
in
    #"Renamed columns";
