section Section1;
shared resource = let
  Source = PostgreSQL.Database("localhost", DBName),
  #"Navigation 1" = Source{[Schema = "trutesta_resource", Item = "resource"]}[Data],
  #"From Value" = Table.FromValue(#"Navigation 1"),
  #"Remove Columns" = Table.RemoveColumns(#"From Value", Table.ColumnsOfType(#"From Value", {type table, type record, type list, type nullable binary, type binary, type function}))
in
  #"Remove Columns";
shared DBName = "gbs-trutesta-sandbox" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type text, List = {"gbs-trutesta-sandbox", "gbs-trutesta-production"}, DefaultValue = "gbs-trutesta-sandbox"];
shared Organization = let
  Source = PostgreSQL.Database("localhost", DBName, [CommandTimeout = #duration(0, 0, 2, 0), Query = "SELECT distinct organization.id, #(lf)organization.name_text AS organization_name, #(lf)organization.site_id, organization.status, #(lf)regexp_replace(organization.name_text, 'Intertek (United States|United Kingdom|Sri Lanka|United Arab Emirates|[A-Za-z0-9_]*) (.*)', '\2 (Intertek \1)') as nice_name #(lf)FROM trutesta_delivery_organizations.organization#(lf)inner join trutesta_resource.resource on organization.id = resource.organization_id", CreateNavigationProperties = false])
in
  Source;
