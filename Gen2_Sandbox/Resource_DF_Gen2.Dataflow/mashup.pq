section Section1;
shared resource = let
  Source = PostgreSQL.Database("localhost", DBName),
  #"Navigation 1" = Source{[Schema = "trutesta_resource", Item = "resource"]}[Data],
  #"From Value" = Table.FromValue(#"Navigation 1"),
  #"Remove Columns" = Table.RemoveColumns(#"From Value", Table.ColumnsOfType(#"From Value", {type table, type record, type list, type nullable binary, type binary, type function}))
in
  #"Remove Columns";
shared DBName = "gbs-trutesta-production" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type text, List = {"gbs-trutesta-sandbox", "gbs-trutesta-production"}, DefaultValue = "gbs-trutesta-sandbox"];
