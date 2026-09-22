[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Project_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Project = let
  Source = PostgreSQL.Database("localhost", "gbs-trutesta-production", [CreateNavigationProperties = false]),
  #"Navigation 1" = Source{[Schema = "trutesta_project", Item = "project"]}[Data],
  #"Removed columns" = Table.RemoveColumns(#"Navigation 1", {"suppress_notifications", "suppress_client_notifications", "schedule_id", "date_completed",  "total_budget_hours", "estimate_id", "sample_note", "date_actual_ready", "compliance_state", "audit_rule_id", "auto_scan", "queue_id", "finance_template_id", "customer_product_id", "is_locked", "contract_id", "project_key", "business_service_type_id", "business_stream_id", "project_source_type", "date_hold", "hold_days", "prehold_state", "request_id", "job_number", "deliverable_customer_code",  "billing_policy_id",  "date_original_promised_complete",  "in_trash", "date_ordered", "purchase_order_number", "quote_number", "date_needed_by", "date_client_ready", "lastupdated_by_name", "date_last_updated", "created_by_name", "about_path", "json_payload", "reference_id", "description", "tenant_id"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Removed columns", {{"date_project_starts", type date}, {"date_project_ends", type date}}),
  #"Changed column type" = Table.TransformColumnTypes(#"Changed column type 1", {{"date_created", type date}}),
  #"Filtered rows" = Table.SelectRows(#"Changed column type", each [date_project_starts] >= #date(2022, 1, 1) and [date_project_starts] <= #date(2030, 12, 31)),
  #"Filtered rows 1" = Table.SelectRows(#"Filtered rows", each [date_project_ends] >= #date(2022, 1, 1) and [date_project_ends] <= #date(2030, 12, 31))
in
  #"Filtered rows 1";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Project_type_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Project_type = let
  Source = PostgreSQL.Database("localhost", "gbs-trutesta-production", [CreateNavigationProperties = false]),
  #"Navigation 1" = Source{[Schema = "trutesta_project", Item = "project_type"]}[Data],
  #"Removed columns" = Table.RemoveColumns(#"Navigation 1", {"customer_role_scheme_id", "tenant_id", "status", "description", "workflow_definition_id", "schema_form_id", "date_created", "created_by_name", "date_last_updated", "lastupdated_by_name", "tag_scheme_id", "document_placeholder_template_group_id", "request_type_id", "request_default_scheme_id", "project_rule_policy_id", "resource_library_id", "client_notification_template_tag_id", "project_number_regex", "auto_add_created_by", "default_user_role_id", "project_cancel_number_format", "compliance_category_group_id", "audit_rule_id"})
in
  #"Removed columns";
shared Project_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Project", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared Project_type_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Project_type", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Currency_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Currency = let
  Source = PostgreSQL.Database("localhost", "gbs-trutesta-production", [CommandTimeout = #duration(0, 0, 2, 0), Query = "SELECT currency.currency_iso_code,currency.description,currency.status,currency_format.format_expr, currency_exchange_rate.exchange_rate  FROM trutesta_currency.currency#(lf)inner join trutesta_currency.currency_format on currency.currency_format_id = currency_format.id#(lf)inner join trutesta_currency.currency_exchange_rate on currency_exchange_rate.currency_id = currency.id#(lf)inner join trutesta_currency.exchange_rate_period on currency_exchange_rate.exchange_rate_period_id = exchange_rate_period.id#(lf)where exchange_rate_period.current_period = 1", CreateNavigationProperties = false])
in
  Source;
shared Currency_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Currency", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Site_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Site = let
  Source = PostgreSQL.Database("localhost", "gbs-trutesta-production", [CommandTimeout = #duration(0, 0, 2, 0), Query = "SELECT site.id, #(lf)site.tenant_id, #(lf)site.name_text AS site_name, #(lf)regexp_replace(regexp_replace(site.name_text, 'Unites', 'United'), '^Intertek (United States|United Kingdom|Sri Lanka|United Arab Emirates|[A-Za-z0-9_]*) (.*)', '\2 (Intertek \1)') as nice_name #(lf)FROM trutesta_delivery_organizations.site #(lf)where site.id in (select distinct organization.site_id from trutesta_delivery_organizations.organization)", CreateNavigationProperties = false]),
  #"Removed columns" = Table.RemoveColumns(Source, {"tenant_id", "site_name"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed columns", {{"nice_name", "Site"}})
in
  #"Renamed columns";
shared Site_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Site", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Organization_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Organization = let
  Source = PostgreSQL.Database("localhost", "gbs-trutesta-production", [CommandTimeout = #duration(0, 0, 2, 0), Query = "SELECT distinct organization.id, #(lf)organization.name_text AS organization_name, #(lf)organization.site_id, organization.status, #(lf)regexp_replace(organization.name_text, 'Intertek (United States|United Kingdom|Sri Lanka|United Arab Emirates|[A-Za-z0-9_]*) (.*)', '\2 (Intertek \1)') as nice_name #(lf)FROM trutesta_delivery_organizations.organization#(lf)inner join trutesta_resource.resource on organization.id = resource.organization_id", CreateNavigationProperties = false]),
  #"Removed columns" = Table.RemoveColumns(Source, {"organization_name", "status"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed columns", {{"nice_name", "Organization"}})
in
  #"Renamed columns";
shared Organization_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Organization", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Customer_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Customer = let
  Source = PostgreSQL.Database("localhost", "gbs-trutesta-production", [CreateNavigationProperties = false]),
  #"Navigation 1" = Source{[Schema = "trutesta_crm", Item = "customer"]}[Data],
  #"Removed columns" = Table.RemoveColumns(#"Navigation 1", {"is_credit_hold", "country_iso_code", "tenant_id", "account_id", "finance_system_id", "customer_code", "description", "status", "date_created", "created_by_name", "date_last_updated", "lastupdated_by_name", "legal_name", "dba_name", "about_path", "reference_id", "data_origin_code", "duns_number", "currency_iso_code", "payment_terms", "credit_limit", "credit_limit_currency_iso_code", "formerly_known_as", "customer_status", "language_id", "date_credit_hold", "shipping_account_number"})
in
  #"Removed columns";
shared Customer_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Customer", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "deliverable_type_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared deliverable_type = let
  Source = PostgreSQL.Database("localhost", "gbs-trutesta-production", [CommandTimeout = #duration(0, 0, 5, 0), CreateNavigationProperties = false]),
  #"Navigation 1" = Source{[Schema = "trutesta_client_deliverable", Item = "deliverable_type"]}[Data],
  #"Removed columns" = Table.RemoveColumns(#"Navigation 1", {"deliverable_watermark_policy_id", "resource_library_id", "checklist_document_id", "status", "date_created", "created_by_name", "date_last_updated", "lastupdated_by_name", "deliverable_category", "requires_tags", "can_be_revised", "expire_duration", "approval_review_workflow_id", "approval_review_workflow_revision_id", "supports_approval_workflow", "deliverable_name_case", "deliverable_name_reg_ex", "document_placeholder_template_group_id", "template_library_id", "template_tag_id", "template_id", "checklist_id", "deliverable_expiration_policy_id", "document_upload_policy_id", "revision_rule_id", "is_type_certification", "surveillance_policy_id", "report_revision_form_id", "audit_entity_component_scheme_id", "supports_internal_audits", "supports_external_audits", "allow_report_metadata_integration", "supports_product_ratings", "product_rating_set_id", "business_code", "tenant_id", "description"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed columns", {{"name_text", "Deliverable Type"}})
in
  #"Renamed columns";
shared deliverable_type_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "deliverable_type", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "project_requested_deliverable_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared project_requested_deliverable = let
  Source = PostgreSQL.Database("localhost", "gbs-trutesta-production"),
  #"Navigation 1" = Source{[Schema = "trutesta_project", Item = "project_requested_deliverable"]}[Data],
  #"Removed columns" = Table.RemoveColumns(#"Navigation 1", {"tenant_id", "date_created", "created_by_name", "date_last_updated", "lastupdated_by_name", "deliverable_contact_id", "deliverable_id", "date_promised", "date_canceled", "work_user_id", "reviewer_user_id", "estimate_id", "schedule_id", "deliverable_state", "deliverable_customer_id", "customer_product_id", "total_budget_hours", "amount_fee", "date_client_ready", "date_actual_ready", "date_scheduled_start", "date_scheduled_end", "date_actual_complete", "actual_revenue", "organization_id", "test_plan_id", "trutesta_project.project", "trutesta_project.project_standard"}),
  #"Removed duplicates" = Table.Distinct(#"Removed columns", {"project_id"})
in
  #"Removed duplicates";
shared project_requested_deliverable_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "project_requested_deliverable", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Calendar_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Calendar = let
    StartDate = #date(2022, 1, 1),
    EndDate = #date(2030, 12, 31),

    Dates =
        List.Dates(
            StartDate,
            Duration.Days(EndDate - StartDate) + 1,
            #duration(1, 0, 0, 0)
        ),

    DateTable =
        Table.FromList(
            Dates,
            Splitter.SplitByNothing(),
            {"Date"}
        ),

    #"Changed Type" =
        Table.TransformColumnTypes(
            DateTable,
            {{"Date", type date}}
        ),

    #"Added Year" =
        Table.AddColumn(
            #"Changed Type",
            "Year",
            each Date.Year([Date]),
            Int64.Type
        ),

    #"Added Month Number" =
        Table.AddColumn(
            #"Added Year",
            "Month Number",
            each Date.Month([Date]),
            Int64.Type
        ),

    #"Added Month Name" =
        Table.AddColumn(
            #"Added Month Number",
            "Month Name",
            each Date.MonthName([Date]),
            type text
        ),

    #"Added Quarter" =
        Table.AddColumn(
            #"Added Month Name",
            "Quarter",
            each "Q" & Text.From(Date.QuarterOfYear([Date])),
            type text
        ),

    #"Added Day" =
        Table.AddColumn(
            #"Added Quarter",
            "Day",
            each Date.Day([Date]),
            Int64.Type
        )
in
    #"Added Day";
shared Calendar_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "c1ee17ca-231f-4966-b6ea-e2487379bec8"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3af690ca-b4af-481c-9f3c-e316a9e4cb67"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Calendar", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
